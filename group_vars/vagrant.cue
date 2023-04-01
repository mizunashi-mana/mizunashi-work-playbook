import "mizunashi.work/pkg/roles/base"
import "mizunashi.work/pkg/roles/openssh_server"
import "mizunashi.work/pkg/roles/nftables"
import "mizunashi.work/pkg/roles/fail2ban"
import "mizunashi.work/pkg/roles/nginx"
import "mizunashi.work/pkg/roles/mastodon"
import "mizunashi.work/pkg/roles/nginx_exporter"
import "mizunashi.work/pkg/roles/prometheus"
import "mizunashi.work/pkg/roles/exim"
import "mizunashi.work/pkg/roles/nginx_site_http_redirector"
import "mizunashi.work/pkg/roles/nginx_site_mastodon_front"
import "mizunashi.work/pkg/roles/nginx_site_local_proxy"
import "mizunashi.work/pkg/roles/nginx_site_private_ca"
import "mizunashi.work/pkg/roles/postgresql_mastodon"
import "mizunashi.work/pkg/roles/private_mastodon_certificate"

#Schema: base
#Schema: fail2ban
#Schema: nftables
#Schema: openssh_server
#Schema: nginx
#Schema: mastodon
#Schema: exim
#Schema: nginx_exporter
#Schema: prometheus
#Schema: nginx_site_http_redirector
#Schema: nginx_site_mastodon_front
#Schema: nginx_site_local_proxy
#Schema: nginx_site_private_ca
#Schema: postgresql_mastodon
#Schema: private_mastodon_certificate

let ssh_port = 22
let http_port = 80
let https_port = 443
let local_proxy_https_port = 19100

let private_ca_inter_tls_certificate =
  """
  -----BEGIN CERTIFICATE-----
  MIIDVjCCAtugAwIBAgIBATAKBggqhkjOPQQDBDBhMQswCQYDVQQGEwJKUDEOMAwG
  A1UECAwFVG9reW8xCjAIBgNVBAcMAS4xEDAOBgNVBAoMB1ByaXZhdGUxCjAIBgNV
  BAsMAS4xGDAWBgNVBAMMD1ByaXZhdGUgUm9vdCBDQTAeFw0yMzA0MDEwNjE2MDBa
  Fw0yODAzMzAwNjE2MDBaMGAxCzAJBgNVBAYTAkpQMQ4wDAYDVQQIDAVUb2t5bzEK
  MAgGA1UEBwwBLjEQMA4GA1UECgwHUHJpdmF0ZTEKMAgGA1UECwwBLjEXMBUGA1UE
  AwwOUHJpdmF0ZSBUTFMgQ0EwdjAQBgcqhkjOPQIBBgUrgQQAIgNiAAQty7P5w0MH
  ZftFTdWLCg/G+qhCgemaXR+Gbh6Ulv5CveeOaK39juLljnweMJqpBlSlW3jAwh2Z
  wtFkQKAy3E+1uju+oIqMwES7Wory26lgshurXzZTCIMN+mBXAaPrInqjggFmMIIB
  YjAdBgNVHQ4EFgQUAWdVO/PFWEErsdhsR8jMwbwmo2cwewYDVR0jBHQwcqFlpGMw
  YTELMAkGA1UEBhMCSlAxDjAMBgNVBAgMBVRva3lvMQowCAYDVQQHDAEuMRAwDgYD
  VQQKDAdQcml2YXRlMQowCAYDVQQLDAEuMRgwFgYDVQQDDA9Qcml2YXRlIFJvb3Qg
  Q0GCCQDxU0uZPzcEODBFBggrBgEFBQcBAQQ5MDcwNQYIKwYBBQUHMAKGKWh0dHA6
  Ly9jYS1sb2NhbC5taXp1bmFzaGkud29yay9yb290Q0EuY3J0MDoGA1UdHwQzMDEw
  L6AtoCuGKWh0dHA6Ly9jYS1sb2NhbC5taXp1bmFzaGkud29yay9yb290Q0EuY3Js
  MBIGA1UdEwEB/wQIMAYBAf8CAQAwDgYDVR0PAQH/BAQDAgGGMB0GA1UdJQQWMBQG
  CCsGAQUFBwMBBggrBgEFBQcDAjAKBggqhkjOPQQDBANpADBmAjEA0ML5FB2obPMq
  kqyBSb8aCC4+p/jCecuMPqucQ8Ot7dmbsS7cTCatcL7GT97AYagyAjEAq/XiU3sv
  7E9F9BTu3D2iw4JaNSD+G8XhUlfV3vevcvioPTmFo01apDWupPi+zUUk
  -----END CERTIFICATE-----
  """

#Schema & {
  base_workuser_name: "vagrant"

  mastodon_local_domain: "mstdn-local.mizunashi.work"
  mastodon_single_user_mode: "true"

  openssh_server_listen_port: ssh_port
  nginx_site_http_redirector_listen_port: http_port
  nginx_site_mastodon_front_listen_port: https_port
  nginx_site_local_proxy_listen_port: local_proxy_https_port

  nftables_accept_tcp_ports: [
    ssh_port,
    http_port,
    https_port,
  ]

  nginx_resolver: "8.8.8.8"

  exim_mail_domain: "mail-local.mizunashi.work"

  nginx_site_private_ca_domain: "ca-local.mizunashi.work"
  nginx_site_private_ca_listen_port: http_port

  nginx_site_local_proxy_common_domain: "mizunashi.private"
  nginx_site_local_proxy_entries: {
    "node":
      upstream_port: 9100
  }

  prometheus_scrape_configs: [
    {
      job_name: "node"
      static_configs: [
        {
          targets: [
            "localhost:9100"
          ]
          labels: {
            "service": "vagrant"
            "project": "primary"
            "hostname": "localhost"
          }
        }
      ]
    },
    {
      job_name: "nginx"
      static_configs: [
        {
          targets: [
            "localhost:9113"
          ]
          labels: {
            "service": "vagrant"
            "project": "primary"
            "hostname": "localhost"
          }
        }
      ]
    },
    {
      job_name: "redis"
      static_configs: [
        {
          targets: [
            "localhost:9121"
          ]
          labels: {
            "service": "vagrant"
            "project": "primary"
            "hostname": "localhost"
          }
        }
      ]
    },
  ]

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
    MIIDcjCCAvigAwIBAgIBATAKBggqhkjOPQQDBDBgMQswCQYDVQQGEwJKUDEOMAwG
    A1UECAwFVG9reW8xCjAIBgNVBAcMAS4xEDAOBgNVBAoMB1ByaXZhdGUxCjAIBgNV
    BAsMAS4xFzAVBgNVBAMMDlByaXZhdGUgVExTIENBMB4XDTIzMDQwMTA2MTc1M1oX
    DTI0MDMzMTA2MTc1M1owbDELMAkGA1UEBhMCSlAxDjAMBgNVBAgMBVRva3lvMQow
    CAYDVQQHDAEuMRAwDgYDVQQKDAdQcml2YXRlMQowCAYDVQQLDAEuMSMwIQYDVQQD
    DBptc3Rkbi1sb2NhbC5taXp1bmFzaGkud29yazB2MBAGByqGSM49AgEGBSuBBAAi
    A2IABDfaPUa4TIPoqnz0m1HEdj8ir54KgSa4liWaBDaMkD89x7gVjPk1sHXpf48K
    ZjAQdAFXHi1KNVUiltMlYbuS9BpKXXvXIiQ4HWiCsmxyPWsRW0h5/jsCzuXHkF4s
    c5l+YqOCAXgwggF0MB0GA1UdDgQWBBRo+pSNaY0hC3j9Do5ucm9XhMBEejCBiwYD
    VR0jBIGDMIGAgBQBZ1U788VYQSux2GxHyMzBvCajZ6FlpGMwYTELMAkGA1UEBhMC
    SlAxDjAMBgNVBAgMBVRva3lvMQowCAYDVQQHDAEuMRAwDgYDVQQKDAdQcml2YXRl
    MQowCAYDVQQLDAEuMRgwFgYDVQQDDA9Qcml2YXRlIFJvb3QgQ0GCAQEwCQYDVR0T
    BAIwADAOBgNVHQ8BAf8EBAMCB4AwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUF
    BwMCMEoGCCsGAQUFBwEBBD4wPDA6BggrBgEFBQcwAoYuaHR0cDovL2NhLWxvY2Fs
    Lm1penVuYXNoaS53b3JrL2ludGVyQ0FfVExTLmNydDA/BgNVHR8EODA2MDSgMqAw
    hi5odHRwOi8vY2EtbG9jYWwubWl6dW5hc2hpLndvcmsvaW50ZXJDQV9UTFMuY3Js
    MAoGCCqGSM49BAMEA2gAMGUCMG1JSG2XLACHLSsOOhP2lUHbcql+KNYwpOAUC39u
    J6eUdRQMDUqXN1KXjtvmViCVlAIxAKmg7PefaQhtLa6SeENvivOlbiQdY/HO40Wn
    y+6CToRheHt66Lq+x8UL3Q5ru4nFpw==
    -----END CERTIFICATE-----
    \(private_ca_inter_tls_certificate)
    """
  private_mastodon_certificate_chain: private_ca_inter_tls_certificate
  private_mastodon_certificate_privkey:
    "__ansible_vault":
      """
      $ANSIBLE_VAULT;1.1;AES256
      39613063656536626331353062373133383965633739363937306533313737393532623639393666
      3038366165643138386535633765393938613863353332610a376464633331646135623938383063
      35613531353030393030613535333437633265303235636665393032323631633461396334633561
      6265636462646536620a383963663863396465636265363236383536656661646662353935666366
      65666438613064336335386135623366613336393163636234346336373835353438356231303836
      64363165616230633766386532663562326132303539636162366664653065356538623265393264
      33306538623134316632333637376161643434393861313162616637656633396332353664366536
      35356563653661646361656162646335633639353035646532363232663532323237633236346539
      32326165336638663031633535336638356636663566613933616139363032376533653435383461
      32313430646564623537333464336135646462623431383265313161316161393161613463623235
      34373538393838646562303730616466613437303933323431373036366437316631393562343138
      35626563386632336337613834623866653339643739333337333332343236623231643532313265
      30386435376634656134383431623431356562383864393033353463323762646166623365363930
      30396138306362313839333930326566373062383737386136663035616661623536623566653937
      30613232366264663263613661386435373334613739343038643637303236333238386330396639
      62383964356263626138353436393339396333373430383765356465653365363434383162653130
      61636265316463323963346462373036353238343034323637373764313934666261316538343761
      62323132633039366566316364373130643764383063393339376433333838663230383362646664
      32356265363062653530373066653135316366653966636235343737393362356261306234356530
      65393234643338313066
      """

  nginx_site_private_ca_root_certificate:
    """
    -----BEGIN CERTIFICATE-----
    MIIB7jCCAXUCCQDxU0uZPzcEODAKBggqhkjOPQQDBDBhMQswCQYDVQQGEwJKUDEO
    MAwGA1UECAwFVG9reW8xCjAIBgNVBAcMAS4xEDAOBgNVBAoMB1ByaXZhdGUxCjAI
    BgNVBAsMAS4xGDAWBgNVBAMMD1ByaXZhdGUgUm9vdCBDQTAeFw0yMzA0MDEwNjE1
    NDhaFw0zMzAzMjkwNjE1NDhaMGExCzAJBgNVBAYTAkpQMQ4wDAYDVQQIDAVUb2t5
    bzEKMAgGA1UEBwwBLjEQMA4GA1UECgwHUHJpdmF0ZTEKMAgGA1UECwwBLjEYMBYG
    A1UEAwwPUHJpdmF0ZSBSb290IENBMHYwEAYHKoZIzj0CAQYFK4EEACIDYgAEuCnm
    v/MFTtBHM18G1W32kY1qGwy8y1Zeas49tqWh3qPQZdSLHW6iLom+9vIoutVzaJRy
    /YT2A+0Weh3un8cTFKO2TyYLByAmtJr2iVPn+9CiFdi4idnVf2+obDlwa7iwMAoG
    CCqGSM49BAMEA2cAMGQCMEMm2FN3mPUiInrOXAJTVEzgcojmQrhBJIOXwsThyVmh
    ehCnvR0ilAGdBKiNRcNfAAIwII5/q172256j/YrVNmaT/fdCYnn6qM0bQECJ/LWT
    BdYh85/JZW1MunRyYzHZpcNA
    -----END CERTIFICATE-----
    """
  nginx_site_private_ca_root_crl:
    """
    -----BEGIN X509 CRL-----
    MIIBGTCBoAIBATAKBggqhkjOPQQDBDBhMQswCQYDVQQGEwJKUDEOMAwGA1UECAwF
    VG9reW8xCjAIBgNVBAcMAS4xEDAOBgNVBAoMB1ByaXZhdGUxCjAIBgNVBAsMAS4x
    GDAWBgNVBAMMD1ByaXZhdGUgUm9vdCBDQRcNMjMwNDAxMDYxNTUxWhcNMjMwNTAx
    MDYxNTUxWqAOMAwwCgYDVR0UBAMCAQEwCgYIKoZIzj0EAwQDaAAwZQIxAKk7iXz3
    7edcGudaOFhcw32Hu7ZsmCiwiuLADZSWjen++f2AU2e5exJi1y4i6pD5yAIwZ/nU
    7q/J7K56I7t2RcXYIi9bfMqzsbhdiEJCfgqSWptcPEiyjGq1FO2N7mm4vDR8
    -----END X509 CRL-----
    """

  nginx_site_private_ca_inter_tls_certificate: private_ca_inter_tls_certificate
  nginx_site_private_ca_inter_tls_crl:
    """
    -----BEGIN X509 CRL-----
    MIIBFzCBnwIBATAKBggqhkjOPQQDBDBgMQswCQYDVQQGEwJKUDEOMAwGA1UECAwF
    VG9reW8xCjAIBgNVBAcMAS4xEDAOBgNVBAoMB1ByaXZhdGUxCjAIBgNVBAsMAS4x
    FzAVBgNVBAMMDlByaXZhdGUgVExTIENBFw0yMzA0MDEwNjE2MDJaFw0yMzA1MDEw
    NjE2MDJaoA4wDDAKBgNVHRQEAwIBATAKBggqhkjOPQQDBANnADBkAjBE3yg1hEvU
    dE4oZJmul52gscX/mUFj/4hhBxz78Mfak7OShDqXfwSyX+gSc+zcOC0CMF05a/Y6
    Zrn6GScQ9sq6t+PAxLKBxz47WGNBIHQdpgeF9qzgGsJnZq8c+N6Ku+xwjw==
    -----END X509 CRL-----
    """

  nginx_site_local_proxy_certificate_fullchain:
    """
    -----BEGIN CERTIFICATE-----
    MIIDijCCAxGgAwIBAgIBAjAKBggqhkjOPQQDBDBgMQswCQYDVQQGEwJKUDEOMAwG
    A1UECAwFVG9reW8xCjAIBgNVBAcMAS4xEDAOBgNVBAoMB1ByaXZhdGUxCjAIBgNV
    BAsMAS4xFzAVBgNVBAMMDlByaXZhdGUgVExTIENBMB4XDTIzMDQwMTA3MjkxOFoX
    DTI0MDMzMTA3MjkxOFowZTELMAkGA1UEBhMCSlAxDjAMBgNVBAgMBVRva3lvMQow
    CAYDVQQHDAEuMRAwDgYDVQQKDAdQcml2YXRlMQowCAYDVQQLDAEuMRwwGgYDVQQD
    DBMqLm1penVuYXNoaS5wcml2YXRlMHYwEAYHKoZIzj0CAQYFK4EEACIDYgAET8fM
    14MEq4TgIMh0ERSp4JmrGQ6O9G9TJLrJOERwytJzphCWOE4feaLZ9SB5mVJ32CZk
    hXsqr5GEDuCohrI0X9wZacpBmNyEdK3HILVmdKQppdR9QQJkCk594VGayEr7o4IB
    mDCCAZQwHQYDVR0OBBYEFFDQAAlLKVw7VfhlVISlEP9hveVjMIGLBgNVHSMEgYMw
    gYCAFAFnVTvzxVhBK7HYbEfIzMG8JqNnoWWkYzBhMQswCQYDVQQGEwJKUDEOMAwG
    A1UECAwFVG9reW8xCjAIBgNVBAcMAS4xEDAOBgNVBAoMB1ByaXZhdGUxCjAIBgNV
    BAsMAS4xGDAWBgNVBAMMD1ByaXZhdGUgUm9vdCBDQYIBATAJBgNVHRMEAjAAMA4G
    A1UdDwEB/wQEAwIHgDAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwSgYI
    KwYBBQUHAQEEPjA8MDoGCCsGAQUFBzAChi5odHRwOi8vY2EtbG9jYWwubWl6dW5h
    c2hpLndvcmsvaW50ZXJDQV9UTFMuY3J0MD8GA1UdHwQ4MDYwNKAyoDCGLmh0dHA6
    Ly9jYS1sb2NhbC5taXp1bmFzaGkud29yay9pbnRlckNBX1RMUy5jcmwwHgYDVR0R
    BBcwFYITKi5taXp1bmFzaGkucHJpdmF0ZTAKBggqhkjOPQQDBANnADBkAjAmgvXM
    JrM1sDfsmu4SlxUKv8s4HTJW4w2BrXYmiNAvracHk2ouhI9YvAxgq4lUqH0CMBgg
    lOqIXea1565nIMmWO938gR9qL1zwoKAEEWTiFTBaVXitSqEJ+eNOqsnbR3V5Kg==
    -----END CERTIFICATE-----
    \(private_ca_inter_tls_certificate)
    """
  nginx_site_local_proxy_certificate_chain: private_ca_inter_tls_certificate
  nginx_site_local_proxy_certificate_privkey:
    "__ansible_vault":
      """
      $ANSIBLE_VAULT;1.1;AES256
      66333336356339636232646361386539343234666238346366616662643533626264326137636466
      3133366130656130343136646263653038346435653734380a323262393130613639346166326166
      33313161396431386532373462376463333239633435336663636631343230663036636465396638
      3137323231366363640a336434636334643630333861373862616233333762343935656361316364
      64613935666337336333356530353935336163346532613533633766663264303964373861366131
      35356238386361353236623066643535383530616133303139366634313135366537343466356433
      66303832633064313962313638313431313862636531306334396434653961633931396361333537
      65626631396535333038313839323631333965623664383761356662343333663937306562663564
      33323930323932396332306230356632616465323565303763386537323761633230666338373961
      37393530646437333363396133626230393531323061303539633231316631323730303163373039
      32386135643734636634643461313935613663656462656334336164653236636237303864666536
      30393936343861623062323664323764343235346261613238633166383832373363353437323733
      64616237333134643634303932326131666139633962303964623233316430383734396165633061
      39646431336636343933363132353030363339356533626165616363623835616461366661323566
      39356264396139633861626435363961323561616363633261303663316664376464636237373038
      35646136616137663365653537666365346333356238383036616364306534306639393765303237
      65356566653233663234633133643535623862396631333939303533343962303565383063613231
      62306132623637653632383834353937626665626230323537373133646566626165643234333933
      65623061316365336265613230323765623432626536663838643630383936633661333137356365
      31666530333037356338
      """
}
