import "mizunashi.work/pkg/cue_vars/vagrant"
import "mizunashi.work/pkg/private_ca_vagrant"

import "mizunashi.work/pkg/roles/dnsmasq"
import "mizunashi.work/pkg/roles/prometheus"
import "mizunashi.work/pkg/roles/grafana"

#Schema: vagrant
#Schema: dnsmasq
#Schema: prometheus
#Schema: grafana

let ssh_port = vagrant.#ssh_port

#Schema & {
  nftables_accept_tcp_ports: [
    ssh_port,
  ]

  dnsmasq_hosts_entries: [
    for _, entry in vagrant.#host_entries {
      {
        ip: entry.internal_ip
        domain: entry.internal_host
      }
    }
  ]

  nginx_site_local_proxy_entries: "prometheus": {
    upstream_port: #Schema.prometheus_listen_port
  }
  nginx_site_local_proxy_entries: "grafana": {
    upstream_port: #Schema.grafana_listen_port
  }

  prometheus_scrape_configs: [
    {
      job_name: "prometheus"
      params: "local_proxy_upstream": ["prometheus"]
      enable_tls_client_verification: true
      use_private_ca: true
      static_configs: [{
        targets: [
          for _, entry in vagrant.#internal_host_entries {
            "\(entry.internal_host):\(#Schema.#local_proxy_https_port)"
          }
        ]
      }]
    },
    {
      job_name: "grafana"
      params: "local_proxy_upstream": ["grafana"]
      enable_tls_client_verification: true
      use_private_ca: true
      static_configs: [{
        targets: [
          for _, entry in vagrant.#internal_host_entries {
            "\(entry.internal_host):\(#Schema.#local_proxy_https_port)"
          }
        ]
      }]
    },
    {
      job_name: "node"
      params: "local_proxy_upstream": ["node"]
      enable_tls_client_verification: true
      use_private_ca: true
      static_configs: [{
        targets: [
          for _, entry in vagrant.#host_entries {
            "\(entry.internal_host):\(#Schema.#local_proxy_https_port)"
          }
        ]
      }]
    },
    {
      job_name: "nginx"
      params: "local_proxy_upstream": ["nginx"]
      enable_tls_client_verification: true
      use_private_ca: true
      static_configs: [{
        targets: [
          for _, entry in vagrant.#host_entries {
            "\(entry.internal_host):\(#Schema.#local_proxy_https_port)"
          }
        ]
      }]
    },
    {
      job_name: "redis"
      params: "local_proxy_upstream": ["redis"]
      enable_tls_client_verification: true
      use_private_ca: true
      static_configs: [{
        targets: [
          for _, entry in vagrant.#public_host_entries {
            "\(entry.internal_host):\(#Schema.#local_proxy_https_port)"
          }
        ]
      }]
    },
    {
      job_name: "postgres"
      params: "local_proxy_upstream": ["postgres"]
      enable_tls_client_verification: true
      use_private_ca: true
      static_configs: [{
        targets: [
          for _, entry in vagrant.#public_host_entries {
            "\(entry.internal_host):\(#Schema.#local_proxy_https_port)"
          }
        ]
      }]
    },
    {
      job_name: "statsd"
      params: "local_proxy_upstream": ["statsd"]
      enable_tls_client_verification: true
      use_private_ca: true
      static_configs: [{
        targets: [
          for _, entry in vagrant.#public_host_entries {
            "\(entry.internal_host):\(#Schema.#local_proxy_https_port)"
          }
        ]
      }]
    },
  ]

  prometheus_client_certificate_cert:
    """
    -----BEGIN CERTIFICATE-----
    MIIEADCCA4egAwIBAgIBAzAKBggqhkjOPQQDBDB+MQswCQYDVQQGEwJKUDEOMAwG
    A1UECAwFVG9reW8xCjAIBgNVBAcMAS4xEDAOBgNVBAoMB1ByaXZhdGUxIDAeBgNV
    BAsMF21penVuYXNoaS13b3JrLXBsYXlib29rMR8wHQYDVQQDDBZWYWdyYW50IFBy
    aXZhdGUgVExTIENBMB4XDTIzMDQwMzE0MjE0N1oXDTI0MDQwMjE0MjE0N1owfjEL
    MAkGA1UEBhMCSlAxDjAMBgNVBAgMBVRva3lvMQowCAYDVQQHDAEuMRAwDgYDVQQK
    DAdQcml2YXRlMSAwHgYDVQQLDBdtaXp1bmFzaGktd29yay1wbGF5Ym9vazEfMB0G
    A1UEAwwWUHJvbWV0aGV1cyBDbGllbnQgQXV0aDB2MBAGByqGSM49AgEGBSuBBAAi
    A2IABI7BeS0ZXS93EAOjd7C3/aNyKlJfiRMd8znsf8RtwB3HpuDaPoXxJuZ3dPDv
    KyjMgAAt0vj2jxhL44BeLx1FmXsFPWkBzZj9Hh+lyVay4xDNG/8YeEy1NgzSuW4x
    QorVeaOCAdcwggHTMB0GA1UdDgQWBBQL2SyOY0874rdjYyzph8sMCvj9UTCBqwYD
    VR0jBIGjMIGggBSPavs1ms1ILQ5w8JKknn+HSKkflKGBhKSBgTB/MQswCQYDVQQG
    EwJKUDEOMAwGA1UECAwFVG9reW8xCjAIBgNVBAcMAS4xEDAOBgNVBAoMB1ByaXZh
    dGUxIDAeBgNVBAsMF21penVuYXNoaS13b3JrLXBsYXlib29rMSAwHgYDVQQDDBdW
    YWdyYW50IFByaXZhdGUgUm9vdCBDQYIBATAJBgNVHRMEAjAAMA4GA1UdDwEB/wQE
    AwIHgDAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwgYgGCCsGAQUFBwEB
    BHwwejA8BggrBgEFBQcwAYYwaHR0cDovL2NhLWxvY2FsLm1penVuYXNoaS53b3Jr
    L2ludGVyQ0FfVExTLm9jc3AvMDoGCCsGAQUFBzAChi5odHRwOi8vY2EtbG9jYWwu
    bWl6dW5hc2hpLndvcmsvaW50ZXJDQV9UTFMuY3J0MD8GA1UdHwQ4MDYwNKAyoDCG
    Lmh0dHA6Ly9jYS1sb2NhbC5taXp1bmFzaGkud29yay9pbnRlckNBX1RMUy5jcmww
    CgYIKoZIzj0EAwQDZwAwZAIwXrNVScZT+dXO2N3aFNT/ukGX62d/WdjWA4zZ36C4
    PtZ5JTCO3L/9Pu5Ewz0V4SFhAjB3VqtmNqr1um0il1VuP/LnbWjRmqVnss1mGMh3
    gS5J9mXyqRW4oAVjNmW6MEgYdzk=
    -----END CERTIFICATE-----
    \(private_ca_vagrant.inter_tls_ca_certificate)
    """
  prometheus_client_certificate_privkey:
    "__ansible_vault":
      """
      $ANSIBLE_VAULT;1.1;AES256
      61316230343135626430373335633335623666316366363833643732306638336530663435643933
      3434303861666463616538646333316364623466623539620a343431353534363135323337333734
      30393933373531303137313562363033303561333835373533353862396565323339633337623262
      3166633337393938310a323161343966383533333633393562363665353562373538656664323138
      64653561363030383430613665333331376362393734323239393938616433343339613766633132
      32616562653666343932626363636131656666306662653366363134316363353137343631363931
      61623338663737306461653532386462333835633539646333393136646461376332663532653730
      62353033376433633063616136393035393036616338343566663237376537353763666131333333
      62303663376165343330616630336366643336366435643732313766393230663432353165343239
      35633335306234613937306533333239643138306538663862376162343331376230336335653337
      34363736613438666433313132313033653035336264616165373235653961643234353661396239
      37323935643366373363316165376236336637343163373334666561383664666635646265643263
      39306265633635653931633964323831626365303561306236633535373839343837633132366366
      37663134613962356564613839643632306339653661316539666132393935663665323037643037
      34343561393938656139663934303065353735653363633638353939396166346333363963633664
      36626132373961616561626636316265643766343564303764326331346130616135353962333434
      61663132663531643434393166346261643136326430373733623463363130303462336432626566
      31663039376139346532643164326633333636323036343630346134643966613632616466383537
      63636563303433333439376632656631393131633232643431643737393331626561353734616531
      36303339303737306237
      """
}
