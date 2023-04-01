import "mizunashi.work/pkg/cue_vars/vagrant"
import "mizunashi.work/pkg/vagrant_private_ca"

import "mizunashi.work/pkg/roles/nftables"
import "mizunashi.work/pkg/roles/nginx"
import "mizunashi.work/pkg/roles/mastodon"
import "mizunashi.work/pkg/roles/nginx_exporter"
import "mizunashi.work/pkg/roles/exim"
import "mizunashi.work/pkg/roles/openssl_ocsp_responder"
import "mizunashi.work/pkg/roles/nginx_site_http_redirector"
import "mizunashi.work/pkg/roles/nginx_site_mastodon_front"
import "mizunashi.work/pkg/roles/nginx_site_local_proxy"
import "mizunashi.work/pkg/roles/nginx_site_private_ca"
import "mizunashi.work/pkg/roles/postgresql_mastodon"
import "mizunashi.work/pkg/roles/private_mastodon_certificate"

#Schema: vagrant
#Schema: nginx
#Schema: mastodon
#Schema: exim
#Schema: openssl_ocsp_responder
#Schema: nginx_exporter
#Schema: nginx_site_http_redirector
#Schema: nginx_site_mastodon_front
#Schema: nginx_site_local_proxy
#Schema: nginx_site_private_ca
#Schema: postgresql_mastodon
#Schema: private_mastodon_certificate
#Schema: enable_private_mastodon_certificate: bool

let ssh_port = vagrant.#ssh_port
let http_port = 80
let https_port = 443
let ocsp_responder_port_for_root = 4211
let ocsp_responder_port_for_inter_tls = 4212
let local_proxy_https_port = 19100

#Schema & {
  mastodon_local_domain: "mstdn-local.mizunashi.work"
  exim_mail_domain: "mail-local.mizunashi.work"
  nginx_site_private_ca_domain: "ca-local.mizunashi.work"

  nginx_site_http_redirector_listen_port: http_port
  nginx_site_private_ca_listen_port: http_port
  nginx_site_mastodon_front_listen_port: https_port
  nginx_site_local_proxy_listen_port: local_proxy_https_port

  nftables_accept_tcp_ports: [
    ssh_port,
    http_port,
    https_port,
  ]

  nginx_site_local_proxy_common_domain: "mizunashi.private"
  nginx_site_local_proxy_entries: {
    "node":
      upstream_port: 9100
  }

  openssl_ocsp_responder_entries: {
    "rootCA": {
      listen_port: ocsp_responder_port_for_root
      ca_cert: vagrant_private_ca.root_ca_certificate
      ca_privkey: vagrant_private_ca.root_ca_privkey
      ca_database_content: vagrant_private_ca.root_ca_database
    }
    "interCA_TLS": {
      listen_port: ocsp_responder_port_for_inter_tls
      ca_cert: vagrant_private_ca.inter_tls_ca_certificate
      ca_privkey: vagrant_private_ca.inter_tls_ca_privkey
      ca_database_content: vagrant_private_ca.inter_tls_ca_database
    }
  }

  nginx_resolver: "8.8.8.8"

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
    MIID+jCCA4CgAwIBAgIBATAKBggqhkjOPQQDBDB+MQswCQYDVQQGEwJKUDEOMAwG
    A1UECAwFVG9reW8xCjAIBgNVBAcMAS4xEDAOBgNVBAoMB1ByaXZhdGUxIDAeBgNV
    BAsMF21penVuYXNoaS13b3JrLXBsYXlib29rMR8wHQYDVQQDDBZWYWdyYW50IFBy
    aXZhdGUgVExTIENBMB4XDTIzMDQwMTEzMDE0NVoXDTI0MDMzMTEzMDE0NVowgYIx
    CzAJBgNVBAYTAkpQMQ4wDAYDVQQIDAVUb2t5bzEKMAgGA1UEBwwBLjEQMA4GA1UE
    CgwHUHJpdmF0ZTEgMB4GA1UECwwXbWl6dW5hc2hpLXdvcmstcGxheWJvb2sxIzAh
    BgNVBAMMGm1zdGRuLWxvY2FsLm1penVuYXNoaS53b3JrMHYwEAYHKoZIzj0CAQYF
    K4EEACIDYgAED5KMxV+pTJO2PQIixSm+PJoxxLdNvnnYgptfNDGjfYih3wAtiX2K
    ps/8hOPKqdhrJqZVseGAN80jCktxbT8e6dutuzeWj7lcn8qKOzd3GljMXKypJLO0
    k7zxrBdSGW0Ro4IByzCCAccwHQYDVR0OBBYEFH3wyOsCmJKkCglc2C22icMWpYgJ
    MIGrBgNVHSMEgaMwgaCAFJrW/hJa02X/sw8/Ji0fk03p2Iw9oYGEpIGBMH8xCzAJ
    BgNVBAYTAkpQMQ4wDAYDVQQIDAVUb2t5bzEKMAgGA1UEBwwBLjEQMA4GA1UECgwH
    UHJpdmF0ZTEgMB4GA1UECwwXbWl6dW5hc2hpLXdvcmstcGxheWJvb2sxIDAeBgNV
    BAMMF1ZhZ3JhbnQgUHJpdmF0ZSBSb290IENBggEBMAkGA1UdEwQCMAAwDgYDVR0P
    AQH/BAQDAgeAMB0GA1UdJQQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjB9BggrBgEF
    BQcBAQRxMG8wMQYIKwYBBQUHMAGGJWh0dHA6Ly9jYS1sb2NhbC5taXp1bmFzaGku
    d29yazoxMDA4Mi8wOgYIKwYBBQUHMAKGLmh0dHA6Ly9jYS1sb2NhbC5taXp1bmFz
    aGkud29yay9pbnRlckNBX1RMUy5jcnQwPwYDVR0fBDgwNjA0oDKgMIYuaHR0cDov
    L2NhLWxvY2FsLm1penVuYXNoaS53b3JrL2ludGVyQ0FfVExTLmNybDAKBggqhkjO
    PQQDBANoADBlAjEA6Ym0DdSt4a2G3nNnq8ItACrwDu1IpTGiHxny44MF115nAkiZ
    WY8ISfGO0a+wzbP6AjA/sJRYj9PILyIfA4y+TRNondcNr4Q+T16/2nK9nyPtDACc
    p/6fmPXALC998eWXG9k=
    -----END CERTIFICATE-----
    \(vagrant_private_ca.inter_tls_ca_certificate)
    """
  private_mastodon_certificate_chain: vagrant_private_ca.inter_tls_ca_certificate
  private_mastodon_certificate_privkey:
    "__ansible_vault":
      """
      $ANSIBLE_VAULT;1.1;AES256
      64313237313737653434333164306262396338316138613035363633633234373138346536366463
      3564396565353464373665633339323862666131633235370a636639633632323133623335333865
      37333835633935376437623235346163623365643738303339343431376262666533666561626532
      3064373033356230340a346432343163323961323234333330633932346537343533393164353739
      39643932636663343332336333666134623361663966336432643332383233616430316364333332
      64333935663031363034333963323762623633386663313363643265366364336365363862613663
      61623766633361396430323130313431383066346366653834333036646237316236353565306265
      31336233643038386365373537626231626330316536633665343763653030656262613433626132
      36343536343537623033376566663537393438633535623035346165653066663438353337626166
      36313835346435346663626661353466326263616232613339333138366561313963613061623532
      32333931363539313162353738363631373161343262623266373431366538613365303432326461
      34646230363832373661383433353933626261663931353564393463313737313237636262666161
      30353331356135656538383766373165396636343335393731383834646331313365616637643537
      39663266613162323434346131616339356635366538666630613239306330366639613163393762
      36343730323963363166663336306339646332396138616466636661613136313163653133623032
      62323935363566333861333235333038613764313234303162633065326236303134626566616563
      64313064613531303331383965303838636266666135353763306131323366393261306534633134
      63636465343861663938383931633166386466393732313861656631353661623861353464396164
      65303930663964623235376433623164643134663830373436663363643262323963653930643833
      31316663613065356638
      """

  nginx_site_private_ca_root_certificate: vagrant_private_ca.root_ca_certificate
  nginx_site_private_ca_root_crl: vagrant_private_ca.root_ca_crl

  nginx_site_private_ca_inter_tls_certificate: vagrant_private_ca.inter_tls_ca_certificate
  nginx_site_private_ca_inter_tls_crl: vagrant_private_ca.inter_tls_ca_crl

  nginx_site_local_proxy_certificate_fullchain:
    """
    -----BEGIN CERTIFICATE-----
    MIIEEzCCA5igAwIBAgIBAjAKBggqhkjOPQQDBDB+MQswCQYDVQQGEwJKUDEOMAwG
    A1UECAwFVG9reW8xCjAIBgNVBAcMAS4xEDAOBgNVBAoMB1ByaXZhdGUxIDAeBgNV
    BAsMF21penVuYXNoaS13b3JrLXBsYXlib29rMR8wHQYDVQQDDBZWYWdyYW50IFBy
    aXZhdGUgVExTIENBMB4XDTIzMDQwMTEzMDU1M1oXDTI0MDMzMTEzMDU1M1owezEL
    MAkGA1UEBhMCSlAxDjAMBgNVBAgMBVRva3lvMQowCAYDVQQHDAEuMRAwDgYDVQQK
    DAdQcml2YXRlMSAwHgYDVQQLDBdtaXp1bmFzaGktd29yay1wbGF5Ym9vazEcMBoG
    A1UEAwwTKi5taXp1bmFzaGkucHJpdmF0ZTB2MBAGByqGSM49AgEGBSuBBAAiA2IA
    BNu8bGeNIR9gHF1A5f/elki3AK0C7qlFJYKiVKu4fguBiKM5wLa03rvM44jLH/nu
    WkyO1vLhU1Mu78V924GGhA13GmaEmI3tQGAY1DdI/iccAGLNtQBqieqJ9Av4XG7O
    o6OCAeswggHnMB0GA1UdDgQWBBR7rJwCs6et/UTZzISAC1ubNEQNmDCBqwYDVR0j
    BIGjMIGggBSa1v4SWtNl/7MPPyYtH5NN6diMPaGBhKSBgTB/MQswCQYDVQQGEwJK
    UDEOMAwGA1UECAwFVG9reW8xCjAIBgNVBAcMAS4xEDAOBgNVBAoMB1ByaXZhdGUx
    IDAeBgNVBAsMF21penVuYXNoaS13b3JrLXBsYXlib29rMSAwHgYDVQQDDBdWYWdy
    YW50IFByaXZhdGUgUm9vdCBDQYIBATAJBgNVHRMEAjAAMA4GA1UdDwEB/wQEAwIH
    gDAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwfQYIKwYBBQUHAQEEcTBv
    MDEGCCsGAQUFBzABhiVodHRwOi8vY2EtbG9jYWwubWl6dW5hc2hpLndvcms6MTAw
    ODIvMDoGCCsGAQUFBzAChi5odHRwOi8vY2EtbG9jYWwubWl6dW5hc2hpLndvcmsv
    aW50ZXJDQV9UTFMuY3J0MD8GA1UdHwQ4MDYwNKAyoDCGLmh0dHA6Ly9jYS1sb2Nh
    bC5taXp1bmFzaGkud29yay9pbnRlckNBX1RMUy5jcmwwHgYDVR0RBBcwFYITKi5t
    aXp1bmFzaGkucHJpdmF0ZTAKBggqhkjOPQQDBANpADBmAjEAozr5KoYfcpKDqO+L
    tZCvYv6NbR8mDYwkAZYj8yRLDGHhDyjUFbFzLtZ2JoAFgOwoAjEApi2ZbLBDAa5y
    +L0LtbIN4v3bFjSOjdSKDMJj+HlVMm27jj42vvkdJCD4XhAlJc/O
    -----END CERTIFICATE-----
    \(vagrant_private_ca.inter_tls_ca_certificate)
    """
  nginx_site_local_proxy_certificate_chain: vagrant_private_ca.inter_tls_ca_certificate
  nginx_site_local_proxy_certificate_privkey:
    "__ansible_vault":
      """
      $ANSIBLE_VAULT;1.1;AES256
      31373337393738326463643161623337373463663761633962353633623438353838356137656463
      3235623336616531356561663762373461363664343338320a336436363030613662366139356538
      65343935326261363332303832346566623934323831343137323164653062386664393237623538
      3731343337653738610a666136656366613636613135313736383364326430376265636566656362
      62626239386464366239623636613266613062396564656136633765633235613464633233393166
      30646533396235643537383665393130633064363638373863666462653934333565626436646232
      39616237646236626236376436346665346138333233333032396531393131613163643037376331
      33333238323932323562366436663038343161303631326533326239313637656164353432633736
      65343334323364356561623966616630363661623436393132336561333863373163323764386363
      61663933636638396564326532376537653364393832336636353230353338663039643632656161
      34336637326362333137336632323338383036613263633866616231666262373439326239393265
      32396634663638663130366535353463393734313330623430326139613261323033666438313564
      30373232666465326334663934633631396138393831653132306236366333626365636636373164
      65393333333439313135343664386262306331653837373739333163333639326636373663313662
      37643034323336376365303437303733373035663033643266346634343531376261653339306465
      65393932656264623066316534376563353364353638396165303166633461663839623765306337
      33643863343437346362303664366634343131343037346239393163323132376230333538333131
      63363235323965383238663738373465303439323637303330363565313164333966613437373839
      64663333316662626235636231623262656461366235633738623932653033653166346665363130
      63353035316133363130
      """
  nginx_site_local_proxy_certificate_client_chain: vagrant_private_ca.inter_tls_ca_certificate
}
