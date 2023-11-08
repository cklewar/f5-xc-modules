import argparse
import io
import json
from dataclasses import asdict, dataclass
from datetime import datetime
from enum import Enum
from pathlib import Path
from typing import Any, Dict

import boto3
from botocore.exceptions import ClientError, ParamValidationError
from dacite import Config, from_dict
from jinja2 import Environment, FileSystemLoader, select_autoescape
from jinja2.environment import Template
from requests import Session, Response

F5XC_SYSTEM_NAMESPACE = "system"
F5XC_CREDENTIAL_DELETE_URI = f"web/namespaces/{F5XC_SYSTEM_NAMESPACE}/revoke/api_credentials"
F5XC_CREDENTIAL_POST_URI = f"web/namespaces/{F5XC_SYSTEM_NAMESPACE}/api_credentials"
F5XC_CREDENTIAL_GET_URI = f"web/namespaces/{F5XC_SYSTEM_NAMESPACE}/api_credentials"
F5XC_API_CERT_EXPIRATION_DAYS = "10"
F5XC_API_CERT_PASSWORD = ""
HEADERS = {
    'Accept': 'application/data',
    'Content-Type': 'application/data',
    'Access-Control-Allow-Origin': '*',
    'Authorization': 'APIToken',
    'x-volterra-apigw-tenant': ''
}
POST_PAYLOAD_TEMPLATE_FILE = "post.tpl"
DELETE_PAYLOAD_TEMPLATE_FILE = "delete.tpl"
API_MODULE_PATH = "modules/f5xc/api-credential"
TEMPLATE_DIRECTORY_NAME = "templates"
TEMPLATE_DIRECTORY = f"{API_MODULE_PATH}/{TEMPLATE_DIRECTORY_NAME}"
# TEMPLATE_DIRECTORY = f"{os.getcwd()}/{TEMPLATE_DIRECTORY_NAME}"
STATE_FILE_DIR_ROOT = "_out"
STATE_FILE_DIR = f"{API_MODULE_PATH}/{STATE_FILE_DIR_ROOT}"
# STATE_FILE_DIR = f"{os.getcwd()}/{STATE_FILE_DIR_ROOT}"
STATE_FILE_NAME = "state.json"
STORAGE_INTERNAL = "internal"
STORAGE_AWS_S3 = "s3"
STORAGE_AWS_S3_REGION = "us-east-1"


class Action(Enum):
    POST = "post"
    GET = "get"
    DELETE = "delete"


class F5XCApiCredentialTypes(Enum):
    KUBE_CONFIG = "kube_config"
    API_CERTIFICATE = "api_certificate"

    @classmethod
    def get_credential_types(cls):
        return list(cls.__members__.keys())

    @classmethod
    def is_member(cls, value: str = None) -> bool:
        return True if value in cls.__members__.keys() else False


@dataclass
class State:
    """Class for keeping state API Credential data."""
    data: str
    name: str
    active: bool
    expiration_timestamp: str

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> "State":
        return from_dict(cls, data, config=Config({datetime: datetime.fromisoformat}))

    def to_dict(self) -> Dict[str, Any]:
        return asdict(self)


class APICredential:
    def __init__(self, api_url: str = None, api_token: str = None, tenant: str = None, expiration_days: str = None, namespace: str = None, credential_type: str = None,
                 virtual_k8s_name: str = None, post_payload_template_file: str = None, delete_payload_template_file: str = None,
                 template_directory: str = None, headers: dict = None, name: str = None, virtual_k8s_namespace: str = None, modules_path: str = None,
                 storage: str = STORAGE_INTERNAL, storage_aws_s3_region: str = None, storage_aws_s3_bucket: str = None, storage_aws_s3_key: str = None):
        if api_url is None:
            raise ValueError('"api_url" must not be None')
        else:
            self._url = api_url
            self._get_url = f"{api_url}/{F5XC_CREDENTIAL_GET_URI}"
            self._create_url = f"{api_url}/{F5XC_CREDENTIAL_POST_URI}"
            self._delete_url = f"{api_url}/{F5XC_CREDENTIAL_DELETE_URI}"
        if api_token is None:
            raise ValueError('"api_token" must not be None')
        else:
            self._api_token = api_token
        self._name = name
        if tenant is None:
            raise ValueError('"tenant" must not be None')
        else:
            self._tenant = tenant
        self._expiration_days = F5XC_API_CERT_EXPIRATION_DAYS if expiration_days is None else expiration_days
        self._namespace = F5XC_SYSTEM_NAMESPACE if namespace is None else namespace
        self._credential_type = credential_type
        self._virtual_k8s_name = virtual_k8s_name
        self._virtual_k8s_namespace = virtual_k8s_namespace
        self._certificate_password = None
        if headers is None:
            HEADERS["Authorization"] = f"APIToken {api_token}"
            HEADERS["x-volterra-apigw-tenant"] = f"{tenant}"
            HEADERS["Content-Type"] = "application/json"
            self._headers = HEADERS if headers is None else headers
        else:
            self._headers = headers
        self._post_payload_template_file = POST_PAYLOAD_TEMPLATE_FILE if post_payload_template_file is None else post_payload_template_file
        self._delete_payload_template_file = DELETE_PAYLOAD_TEMPLATE_FILE if delete_payload_template_file is None else delete_payload_template_file
        self._template_directory = f"{modules_path}/{TEMPLATE_DIRECTORY}" if template_directory is None else f"{modules_path}/{template_directory}"
        self._session = Session()
        self._storage = storage
        self._storage_aws_s3_region = STORAGE_AWS_S3_REGION if storage_aws_s3_region is None else storage_aws_s3_region
        self._storage_aws_s3_bucket = storage_aws_s3_bucket
        self._storage_aws_s3_key = storage_aws_s3_key
        self._state_file_dir = f"{modules_path}/{STATE_FILE_DIR}/{self.name}"
        self._state_file = f"{self._state_file_dir}/{STATE_FILE_NAME}"

        if self.storage == STORAGE_AWS_S3:
            print("Loading state...")
            self._client = self.auth()
            buffer = io.BytesIO()
            bucket = boto3.resource('s3', region_name=self._storage_aws_s3_region).Bucket(self.storage_aws_s3_bucket)

            if bool(list(bucket.objects.filter(Prefix=self.storage_aws_s3_key))):
                try:
                    self._client.download_fileobj(Bucket=self.storage_aws_s3_bucket, Key=self.storage_aws_s3_key, Fileobj=buffer)
                    self._state = State.from_dict(json.loads(buffer.getvalue().decode()))
                    print("Loading state... Done")
                except ClientError as ce:
                    print(ce.response)
            else:
                self._state = None

        elif self.storage == STORAGE_INTERNAL:
            if Path(self._state_file).is_file():
                print("Loading state...")
                with open(self._state_file, "r") as fp:
                    try:
                        self._state = State.from_dict(json.load(fp))
                        print("Loading state... Done")
                    except json.decoder.JSONDecodeError as err:
                        print(f"Loading state failed with error --> {err}")
            else:
                self._state = None

    def __str__(self):
        return self.name

    @property
    def name(self) -> str:
        return self._name

    @name.setter
    def name(self, name: str = None):
        if name is None:
            raise ValueError('"name" must not be none') from None
        try:
            self._name = str(name)
        except ValueError:
            raise ValueError('"name" must be string') from None

    @property
    def expiration_days(self) -> str:
        return self._expiration_days

    @expiration_days.setter
    def expiration_days(self, days: str = None):
        if days is None:
            raise ValueError('"expiry days must not be none') from None
        try:
            self._expiration_days = str(days)
        except ValueError:
            raise ValueError('"expiry days" must be string') from None

    @property
    def namespace(self) -> str:
        return self._namespace

    @namespace.setter
    def namespace(self, name: str = None):
        if name is None:
            raise ValueError('"name" must not be none') from None
        try:
            self._namespace = str(name)
        except ValueError:
            raise ValueError('"name" must be string') from None

    @property
    def credential_type(self) -> str:
        return self._credential_type

    @credential_type.setter
    def credential_type(self, credential_type: str = None):
        if credential_type is None:
            raise ValueError('"credential_type" must not be none') from None
        if credential_type is None or F5XCApiCredentialTypes.is_member(value=credential_type) is False:
            raise ValueError(f'"credential_type" must be one of "{F5XCApiCredentialTypes.get_credential_types()}"')
        try:
            self._credential_type = str(credential_type)
        except ValueError:
            raise ValueError('"credential_type" must be string') from None

    @property
    def virtual_k8s_name(self) -> str:
        return self._virtual_k8s_name

    @virtual_k8s_name.setter
    def virtual_k8s_name(self, name: str = None):
        if name is None:
            raise ValueError('"name" must not be none') from None
        try:
            self._virtual_k8s_name = str(name)
        except ValueError:
            raise ValueError('"name" must be string') from None

    @property
    def virtual_k8s_namespace(self) -> str:
        return self._virtual_k8s_namespace

    @virtual_k8s_namespace.setter
    def virtual_k8s_namespace(self, namespace: str = None):
        if namespace is None:
            raise ValueError('"namespace" must not be none') from None
        try:
            self._virtual_k8s_namespace = str(namespace)
        except ValueError:
            raise ValueError('"namespace" must be string') from None

    @property
    def post_payload_template_file(self) -> str:
        return self._post_payload_template_file

    @property
    def delete_payload_template_file(self) -> str:
        return self._delete_payload_template_file

    @property
    def template_directory(self) -> str:
        return self._template_directory

    @property
    def headers(self) -> dict:
        return self._headers

    @headers.setter
    def headers(self, headers: dict = None):
        if headers is None:
            raise ValueError('"headers" must not be none') from None
        try:
            self._headers = dict(headers)
        except ValueError:
            raise ValueError('"headers" must be dict') from None

    @property
    def certificate_password(self) -> str:
        return self._certificate_password

    @certificate_password.setter
    def certificate_password(self, password: str = None):
        if password is None:
            raise ValueError('"password" must not be none') from None
        try:
            self._certificate_password = str(password)
        except ValueError:
            raise ValueError('"password" must be str') from None

    @property
    def state(self) -> dict:
        return self._state

    @property
    def storage(self) -> str:
        return self._storage

    @property
    def storage_aws_s3_region(self) -> str:
        return self._storage_aws_s3_region

    @storage_aws_s3_region.setter
    def storage_aws_s3_region(self, value: str = None):
        try:
            self._storage_aws_s3_region = str(value)
        except ValueError:
            raise ValueError('"value" must be str') from None

    @property
    def storage_aws_s3_bucket(self) -> str:
        return self._storage_aws_s3_bucket

    @storage_aws_s3_bucket.setter
    def storage_aws_s3_bucket(self, value: str = None):
        try:
            self._storage_aws_s3_bucket = str(value)
        except ValueError:
            raise ValueError('"value" must be str') from None

    @property
    def storage_aws_s3_key(self) -> str:
        return self._storage_aws_s3_key

    @storage_aws_s3_key.setter
    def storage_aws_s3_key(self, value: str = None):
        try:
            self._storage_aws_s3_key = str(value)
        except ValueError:
            raise ValueError('"value" must be str') from None

    def _gen_post_template_vars(self) -> dict:
        _vars = {
            "expiration_days": self.expiration_days,
            "name": self.name,
            "namespace": self.namespace,
            "password": self.certificate_password,
            "type": self.credential_type,
            "virtual_k8s_name": self.virtual_k8s_name,
            "virtual_k8s_namespace": self.virtual_k8s_namespace
        }
        return _vars

    def _gen_delete_template_vars(self) -> dict:
        _vars = {
            "name": self.state.name,
            "namespace": self.namespace,
        }
        return _vars

    def _get_template_file(self, template_file: str = None) -> Template:
        env = Environment(loader=FileSystemLoader(self.template_directory), autoescape=select_autoescape())
        return env.get_template(template_file)

    def state_to_json(self):
        return json.dumps(self, default=lambda o: o.state)

    def get(self) -> Response:
        with self._session as s:
            print("GET request url:", f"{self._get_url}/{self.state.name}")
            return s.get(url=f"{self._get_url}/{self.state.name}", headers=self.headers)

    def post(self) -> Response:
        with self._session as s:
            print("POST request url:", self._create_url)
            print((self._get_template_file(self.post_payload_template_file).render(vars=self._gen_post_template_vars())))
            return s.post(url=self._create_url, headers=self.headers, data=(self._get_template_file(self.post_payload_template_file).render(vars=self._gen_post_template_vars())))

    def delete(self) -> Response:
        with self._session as s:
            print("DELETE request url:", self._delete_url)
            return s.post(url=self._delete_url, headers=self.headers, data=(self._get_template_file(self.delete_payload_template_file).render(vars=self._gen_delete_template_vars())))

    def create_state(self, data: dict) -> bool:
        if not Path(self._state_file_dir).exists():
            print(f"Creating state file output directory <{self._state_file_dir}>...")
            try:
                path = Path(self._state_file_dir)
                path.mkdir(parents=True)
                print(f"Creating state file output directory <{self._state_file_dir}> -> Done")
                if self.storage == STORAGE_INTERNAL:
                    try:
                        with open(self._state_file, "w") as fd:
                            fd.write(json.dumps(data, indent=4))
                            return True
                    except (FileNotFoundError, FileExistsError) as err:
                        print("Error:", err)
                        return False

                elif self.storage == STORAGE_AWS_S3:
                    if self.storage_aws_s3_region is not None and self.storage_aws_s3_bucket is not None and self.storage_aws_s3_key is not None:
                        try:
                            self._client.put_object(Bucket=self.storage_aws_s3_bucket, Key=self.storage_aws_s3_key, Body=json.dumps(data, indent=4))
                            try:
                                with open(self._state_file, "w") as fd:
                                    fd.write(json.dumps(data, indent=4))
                                    return True
                            except (FileNotFoundError, FileExistsError) as err:
                                print("Error:", err)
                                return False
                        except ParamValidationError as pve:
                            print(f"Creating state {self.storage_aws_s3_bucket} failed with error: {pve}")
                            return False
                    else:
                        print(f"Storage type <{self.storage}> needs bucket, key and region set")
                        return False
                else:
                    print(f"Unknown storage type <{self.storage}>")
                    return False
            except OSError as error:
                if error.errno == 17:
                    return True
                else:
                    print(f"Create state file output directory <{data['name']}> failed with error: <{error}> ")
                    return False
        else:
            print(f"State file directory <{data['name']}> does not exists. Stopping here")
            return False

    def delete_state(self) -> bool:
        if self.storage == STORAGE_INTERNAL:
            try:
                Path(self._state_file).unlink()
                print(f"Removing state file successful")
                Path(self._state_file_dir).rmdir()
                print(f"Removing state file directory successful")
                return True
            except FileNotFoundError as err:
                print(f"Removing state file failed with error: {err}")
                return False
        elif self.storage == STORAGE_AWS_S3:
            if self.storage_aws_s3_region is not None and self.storage_aws_s3_bucket is not None and self.storage_aws_s3_key is not None:
                try:
                    self._client.delete_object(Bucket=self.storage_aws_s3_bucket, Key=self.storage_aws_s3_key)
                    Path(self._state_file).unlink()
                    print(f"Removing state file successful")
                    Path(self._state_file_dir).rmdir()
                    print(f"Removing state file directory successful")
                    return True
                except ParamValidationError as pve:
                    print(f"Deleting state {self.storage_aws_s3_bucket} failed with error: {pve}")
                    return False
            else:
                print(f"Storage type <{self.storage}> needs bucket, key and region set")
                return False
        else:
            print(f"Unknown storage type <{self.storage}>")
            return False

    def check_state_file(self) -> bool:
        return Path(self._state_file).is_file()

    def auth(self) -> boto3.client:
        return boto3.client('s3', region_name=self.storage_aws_s3_region)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(prog="main", description="F5 XC API Credential helper")
    parser.add_argument("action", help="CRUD operation to run (get/post/delete)", type=str)
    parser.add_argument("api_url", help="F5XC API URL", type=str)
    parser.add_argument("api_token", help="F5XC API TOKEN", type=str)
    parser.add_argument("tenant", help="F5XC Tenant", type=str)
    parser.add_argument("name", help="API Credential Object Name", type=str)
    parser.add_argument("modules_path", help="Root path to modules", type=str)
    parser.add_argument("storage", help="F5XC API Credential Storage type (internal/s3)", type=str)
    parser.add_argument("-v", "--vk8s", help="F5XC Virtual k0s Name", type=str)
    parser.add_argument("-client", "--ctype", help="F5XC Credential Type", type=str)
    parser.add_argument("-n", "--namespace", help="F5XC Credential Namespace", type=str)
    parser.add_argument("-p", "--certpw", help="F5XC API Certificate Password", type=str)
    parser.add_argument("-e", "--expiry", help="F5XC API Credential Expiry Days", type=str)
    parser.add_argument("-r", "--region", help="F5XC API Credential AWS S3 Region", type=str)
    parser.add_argument("-b", "--bucket", help="F5XC API Credential AWS S3 Bucket", type=str)
    parser.add_argument("-k", "--key", help="F5XC API Credential AWS S3 Key", type=str)
    args = parser.parse_args()
    apic = APICredential(api_url=args.api_url, api_token=args.api_token, tenant=args.tenant, name=args.name, modules_path=args.modules_path, storage=args.storage, storage_aws_s3_region=args.region,
                         storage_aws_s3_bucket=args.bucket, storage_aws_s3_key=args.key)

    if args.action == Action.GET.value:
        if apic.state is None:
            print("No local state found... Leaving now...")
        else:
            print(f"Initiate {Action.GET.name} request")
            r = apic.get()
            if r.status_code == 200:
                print("GET request... Done")
            else:
                print(f"Response Status Code: {r.status_code} --> Response Message: {r.json()}")
    elif args.action == Action.POST.value:
        if F5XCApiCredentialTypes.is_member(value=args.ctype) is False:
            raise ValueError(f'"ctype" must be one of "{F5XCApiCredentialTypes.get_credential_types()}"')
        if args.ctype == F5XCApiCredentialTypes.KUBE_CONFIG.name and args.vk8s is None:
            raise ValueError(f'"vk8s" must not be None if "ctype" is of type {F5XCApiCredentialTypes.KUBE_CONFIG.name}')
        apic.credential_type = args.ctype
        apic.virtual_k8s_name = args.vk8s if apic.credential_type == F5XCApiCredentialTypes.KUBE_CONFIG.name else ""
        apic.expiration_days = args.expiry if args.expiry is not None else F5XC_API_CERT_EXPIRATION_DAYS
        apic.virtual_k8s_namespace = args.namespace if apic.credential_type == F5XCApiCredentialTypes.KUBE_CONFIG.name else ""
        apic.certificate_password = args.certpw if apic.credential_type == F5XCApiCredentialTypes.API_CERTIFICATE.name else ""
        print(f"Initiate {Action.POST.name} request")

        if apic.state is None:
            print("Found no local state... Creating new object...")
            r = apic.post()
            if r.status_code == 200:
                print("Creating new object... Done. Creating state:", apic.create_state(data=r.json()))
            else:
                print("R:", r)
                # print(f"Response Status Code: {r.status_code} --> Response Message: {r.json()}")
        else:
            print("Found local state... Checking object exists...")
            r = apic.get()
            if r.status_code == 200:
                print("Checking object exists... Done. Not creating new object")
            else:
                print("Found local state, but object does not exists. Creating object...")
                r = apic.post()
                if r.status_code == 200:
                    print("Creating new object... Done. Creating state:", apic.create_state(data=r.json()))
                else:
                    print(f"Response Status Code: {r.status_code} --> Response Message: {r.json()}")
    elif args.action == Action.DELETE.value:
        if apic.state is None:
            print("No local state found... Leaving now...")
        else:
            print(f"Initiate {Action.DELETE.name} request")
            r = apic.delete()
            if r.status_code == 200:
                print("DELETE request... Done. Removing state:", apic.delete_state())
            else:
                print(f"Response Status Code: {r.status_code} --> Response Message: {r.json()}")
    else:
        raise ValueError(f"Action <{args.action}> not implemented")
