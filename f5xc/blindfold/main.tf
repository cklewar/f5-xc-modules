curl -X 'POST' -d @request.json -H 'Content-Type: application/json' 'https://ves-io.demo1.volterra.us/api/secret_management/namespaces/system/secret_policy_rules'
curl -X 'POST' -d @request.json -H 'Content-Type: application/json' 'https://ves-io.demo1.volterra.us/api/secret_management/namespaces/system/secret_policys'

vesctl \
      --cert file:///$HOME/.ves-internal/demo1/usercerts.crt \
      --key file:///$HOME/.ves-internal/demo1/usercerts.key \
      --cacert file:///$HOME/.ves-internal/demo1/cacerts/public_server_ca.crt  \
      --server-urls https://ves-io.demo1.volterra.us/api \
      request secrets get-policy-document --namespace system --name ver-secret-policy


vesctl \
      --cert file:///<absolute_path_to_crt> \
      --key file:///<absolute_path_to_key> \
      --cacert file:///<absolute_path_to_truststore> \
      --server-urls https://ves-io.demo1.volterra.us/api \
      request secrets get-public-key

./vesctl request secrets encrypt \
        --policy-document <path to Policy Doc file>
        --public-key <path to Key Parameters Doc file> \
        <path to secret file>
