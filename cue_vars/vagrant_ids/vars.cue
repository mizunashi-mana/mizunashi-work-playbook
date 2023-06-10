package vagrant_ids

#private_domain: "mizunashi-local.private"

#internal_ipv6_prefix64: "fde4:8dba:82e1:1006"
#internal_ipv6_netmask: "64"
#internal_ipv6_subnet: "\(#internal_ipv6_prefix64)::/\(#internal_ipv6_netmask)"

#workuser_name: "vagrant"

#mastodon_hostname: "mstdn-local.mizunashi.work"
#www_hostname: "www.mizunashi.work"
#root_hostname: "mizunashi.work"

#account_email: "\(#workuser_name)@localhost"
#notification_email: "\(#workuser_name)@localhost"

#private_pki: {
  ca_name: "mizunashi-work-playbook Local Authority"
  common_name: "mizunashi-work-playbook - 2023 ECC Root"
}

#workuser_ssh_authorized_keys: [
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkqfF4qMFhr2fg+Yw3WLIqaRLqYzkCjWy2fdF4eQ5LG mizunashi-work-playbook"
]

#local_proxy_password: "__ansible_vault": """
$ANSIBLE_VAULT;1.1;AES256
36633436613662373337636363313865306635333737366632303932333939303065626239323236
3335333362613132666562323332623731646633366139610a666338373236393837636339323038
33383462353635313337616537636239636430386165363664363435383631353962623135643231
3965663439336432330a356139363465663438303430313733656431663232626433356136663632
6164
"""

#elasticsearch_log_upload_user: {
  name: "logstash_upload"
  password: "__ansible_vault": """
  $ANSIBLE_VAULT;1.1;AES256
  62356637313731376334383336616332393936306231343930343163666366613062643330323366
  3234626231666439646234653165393839306439326261370a346332316463623539623639623633
  61656566353831363366653531383530663564633661363361306134346338643761386136316565
  3033656435353263620a356264383762373763313464363235393734346261333666346234653832
  3666
  """
}

#elasticsearch_grafana_datasource_user: {
  name: "grafana_datasource"
  password: "__ansible_vault": """
  $ANSIBLE_VAULT;1.1;AES256
  62356637313731376334383336616332393936306231343930343163666366613062643330323366
  3234626231666439646234653165393839306439326261370a346332316463623539623639623633
  61656566353831363366653531383530663564633661363361306134346338643761386136316565
  3033656435353263620a356264383762373763313464363235393734346261333666346234653832
  3666
  """
}

#elasticsearch_elasticsearch_exporter_user: {
  name: "elasticsearch_exporter"
  password: "__ansible_vault": """
  $ANSIBLE_VAULT;1.1;AES256
  62356637313731376334383336616332393936306231343930343163666366613062643330323366
  3234626231666439646234653165393839306439326261370a346332316463623539623639623633
  61656566353831363366653531383530663564633661363361306134346338643761386136316565
  3033656435353263620a356264383762373763313464363235393734346261333666346234653832
  3666
  """
}

#minio_root_password: "__ansible_vault": """
$ANSIBLE_VAULT;1.1;AES256
62356637313731376334383336616332393936306231343930343163666366613062643330323366
3234626231666439646234653165393839306439326261370a346332316463623539623639623633
61656566353831363366653531383530663564633661363361306134346338643761386136316565
3033656435353263620a356264383762373763313464363235393734346261333666346234653832
3666
"""

#minio_postgres_backup_access: {
  key_id: "postgres-backup"
  secret_key: "__ansible_vault": """
  $ANSIBLE_VAULT;1.1;AES256
  62356637313731376334383336616332393936306231343930343163666366613062643330323366
  3234626231666439646234653165393839306439326261370a346332316463623539623639623633
  61656566353831363366653531383530663564633661363361306134346338643761386136316565
  3033656435353263620a356264383762373763313464363235393734346261333666346234653832
  3666
  """
}

#grafana_admin_password: "__ansible_vault": """
$ANSIBLE_VAULT;1.1;AES256
62356637313731376334383336616332393936306231343930343163666366613062643330323366
3234626231666439646234653165393839306439326261370a346332316463623539623639623633
61656566353831363366653531383530663564633661363361306134346338643761386136316565
3033656435353263620a356264383762373763313464363235393734346261333666346234653832
3666
"""

#grafana_secret_key: "__ansible_vault": """
$ANSIBLE_VAULT;1.1;AES256
31366134656464326563336233646561313931643962323836643336336563393733353764353338
3538376138313835363535623431633035613631623439300a386431613764613539316230313335
63643962313361376532653535326131366635663165646262646262613137613538613932366666
3230643631393831320a356131306564656134633161353562316165333533343030376531383136
39613832323838636132303962663638376162616364343630363665323462613434336164306336
6234396437353461323831646431373561373433373963333665
"""

#postgres_postgres_exporter_user: {
  name: "postgres_exporter"
  password: "__ansible_vault": """
  $ANSIBLE_VAULT;1.1;AES256
  31306435633332313262633863316466396538623261346165326263623062356563633034623031
  3463656139626236336433643062643361633731393563630a303562386337663931616639653761
  62613733663763633762316465616634323833623339643039336162643532326264343937626464
  6561343033613965350a663633643161643762623237396633386563393239356563396363363865
  3062
  """
}

#postgres_mastodon_db_user: {
  name: "mastodon"
  password: "__ansible_vault": """
  $ANSIBLE_VAULT;1.1;AES256
  65333663363039383963396135643335373032636437653730356635613734303434336534323136
  3135363037306231643964396337663435643266633566340a616137393839323333353332626462
  61383633343664306232393766613635303962303237626231333734313236646562626261386130
  3263663039376435390a383532326435363036646533393639356536626539333530343835653961
  30333436616561303861653761613238316162316430626664326662646135643737
  """
}

#mastodon_secret_key_base: "__ansible_vault": """
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
#mastodon_otp_secret: "__ansible_vault": """
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

#mastodon_vapid_secret: {
  private_key: "__ansible_vault": """
  $ANSIBLE_VAULT;1.1;AES256
  34633130343535333432333436613738373337356433336238616161313239376530383663366130
  3732656338646634656263636632616461663136336234390a356665633565653131343937326330
  61646133633061323164376165666231393234373266643836656561663838393735393738303037
  6665306434633234340a306362396535306464386232333332633739366139383430366266343930
  65333436343931616230393361653234376438313764333937616330353464373132373861356465
  3565323135626462313931613335633363643938396262373962
  """
  public_key: "BMRVNeG8Io07OP2yGLhhhIXiX-m7Tjjhws_RJ9b1BvBXTKj8wRn9XAyRBoeM04TUgj26qkdnrtBbcRh_XODZW3k="
}

#redis_server_auth_password: "__ansible_vault": """
$ANSIBLE_VAULT;1.1;AES256
31306435633332313262633863316466396538623261346165326263623062356563633034623031
3463656139626236336433643062643361633731393563630a303562386337663931616639653761
62613733663763633762316465616634323833623339643039336162643532326264343937626464
6561343033613965350a663633643161643762623237396633386563393239356563396363363865
3062
"""

#mstdn_rss2bsky_post_feed_url: "https://mstdn.mizunashi.work/@mizunashi_mana.rss"
#mstdn_rss2bsky_post_user: {
  identifier: "identifier"
  password: "__ansible_vault": """
  $ANSIBLE_VAULT;1.1;AES256
  31306435633332313262633863316466396538623261346165326263623062356563633034623031
  3463656139626236336433643062643361633731393563630a303562386337663931616639653761
  62613733663763633762316465616634323833623339643039336162643532326264343937626464
  6561343033613965350a663633643161643762623237396633386563393239356563396363363865
  3062
  """
}
