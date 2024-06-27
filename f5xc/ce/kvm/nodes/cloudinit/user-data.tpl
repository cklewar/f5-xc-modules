#cloud-config
users:
  - name: "vesop"
    passwd: ""
    groups:
      - "sudo"

coreos:
  update:
    reboot-strategy: "off"

write_files:
  - path: /etc/vpm/config.yaml
    permissions: 0644
    owner: root
    content: |
      Kubernetes:
        EtcdUseTLS: true
        Server: vip
      Vpm:
        ClusterName: ${cluster_name}
        ClusterType: ce
        Config: /etc/vpm/config.yaml
        Hostname: ${host_name}
        Latitude: ${latitude}
        Longitude: ${longitude}
        MauriceEndpoint: "${maurice_endpoint}"
        MauricePrivateEndpoint: "${maurice_mtls_endpoint}"
        Proxy: {}
        Token: ${site_registration_token}

  - path: /etc/vpm/certified-hardware.yaml
    permissions: 0644
    owner: root
    content: |
      active: ${certified_hw}
      certifiedHardware:
        ${certified_hw}:
          Vpm:
            PrivateNIC: eth0
          outsideNic:
          - eth0
      primaryOutsideNic: eth0

runcmd:
  - [ sh, -c, test -e /usr/bin/fsextend  && /usr/bin/fsextend || true ]

hostname: ${host_name}
