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
        ClusterName: ${cluster-name}
        ClusterType: ce
        Config: /etc/vpm/config.yaml
        Hostname: ${host-name}
        Latitude: ${latitude}
        Longitude: ${longitude}
        MauriceEndpoint: "https://register.${xc-environment-api-endpoint}"
        MauricePrivateEndpoint: "https://register-tls.${xc-environment-api-endpoint}"
        Proxy: {}
        Token: ${site-registration-token}

  - path: /etc/vpm/certified-hardware.yaml
    permissions: 0644
    owner: root
    content: |
      active: ${certified-hw}
      certifiedHardware:
        ${certified-hw}:
          Vpm:
            PrivateNIC: eth0
          outsideNic:
          - eth0
      primaryOutsideNic: eth0

runcmd:
  - [ sh, -c, test -e /usr/bin/fsextend  && /usr/bin/fsextend || true ]

hostname: ${host-name}
