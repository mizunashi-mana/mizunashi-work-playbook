import "mizunashi.work/pkg/cue_vars/vagrant"
import "mizunashi.work/pkg/private_ca_vagrant"

import "mizunashi.work/pkg/roles/mastodon"
import "mizunashi.work/pkg/roles/redis_exporter"
import "mizunashi.work/pkg/roles/postgres_exporter"
import "mizunashi.work/pkg/roles/statsd_exporter"
import "mizunashi.work/pkg/roles/openssl_ocsp_responder"
import "mizunashi.work/pkg/roles/nginx_site_http_redirector"
import "mizunashi.work/pkg/roles/nginx_site_mastodon_front"
import "mizunashi.work/pkg/roles/nginx_site_private_ca"
import "mizunashi.work/pkg/roles/postgresql_mastodon"
import "mizunashi.work/pkg/roles/private_mastodon_certificate"

#Schema: vagrant
#Schema: mastodon
#Schema: openssl_ocsp_responder
#Schema: redis_exporter
#Schema: postgres_exporter
#Schema: statsd_exporter
#Schema: nginx_site_http_redirector
#Schema: nginx_site_mastodon_front
#Schema: nginx_site_private_ca
#Schema: postgresql_mastodon
#Schema: private_mastodon_certificate
#Schema: enable_private_mastodon_certificate: bool

let ssh_port = vagrant.#ssh_port
let http_port = 80
let https_port = 443

let ocsp_responder_port_for_root = 4211
let ocsp_responder_port_for_inter_tls = 4212

#Schema & {
  mastodon_local_domain: "mstdn-local.mizunashi.work"
  nginx_site_private_ca_domain: "ca-local.mizunashi.work"

  nginx_site_http_redirector_listen_port: http_port
  nginx_site_private_ca_listen_port: http_port
  nginx_site_mastodon_front_listen_port: https_port

  nftables_accept_tcp_ports: [
    ssh_port,
    http_port,
    https_port,
  ]

  nginx_site_local_proxy_entries: "redis": {
    upstream_port: #Schema.redis_exporter_listen_port
  }
  nginx_site_local_proxy_entries: "postgresql": {
    upstream_port: #Schema.postgres_exporter_listen_port
  }
  nginx_site_local_proxy_entries: "statsd": {
    upstream_port: #Schema.statsd_exporter_web_listen_port
  }

  openssl_ocsp_responder_entries: {
    "rootCA": {
      listen_port: ocsp_responder_port_for_root
      ca_cert: private_ca_vagrant.root_ca_certificate
      ca_privkey: private_ca_vagrant.root_ca_privkey
      ca_database_content: private_ca_vagrant.root_ca_database
    }
    "interCA_TLS": {
      listen_port: ocsp_responder_port_for_inter_tls
      ca_cert: private_ca_vagrant.inter_tls_ca_certificate
      ca_privkey: private_ca_vagrant.inter_tls_ca_privkey
      ca_database_content: private_ca_vagrant.inter_tls_ca_database
    }
  }

  mastodon_single_user_mode: "true"

  enable_private_mastodon_certificate: true

  mastodon_db_user_password: {
    "__ansible_vault":
      """
      $ANSIBLE_VAULT;1.1;AES256
      65333663363039383963396135643335373032636437653730356635613734303434336534323136
      3135363037306231643964396337663435643266633566340a616137393839323333353332626462
      61383633343664306232393766613635303962303237626231333734313236646562626261386130
      3263663039376435390a383532326435363036646533393639356536626539333530343835653961
      30333436616561303861653761613238316162316430626664326662646135643737
      """
  }

  mastodon_secret_key_base: {
    "__ansible_vault":
      """
      $ANSIBLE_VAULT;1.1;AES256
      37323735323835666638353864626536386338613863303661353730646536393933363461383966
      6336356634633339333663626633333332613531303335360a396261366231393265646533323662
      30356632643331356139306366663836346663666465353766613435373330396464366530363933
      6537373534666665340a663637613064373063363437653433663365393161643538306537316664
      62386238663461633337623834633333393533636539373862303430396434616232353261303535
      66343935303935333730376362313135353265326565303864393664326235353535373235316365
      35363361623862323937633534383634343131303365623737343435363337656161363634386138
      38306135346363316432663163353565353930366462373131646264373930303964636165653530
      36303465343339366666613431323330396666373533666331646334613231346264356164636265
      37656131303933383936636166323733346130356635343839663336376136303336353662633637
      313237396237633536333036346435313630
      """
  }
  mastodon_otp_secret: {
    "__ansible_vault":
      """
      $ANSIBLE_VAULT;1.1;AES256
      35653533633464366161633961323035323261643130386638626237346261643763346464613933
      3832646163646264303434626237386533666638383336660a353939396531646333643065393263
      61626465323632633233346132646265346635616561636536376430323932373661343132623261
      3565613431656666620a363431626161303466383235366432393734323961666331306532616366
      35613137323564303033636530616239336133373361616165316131663934646661336666343031
      64653463373336386639333331396431316135313139636630386435316265366139363361656537
      39636161336439383239313532333363373565396364663461636532303035336461643635633165
      33333133653561363334356530333335663932623061366366616262306263626539636132393133
      38376363333334663861623962643166326538616534616338643833613365336639396130616465
      62393836353437303237393465633633663934613130316532386532333064386538366439656134
      386263386436623762363665373966386436
      """
  }

  mastodon_vapid_private_key: {
    "__ansible_vault":
      """
      $ANSIBLE_VAULT;1.1;AES256
      34633130343535333432333436613738373337356433336238616161313239376530383663366130
      3732656338646634656263636632616461663136336234390a356665633565653131343937326330
      61646133633061323164376165666231393234373266643836656561663838393735393738303037
      6665306434633234340a306362396535306464386232333332633739366139383430366266343930
      65333436343931616230393361653234376438313764333937616330353464373132373861356465
      3565323135626462313931613335633363643938396262373962
      """
  }
  mastodon_vapid_public_key: "BMRVNeG8Io07OP2yGLhhhIXiX-m7Tjjhws_RJ9b1BvBXTKj8wRn9XAyRBoeM04TUgj26qkdnrtBbcRh_XODZW3k="

  private_mastodon_certificate_fullchain:
    """
    -----BEGIN CERTIFICATE-----
    MIIEBjCCA4ygAwIBAgIBATAKBggqhkjOPQQDBDB+MQswCQYDVQQGEwJKUDEOMAwG
    A1UECAwFVG9reW8xCjAIBgNVBAcMAS4xEDAOBgNVBAoMB1ByaXZhdGUxIDAeBgNV
    BAsMF21penVuYXNoaS13b3JrLXBsYXlib29rMR8wHQYDVQQDDBZWYWdyYW50IFBy
    aXZhdGUgVExTIENBMB4XDTIzMDQwMjA2MjkxMloXDTI0MDQwMTA2MjkxMlowgYIx
    CzAJBgNVBAYTAkpQMQ4wDAYDVQQIDAVUb2t5bzEKMAgGA1UEBwwBLjEQMA4GA1UE
    CgwHUHJpdmF0ZTEgMB4GA1UECwwXbWl6dW5hc2hpLXdvcmstcGxheWJvb2sxIzAh
    BgNVBAMMGm1zdGRuLWxvY2FsLm1penVuYXNoaS53b3JrMHYwEAYHKoZIzj0CAQYF
    K4EEACIDYgAEJ6zwfix0S3F9L7czVdM0r2HFmgRT4r3uMuxlz+s/TslgUDdl+v2K
    G5MlpPhdkz1inW7iqtuYiMovF+jXHHQ5T+oDX85DQx6MtGDzVzS4Nt5JqZnLGjBL
    Q4pkzANgW6m5o4IB1zCCAdMwHQYDVR0OBBYEFJcd/az1kPmUXWBNYYXhOxpIGBLV
    MIGrBgNVHSMEgaMwgaCAFI9q+zWazUgtDnDwkqSef4dIqR+UoYGEpIGBMH8xCzAJ
    BgNVBAYTAkpQMQ4wDAYDVQQIDAVUb2t5bzEKMAgGA1UEBwwBLjEQMA4GA1UECgwH
    UHJpdmF0ZTEgMB4GA1UECwwXbWl6dW5hc2hpLXdvcmstcGxheWJvb2sxIDAeBgNV
    BAMMF1ZhZ3JhbnQgUHJpdmF0ZSBSb290IENBggEBMAkGA1UdEwQCMAAwDgYDVR0P
    AQH/BAQDAgeAMB0GA1UdJQQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjCBiAYIKwYB
    BQUHAQEEfDB6MDwGCCsGAQUFBzABhjBodHRwOi8vY2EtbG9jYWwubWl6dW5hc2hp
    LndvcmsvaW50ZXJDQV9UTFMub2NzcC8wOgYIKwYBBQUHMAKGLmh0dHA6Ly9jYS1s
    b2NhbC5taXp1bmFzaGkud29yay9pbnRlckNBX1RMUy5jcnQwPwYDVR0fBDgwNjA0
    oDKgMIYuaHR0cDovL2NhLWxvY2FsLm1penVuYXNoaS53b3JrL2ludGVyQ0FfVExT
    LmNybDAKBggqhkjOPQQDBANoADBlAjEA2KJbJE71dswIytiiNh+HzgzCmvaOQQ5/
    eTE5hF0EgeK5iUSwV+ufYyALFAREsmehAjBWQUjgwmQChzkbEK0ziQ1RB5wEpKWy
    pBP4iDtkUrWkGok3A/a1/LSBnr6xJWV90XY=
    -----END CERTIFICATE-----
    \(private_ca_vagrant.inter_tls_ca_certificate)
    """
  private_mastodon_certificate_chain: private_ca_vagrant.inter_tls_ca_certificate
  private_mastodon_certificate_privkey:
    "__ansible_vault":
      """
      $ANSIBLE_VAULT;1.1;AES256
      38343436663032646662626362386533316634366234613361336538323338363338663031373332
      3662633062613034373130343133623065396131616464390a626666633964303233333135613337
      39623364623233393464386665396532653736643238316362336666383665613435366465623030
      3431326634343739610a383434653263373162343238383635616637643665313432353238303364
      39333462356132303162666661656237636439623464326138336438326239326330613537623334
      64373037653332363261666336333833303466343238613763333932373161303564353437613862
      37613765653939376330313930656537326636646661383436633334393363633863393137323234
      33666335616537623438333765666236656131326234316634633937616365363030383133343165
      31323834306632656331336262663935363137343031346263336237386165653835653566383866
      32376463656635306364653765353635343062363134383537333038623564333662323837356561
      39303763636664346661666262613739623935346537333666633539663265636431386136613133
      65306164376635653762323834313332623238363932653237613763326134373230303133623865
      38663634643462623831333362363566366236616466633139623766333934366466643966383061
      34373430626638613733393535353563313531656166363662646361626334326632373635633038
      33393666313333396133323839316535366133396538383864383264653233316134303261613932
      32383432666261306136363866366431653131316138613035386233653331393665316461666138
      61363261666239383564663534356562656163303135373364393763356536663362396532636534
      30333630383537666433376634633064313535356562653232383464333234633964616438306133
      36653965396639386665613131313034343666653239616230326334633736616461396562626437
      39306236373939383632
      """

  nginx_site_private_ca_root_certificate: private_ca_vagrant.root_ca_certificate
  nginx_site_private_ca_root_crl: private_ca_vagrant.root_ca_crl

  nginx_site_private_ca_inter_tls_certificate: private_ca_vagrant.inter_tls_ca_certificate
  nginx_site_private_ca_inter_tls_crl: private_ca_vagrant.inter_tls_ca_crl
}
