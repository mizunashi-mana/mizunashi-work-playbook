import "mizunashi.work/pkg/cue_vars/vagrant"
import "mizunashi.work/pkg/private_ca_vagrant"

import "mizunashi.work/pkg/schemas/group_vars_public"

#Schema: group_vars_public
#Schema: vagrant

#Schema & {
  mastodon_local_domain: #Schema.#mastodon_hostname

  nginx_site_http_redirector_listen_port: #Schema.#http_port
  nginx_site_mastodon_front_listen_port: #Schema.#https_port
  nginx_site_www_redirector_listen_port: #Schema.#https_port
  nginx_site_root_front_listen_port: #Schema.#https_port

  nftables_accept_tcp_ports: "\(#Schema.#http_port)": {}
  nftables_accept_tcp_ports: "\(#Schema.#https_port)": {}
  nftables_outbound_logging_filter_entries: "local_network_for_public": {
    oif: "lo"
    ip_cond: {
      all: true
    }
    proto_cond: {
      tcp_sports: [
        #Schema.redis_server_listen_port,
      ]
      tcp_dports: [
        #Schema.redis_server_listen_port,
      ]
    }
  }
  nftables_outbound_logging_filter_entries: "open_public_network_for_public": {
    oif: #Schema.network_public_iface
    ip_cond: {
      all: true
    }
    proto_cond: {
      tcp_sports: [
        #Schema.#http_port,
        #Schema.#https_port,
      ]
    }
  }

  nginx_site_local_proxy_entries: "\(#Schema.#local_proxy_jobs.redis.name)": {
    upstream_port: #Schema.redis_exporter_listen_port
    auth_password: #Schema.#local_proxy_jobs.redis.password
  }
  nginx_site_local_proxy_entries: "\(#Schema.#local_proxy_jobs.postgres.name)": {
    upstream_port: #Schema.postgres_exporter_listen_port
    auth_password: #Schema.#local_proxy_jobs.postgres.password
  }
  nginx_site_local_proxy_entries: "\(#Schema.#local_proxy_jobs.statsd.name)": {
    upstream_port: #Schema.statsd_exporter_web_listen_port
    auth_password: #Schema.#local_proxy_jobs.statsd.password
  }
  nginx_site_local_proxy_entries: "\(#Schema.#local_proxy_jobs.mastodon_streaming.name)": {
    upstream_port: #Schema.mastodon_streaming_listen_port
    auth_password: #Schema.#local_proxy_jobs.mastodon_streaming.password
  }

  nginx_site_mastodon_front_acme_challenge_url: #Schema.#private_acme_challenge_url
  nginx_site_mastodon_front_ca_bundle_path: #Schema.ca_certs_bundle_file_with_private_ca
  nginx_site_mastodon_front_maintenance_mode: false

  nginx_site_www_redirector_domain: #Schema.#www_hostname
  nginx_site_www_redirector_url: "https://mizunashi-mana.github.io"
  nginx_site_www_redirector_acme_challenge_url: #Schema.#private_acme_challenge_url
  nginx_site_www_redirector_ca_bundle_path: #Schema.ca_certs_bundle_file_with_private_ca

  nginx_site_root_front_domain: #Schema.#root_hostname
  nginx_site_root_front_url: "https://\(#Schema.#www_hostname)"
  nginx_site_root_front_acme_challenge_url: #Schema.#private_acme_challenge_url
  nginx_site_root_front_ca_bundle_path: #Schema.ca_certs_bundle_file_with_private_ca

  #fluent_bit_input_nginx_log_access_mastodon_front_tag: "nginx.access.mastodon_front"
  fluent_bit_input_nginx_log_access_entries: "\(#fluent_bit_input_nginx_log_access_mastodon_front_tag)": {
    log_file: "/var/log/nginx/access.mastodon_front.log"
  }

  #fluent_bit_input_nginx_log_access_www_redirector_tag: "nginx.access.www_redirector"
  fluent_bit_input_nginx_log_access_entries: "\(#fluent_bit_input_nginx_log_access_www_redirector_tag)": {
    log_file: "/var/log/nginx/access.www_redirector.log"
  }

  fluent_bit_output_elasticsearch_entries: "\(#fluent_bit_input_nginx_log_access_mastodon_front_tag)": {}
  fluent_bit_output_elasticsearch_entries: "\(#fluent_bit_input_nginx_log_access_www_redirector_tag)": {}

  postgres_backup_s3_scheme: "https"
  postgres_backup_s3_access_key: #Schema.#postgres_backup_config.access_key
  postgres_backup_s3_secret_key: #Schema.#postgres_backup_config.secret_key
  postgres_backup_s3_hostname: #Schema.#minio_server_hostname
  postgres_backup_s3_port: #Schema.#minio_server_https_port
  postgres_backup_s3_bucket: #Schema.#postgres_backup_config.bucket

  mastodon_single_user_mode: "true"

  mastodon_db_user_password: "__ansible_vault": """
  $ANSIBLE_VAULT;1.1;AES256
  65333663363039383963396135643335373032636437653730356635613734303434336534323136
  3135363037306231643964396337663435643266633566340a616137393839323333353332626462
  61383633343664306232393766613635303962303237626231333734313236646562626261386130
  3263663039376435390a383532326435363036646533393639356536626539333530343835653961
  30333436616561303861653761613238316162316430626664326662646135643737
  """

  mastodon_secret_key_base: "__ansible_vault": """
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
  mastodon_otp_secret: "__ansible_vault": """
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

  mastodon_vapid_private_key: "__ansible_vault": """
  $ANSIBLE_VAULT;1.1;AES256
  34633130343535333432333436613738373337356433336238616161313239376530383663366130
  3732656338646634656263636632616461663136336234390a356665633565653131343937326330
  61646133633061323164376165666231393234373266643836656561663838393735393738303037
  6665306434633234340a306362396535306464386232333332633739366139383430366266343930
  65333436343931616230393361653234376438313764333937616330353464373132373861356465
  3565323135626462313931613335633363643938396262373962
  """
  mastodon_vapid_public_key: "BMRVNeG8Io07OP2yGLhhhIXiX-m7Tjjhws_RJ9b1BvBXTKj8wRn9XAyRBoeM04TUgj26qkdnrtBbcRh_XODZW3k="

  redis_server_auth_password: "__ansible_vault": """
  $ANSIBLE_VAULT;1.1;AES256
  31306435633332313262633863316466396538623261346165326263623062356563633034623031
  3463656139626236336433643062643361633731393563630a303562386337663931616639653761
  62613733663763633762316465616634323833623339643039336162643532326264343937626464
  6561343033613965350a663633643161643762623237396633386563393239356563396363363865
  3062
  """

  postgres_exporter_user_password: "__ansible_vault": """
  $ANSIBLE_VAULT;1.1;AES256
  31306435633332313262633863316466396538623261346165326263623062356563633034623031
  3463656139626236336433643062643361633731393563630a303562386337663931616639653761
  62613733663763633762316465616634323833623339643039336162643532326264343937626464
  6561343033613965350a663633643161643762623237396633386563393239356563396363363865
  3062
  """
}
