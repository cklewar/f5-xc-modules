variable "deployment" {
  default = "re-config-any"
}

variable "template_suffix" {
  default = "azure"
}

variable "certified_hardware_endpoint" {
  default = ""
}

variable "reboot_strategy_master" {
  default = "off"
}

// We can't use etcd lock because there is no etcd config in pools
variable "reboot_strategy_pool" {
  default = "off"
}

variable "bootstrap_token_id" {
  default = ""
}

variable "bootstrap_token_secret" {
  default = ""
}

variable "etcd_initial_token" {
  default = "68c11f9e8d0c61a56a7ad46667294fe3"
}

variable "public_address" {
  default = "10.0.0.1"
}

variable "public_name" {
  default = "lb.example.local"
}

variable "ca_certificate" {
  description = "Existing PEM-encoded CA certificate (generated if blank)"
  type        = string
  default     = ""
}

variable "ca_key_alg" {
  description = "Algorithm used to generate ca_key (required if ca_cert is specified)"
  type        = string
  default     = "RSA"
}

variable "ca_private_key" {
  description = "Existing Certificate Authority private key (required if ca_certificate is set)"
  type        = string
  default     = ""
}

variable "container_images" {
  type = map(string)

  default = {
    "Hyperkube" = ""
    "CoreDNS"   = ""
    "Etcd"      = ""
  }
}

variable "service_cidr" {
  default = "10.3.0.0/16"
}

variable "dns_service_ip" {
  default = "10.3.0.10"
}

variable "cluster_cidr" {
  default = "10.8.0.0/16"
}

variable "cluster_latitude" {
  default = "39.8282"
}

variable "cluster_longitude" {
  default = "-98.5795"
}

variable "cluster_workload" {
  default = ""
}

variable "cluster_name" {
  default = ""
}

variable "private_default_gw" {
  default = ""
}

variable "private_vn_prefix" {
  default = ""
}

variable "cluster_token" {
  default = ""
}

variable "cluster_labels" {
}

variable "customer_route" {
  default = ""
}

variable "vp_manager_version" {
  default = "latest"
}

variable "vp_manager_type" {
  default = "re"
}

variable "vp_manager_skip_stages" {
  default     = ["register"]
  type        = list(string)
  description = "List of VP manager stages to skip"
}

# DEPRECATED
variable "vp_manager_master_skip_stages" {
  default     = ["register", "ver"]
  type        = list(string)
  description = "List of VP manager stages to skip"
}

variable "vp_manager_mask_fetch_latest" {
  default = "true"
}

variable "maurice_mtls_endpoint" {
  default = ""
}

variable "maurice_endpoint" {
  default = ""
}

variable "pikachu_endpoint" {
  default = ""
}

# DEPRECATED, no longer used by vpm
variable "dns_zone_name" {
  default = ""
}

variable "rsa_bits" {
  default = "1024"
}

variable "tls_algo" {
  default = "RSA"
}

variable "sre_dns_service_ip" {
  default = ""
}

variable "cluster_uid" {
  default = ""
}

# local resolvable name of the k8s cluster nodes
variable "cluster_members" {
  type    = list(string)
  default = ["master-0", "master-1", "master-2"]
}

# master_count shall correspond with cluster_members
variable "master_count" {
  default = 1
}

variable "mask_hugepages_service" {
  # default false, as long as VER now runs on master nodes as well
  default = "false"
}

variable "user_name" {
  default = "vesopcon"
}

variable "user_password" {
  default = ""
}

variable "user_pubkey" {
  default = ""
}

variable "ntp_servers" {
  default = "time.google.com"
}

## CLOUD_CONFIG FOR PHYSICAL NODES

# fabric (private) interface (DPDK, 10Gb/s)
variable "nic_fabric" {
  default = ""
}

# public interface (DPDK, 10Gb/s)
variable "nic_public" {
  default = ""
}

variable "ves_env" {
  default = "staging"
}

# First line regular CA, 2nd line lockout CA
variable "ssh_trusted_user_ca_map" {
  type    = map(string)
  default = {
    crtort     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCoONOiMHYIigC3KqjbZ5cli+EqUGppLIo8uqN3ozqinS1abGJNtlUqSKhlUGLX2ZL51vw0h8QV+Phqarv6lmdkkAj0C4GULnAoF9JGga2yOe3I/wZIaKBewPVEnuzCf9qyg5zW+9xodBPLCNyKJsgWxuWvi028SXm6BLzcZXP0saipdvYIAJUaGjjkF5L/O1ZeTMODdhouz+98/tFc/aPLSP1JoiNMgfu7eHpAS7V/n7e0i6EApMFatpWDVKAZ67iNqpc61wQBgmjnjiK6+MUe0SiHlhBLAXSJBQTr36mtLACAASjIi6/fa2NsPh6uIPcqXxi0EoSZJBMmGb3kFQ4ySdJuI1xyuHRNAi2NdhJH7HmYIPcjtwnoSOeJ/6D8UAHveSbktPk4tsBDnEG4lQj9ZNceki2p/42IwPqBSW730kynHNf++8WadYkV88HsdTY3XU4n0ZP4w3CbC/EiHgXuxzHJiiZhoodOiZG908u3i+lr1mW7+AJ2CsFK70eTtW764oSwRTNI+c0SN5vdETnIsd06mZhCF3TwbvtAS8+Ap9z2W2GoR+P6/VheSo9VnYiwPHn+YL0xKcviSxYSQ4lMtGp+IdL7p3Z+6rc+9dooBppJnEGfigCC6wraEtb0lZocgWKKe9phdyX5LlKE4EK1bBbDfd4AEHFFZ3jCYSe7DQ=="
    testing    = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCoONOiMHYIigC3KqjbZ5cli+EqUGppLIo8uqN3ozqinS1abGJNtlUqSKhlUGLX2ZL51vw0h8QV+Phqarv6lmdkkAj0C4GULnAoF9JGga2yOe3I/wZIaKBewPVEnuzCf9qyg5zW+9xodBPLCNyKJsgWxuWvi028SXm6BLzcZXP0saipdvYIAJUaGjjkF5L/O1ZeTMODdhouz+98/tFc/aPLSP1JoiNMgfu7eHpAS7V/n7e0i6EApMFatpWDVKAZ67iNqpc61wQBgmjnjiK6+MUe0SiHlhBLAXSJBQTr36mtLACAASjIi6/fa2NsPh6uIPcqXxi0EoSZJBMmGb3kFQ4ySdJuI1xyuHRNAi2NdhJH7HmYIPcjtwnoSOeJ/6D8UAHveSbktPk4tsBDnEG4lQj9ZNceki2p/42IwPqBSW730kynHNf++8WadYkV88HsdTY3XU4n0ZP4w3CbC/EiHgXuxzHJiiZhoodOiZG908u3i+lr1mW7+AJ2CsFK70eTtW764oSwRTNI+c0SN5vdETnIsd06mZhCF3TwbvtAS8+Ap9z2W2GoR+P6/VheSo9VnYiwPHn+YL0xKcviSxYSQ4lMtGp+IdL7p3Z+6rc+9dooBppJnEGfigCC6wraEtb0lZocgWKKe9phdyX5LlKE4EK1bBbDfd4AEHFFZ3jCYSe7DQ=="
    staging    = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDLfWw9g1hcT0q/DE7z5OYAp0VkayC3GvQbz08lAGY8cVlkus8z26xAhh4QftSt1JX8z3MQAltUjAWUv92b2zzS0DFQcxaCDnBRRzFZinNG2hIGrs6WGkM9mMVOZba3nZejVcAiyVGoGAXMSRyEgnJU3umzTNNbP8ghWlSj6bNfGfR64JS17//1tJZwWlrNVPEPlDI0C0tZ8fipwXUDPGSlqXG71ErONfTuQpGeJnFtiDRmi2S/GnMmfBelvnB857lx6By3zlarq6q+Idtqw2wZjcS62TlCvtURVFTcbrYdEPMxTa/RnQ1464tG8db3vq2mjushNCGS/WMVIqFa+Z9ACp59GURJH/Q/OJPt4r65tRely7iW7q+5V8wgVeqxnVmR8B8/1E7yEpaNUJHldpQGsDLQ+qcXLaDkredAPp9NdG9SKvCOEyPuCYvz20N8UVQxglaSa68E+MT9VtNxHVI4JoWoduUwvxAjVdacNgPC4+v7msSoEoVN3sYTNWzKRM3V0/uNHtsEC3swbOdia7NkVLW7iIu9fhjjFZE7BvzcAjK5ggTgcUjuVWvirE/iWj94rPb2o/8PCiRahTOMruUA/cxusNnREfcfpp+uCAzQra1FlXqwYQYd8uxw/FdnJ+tdKlwURXrwXptqI7tj+Sk8EbUBVypPN2ailFF5zXC0Ow=="
    production = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+U/vRn2hoLjJABM/K5xCI6VYDNEzmR4jU3KMsDtIT79/ut+tUtmEGCrBcstoQb2FuixNm8aT6SO4MmgO0Ww/KLRiKDBKrMqStmJgkEzvsK+LvhLlF8Y7WEHyTQOoklXMzSOYXnk6+/qkbcPe6mMvWserJt06VmPhfuqvYJ4SICRyA5+Qyr+7PxBBahn0+vbg4b0eyfFjvPppLl7HxLlNdDleHFIe2iSnSwLuFoXSiCmDIL3DBG31gu0aBw7ED68ov/vlVAmZvqkRjz3IBRN3BUEvF/Q6Ad4H+EbW3TwHz/xQqZR+ZKU9QWP4sTc+aq1qwmMauVzrUnbPp6xZTrzh+b0dZyjg2zinGd5r5sZmDiQPXf1tRUEMK6v8rkRaj+Eod95lqyQVb6qzikfKZjs4PvmGunYMZqi0xlnuq3+cRiGOn1nwpklPW/wyVMBwsxA4Wrl+7QKxGLL0pPnU1KvP7XIBMzfux038MNMiTp68y9rBaGSwO2pIn216iRUmq4qs1737SOnaDTyLwofDojDW0WHlb4kFXBKTX9Djtk9i92BHoyd+KODHWBvJ43Gyalhm2hyS7eGeYtLE/qqRJzZ2FjMipcopSVgjgG8qhsb9JsZ4mGh9uSN69j1d213nIixaTK5eSjp31v8tMICEzaFTDdv39jEYB9gfWozCvTiVxlQ=="
  }
}

variable "ssh_trusted_user_lockout_ca" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4goUhYoWl/2xMXL4qs4G5KOW0I+09ton+/B1pZpsA3lBJ5g031maZ3mmtV/k9vY3PDoI6CVmkOIdNRe5NYKPI+WilsxXO3juR4rVVZVBA37ys+cZljU7KQGHDytbVsAP/Ifcqo3Ld2ZsXed70lC0+aKvlVI271xSNEkdTjl1OePrkYxkbPfBvFtn1TyY/P0dqRwbG7vKfGPce6fkqZi3uPpkZAxUE8ITuX6cYPkEyniQBPBy5klN23HTTN1q8UQpLgYO+lnSkTCFlw/Tbeur3qF57d8JRiaCGXkVGQuijyd3WoOdjndvozVkJ2RHcNbsU973LGI+gHUCGe/+uDDzOVqt3ThK0EqhxCAvQAhIixSs/nv7BIXWdPuL2tnl13ir4HVCSBLFlGL21D5w851XfsxTGynIwW1lonhKg3af+6pARSwdii+IH4p4V7Xu0DucfzuPApfUURuI5h7VI3ZSNT8kwOr8x5qfo0aJaXmi9h3cYub1OKC0qNxOjwYKKmLu4//5Vz+QoydQrzCLi20SyQEVumXwVjRAyhaDG9Xxy0LXanKeP5yjHAUgQ/9v4UZZd4QhmJ/qh8rdrTw2XHBRpjX/Mpys6nWrFxJT+cvsE/f4be4ZhCQASJjIjHGCJuLDK1aU3+mwiuxRt+9ERAeO9MYBc+rq5AsIHZwl7XPGG7Q=="
}