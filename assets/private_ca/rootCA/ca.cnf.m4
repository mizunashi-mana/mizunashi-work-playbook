[ ca ]
default_ca      = CA_default

[ CA_default ]
dir               = ./rootCA
crl_dir           = $dir/crl
database          = $dir/var/index.txt
new_certs_dir     = $dir/newcerts
certificate       = $dir/cacert.pem
serial            = $dir/var/serial
crlnumber         = $dir/var/crlnumber
crl               = $dir/crl.pem
private_key       = $dir/private/cakey.pem
name_opt          = ca_default
cert_opt          = ca_default
default_days      = 365
default_crl_days  = 30
default_md        = sha512
preserve          = no
policy            = policy_anything
x509_extensions   = user_cert_ext
copy_extensions   = copy

[ policy_anything ]
countryName             = optional
stateOrProvinceName     = optional
localityName            = optional
organizationName        = optional
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional

[ user_cert_ext ]
subjectKeyIdentifier    = hash
authorityKeyIdentifier  = keyid, issuer:always
authorityInfoAccess     = @authority_info
crlDistributionPoints   = URI:__DISTRIBUTION_URL__/rootCA.crl

[ authority_info ]
OCSP;URI.0          = __DISTRIBUTION_URL__/rootCA.ocsp/
caIssuers;URI.0     = __DISTRIBUTION_URL__/rootCA.crt
