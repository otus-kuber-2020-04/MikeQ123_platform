# Установка Vault
```
helm status vault -n vault
NAME: vault
LAST DEPLOYED: Sun Aug  9 13:31:45 2020
NAMESPACE: vault
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Thank you for installing HashiCorp Vault!

Now that you have deployed Vault, you should look over the docs on using
Vault with Kubernetes available here:

https://www.vaultproject.io/docs/


Your release is named vault. To learn more about the release, try:

  $ helm status vault
  $ helm get vault
```

# Инициализация Vault
```
Unseal Key 1: EEvC8nTJ7gw1SQtMJIly6JKtk6SWm+DyJWGycq/ECq4=

Initial Root Token: s.Ta90nQ3ynlOEqkWm4g0WiJRJ

Vault initialized with 1 key shares and a key threshold of 1. Please securely
distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 1 of these keys to unseal it
before it can start servicing requests.

Vault does not store the generated master key. Without at least 1 key to
reconstruct the master key, Vault will remain permanently sealed!

It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault operator rekey" for more information.
```

# Распечатываем Vault
status ДО unseal
```
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       1
Threshold          1
Unseal Progress    0/1
Unseal Nonce       n/a
Version            1.4.2
HA Enabled         true
command terminated with exit code 2
```

Vault status после Unseal:
```
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    1
Threshold       1
Version         1.4.2
Cluster Name    vault-cluster-09554005
Cluster ID      974795dd-e8cd-d2b2-c7b6-7f724396bb85
HA Enabled      true
HA Cluster      https://vault-0.vault-internal:8201
HA Mode         active
```

# Логинимся в Vault
Вывод после логина:
```
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                  Value
---                  -----
token                s.Ta90nQ3ynlOEqkWm4g0WiJRJ
token_accessor       CvwFHVlSNmSthr5Vq5ofXCmM
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]
```

Смотрим список авторизаций после логина:
```
Path      Type     Accessor               Description
----      ----     --------               -----------
token/    token    auth_token_3cd8b725    token based credentials
```

# Создание секретов в Vault
Вывод команды чтения секрета:
```
Key                 Value
---                 -----
refresh_interval    768h
password            asajkjkahs
username            otus
```

# Использование Vault c K8S
Список авторизаций после включения авторизации через k8s:
```
Path           Type          Accessor                    Description
----           ----          --------                    -----------
kubernetes/    kubernetes    auth_kubernetes_b1b67772    n/a
token/         token         auth_token_3cd8b725         token based credentials
```

Конструкция 
```
 sed ’s/\x1b\[[0-9;]*m//g’
```
убирает escape символы, которые раскрашивают текст.


Мы смогли  записать otus-rw/config1 но не смогли otus-rw/config потому как для пути "otus-rw/config" в политике был явно задан список capability, в котором не было разрешено update, а для пути "otus-rw/config1" никаких политик не было задано - можно всё.

# Хранение сертификатов в Vault 
Вывод при создании сертификата:
```
kubectl exec -it -n vault vault-0 -- vault write pki_int/issue/example-dot-ru common_name="test.example.ru" ttl="24h"
Key                 Value
---                 -----
ca_chain            [-----BEGIN CERTIFICATE-----
MIIDnDCCAoSgAwIBAgIUIYRbAPAFPrilsLyzG+m5HMyUbBUwDQYJKoZIhvcNAQEL
BQAwFTETMBEGA1UEAxMKZXhhbXBsZS5ydTAeFw0yMDA4MTExOTI3MDNaFw0yNTA4
MTAxOTI3MzNaMCwxKjAoBgNVBAMTIWV4YW1wbGUucnUgSW50ZXJtZWRpYXRlIEF1
dGhvcml0eTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKw8BeT5Gmok
0R3AcVZEbywgyXD4vTYLfLowel5kj3Et1NyHb+/6RP0PMurpeVAJLL5Fk2Lje3vq
8ZMf9idtYVsIc9CaoWUuzZBbDGZGY+FUPH46hoLKzv9D+KxY8th81XD2/BCUfJgM
W+EAnwEDrfkyIoGJ8jbwR9pHI/4AE9a9v2Us2vICNfvi8bQPZYfftOFjio2H0vsz
CL/IZU2+0Q6Wv+IavoDKW1TjMWNaFAJcUjcxPqkT60dbURlOuYA/vcbgneLcfiYA
ElHFxr+GKPJxLvvWDglH9QClTnAfz+rn8AVUKCEGyRbMjBnuPIMOvuWs9pgde9fK
1Ejq75MXxo0CAwEAAaOBzDCByTAOBgNVHQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUw
AwEB/zAdBgNVHQ4EFgQUxM0va9jnvNdbjKtSzbMFjDo89TcwHwYDVR0jBBgwFoAU
yApoB++iPn945dQGtT22ZZ4viLkwNwYIKwYBBQUHAQEEKzApMCcGCCsGAQUFBzAC
hhtodHRwOi8vdmF1bHQ6ODIwMC92MS9wa2kvY2EwLQYDVR0fBCYwJDAioCCgHoYc
aHR0cDovL3ZhdWx0OjgyMDAvdjEvcGtpL2NybDANBgkqhkiG9w0BAQsFAAOCAQEA
Hq81OvLsvtRrPpwUm1UNYnPSeQObyL74m/vhOxQ86JFVfldKkODE63T6zhamoV3r
3MDTkPxKEc5riUxZIvMwaIwtzC3zmKhvN+iE6i/G5IL5/DfSFom3r5jy4vb2XyNr
M4zNwo8cYO2/C+lJqeKmPDWRZcD4Y2+TvPzFD8qoi7flaYDtFk5PeWq7lS6qbRf3
vqSMxG6KBg9Lj5NmphRirLVqTcK4UzVaFj8OnGMig38pBli8N3JQPOV5uIYdN3AM
JJUsA3h3Zos7WiGBCjgtEf1oNEIVcBm2ZiJchHQl6crn60R/PY2OMFRyC+ZMz4Rf
v5T1FQ6RGdUdEY9Bkrm0Qg==
-----END CERTIFICATE-----]
certificate         -----BEGIN CERTIFICATE-----
MIIDYzCCAkugAwIBAgIURHDhzs1eW04q1pzFSgfoCCexi2AwDQYJKoZIhvcNAQEL
BQAwLDEqMCgGA1UEAxMhZXhhbXBsZS5ydSBJbnRlcm1lZGlhdGUgQXV0aG9yaXR5
MB4XDTIwMDgxMTE5MzQ1NloXDTIwMDgxMjE5MzUyNlowGjEYMBYGA1UEAxMPdGVz
dC5leGFtcGxlLnJ1MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApgRV
T+KpkjGK/4pxuSosqG3BLsMITWtDkfKmLAcGmawmHrchJ8KGqlAXE/QrwNSHsSxa
P1pEQYq/RUsJJPzMjldq7q0DcaCaCcCeKDt/GDG/UQPLsZBOR/MQh9WD3jkRTNrl
D6iSOYf9+TvENmrHhXmmoKUyeWmX3tPCI5HAQtzhXyZtfR7aMxbrkesAkrpywXXm
OPubEm9wDTA2NLLHFcrrBXZmspERyzdDtYhQFQZTHq1QRmr2xr9cEoRAWvt/LwxD
aPsJkvAiKjkOid2OjjmEIaROHarY8IzZaRJr6MWSZXs9pdyTG1PSAK1Eej8xXAAL
RKA9Lq3oSFESsYIw9QIDAQABo4GOMIGLMA4GA1UdDwEB/wQEAwIDqDAdBgNVHSUE
FjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwHQYDVR0OBBYEFOq+IHOJ7cMY1NA4f4P4
O5XTt7tGMB8GA1UdIwQYMBaAFMTNL2vY57zXW4yrUs2zBYw6PPU3MBoGA1UdEQQT
MBGCD3Rlc3QuZXhhbXBsZS5ydTANBgkqhkiG9w0BAQsFAAOCAQEAKC7tcM+ga3+P
BqZK10QMhpT2xw6PKYndKv33OKuCoI6CbUP2CB3qMbgCUrQS2mc7Wp0Fq5QKmwlJ
ZZb9Om9Z3nTRPE4JeTg+C2Df9wZy8iTNw6RoJkGK7r+8c8JkxvxWkfDkMCEwyApL
hkrmIgTwrwml/bzYDeNKiIOaipqDNRetopO4mwUtTYvTRRpEJNVkebi242ab5rs+
/dfe1IVmq6PdUJhTW4uDzuyq9gXbSjybM/Nak58KSfHjFxTkGrixOVZJco5+v9Lb
Pi0FaMezUhKDO6Y61YyCnGxhmfjKHCXKsthoozToJFlx3pE3veztss0bcY96TbaG
Wq74a3m3hw==
-----END CERTIFICATE-----
expiration          1597260926
issuing_ca          -----BEGIN CERTIFICATE-----
MIIDnDCCAoSgAwIBAgIUIYRbAPAFPrilsLyzG+m5HMyUbBUwDQYJKoZIhvcNAQEL
BQAwFTETMBEGA1UEAxMKZXhhbXBsZS5ydTAeFw0yMDA4MTExOTI3MDNaFw0yNTA4
MTAxOTI3MzNaMCwxKjAoBgNVBAMTIWV4YW1wbGUucnUgSW50ZXJtZWRpYXRlIEF1
dGhvcml0eTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKw8BeT5Gmok
0R3AcVZEbywgyXD4vTYLfLowel5kj3Et1NyHb+/6RP0PMurpeVAJLL5Fk2Lje3vq
8ZMf9idtYVsIc9CaoWUuzZBbDGZGY+FUPH46hoLKzv9D+KxY8th81XD2/BCUfJgM
W+EAnwEDrfkyIoGJ8jbwR9pHI/4AE9a9v2Us2vICNfvi8bQPZYfftOFjio2H0vsz
CL/IZU2+0Q6Wv+IavoDKW1TjMWNaFAJcUjcxPqkT60dbURlOuYA/vcbgneLcfiYA
ElHFxr+GKPJxLvvWDglH9QClTnAfz+rn8AVUKCEGyRbMjBnuPIMOvuWs9pgde9fK
1Ejq75MXxo0CAwEAAaOBzDCByTAOBgNVHQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUw
AwEB/zAdBgNVHQ4EFgQUxM0va9jnvNdbjKtSzbMFjDo89TcwHwYDVR0jBBgwFoAU
yApoB++iPn945dQGtT22ZZ4viLkwNwYIKwYBBQUHAQEEKzApMCcGCCsGAQUFBzAC
hhtodHRwOi8vdmF1bHQ6ODIwMC92MS9wa2kvY2EwLQYDVR0fBCYwJDAioCCgHoYc
aHR0cDovL3ZhdWx0OjgyMDAvdjEvcGtpL2NybDANBgkqhkiG9w0BAQsFAAOCAQEA
Hq81OvLsvtRrPpwUm1UNYnPSeQObyL74m/vhOxQ86JFVfldKkODE63T6zhamoV3r
3MDTkPxKEc5riUxZIvMwaIwtzC3zmKhvN+iE6i/G5IL5/DfSFom3r5jy4vb2XyNr
M4zNwo8cYO2/C+lJqeKmPDWRZcD4Y2+TvPzFD8qoi7flaYDtFk5PeWq7lS6qbRf3
vqSMxG6KBg9Lj5NmphRirLVqTcK4UzVaFj8OnGMig38pBli8N3JQPOV5uIYdN3AM
JJUsA3h3Zos7WiGBCjgtEf1oNEIVcBm2ZiJchHQl6crn60R/PY2OMFRyC+ZMz4Rf
v5T1FQ6RGdUdEY9Bkrm0Qg==
-----END CERTIFICATE-----
private_key         -----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEApgRVT+KpkjGK/4pxuSosqG3BLsMITWtDkfKmLAcGmawmHrch
J8KGqlAXE/QrwNSHsSxaP1pEQYq/RUsJJPzMjldq7q0DcaCaCcCeKDt/GDG/UQPL
sZBOR/MQh9WD3jkRTNrlD6iSOYf9+TvENmrHhXmmoKUyeWmX3tPCI5HAQtzhXyZt
fR7aMxbrkesAkrpywXXmOPubEm9wDTA2NLLHFcrrBXZmspERyzdDtYhQFQZTHq1Q
Rmr2xr9cEoRAWvt/LwxDaPsJkvAiKjkOid2OjjmEIaROHarY8IzZaRJr6MWSZXs9
pdyTG1PSAK1Eej8xXAALRKA9Lq3oSFESsYIw9QIDAQABAoIBAHP5VveFadv8zBMT
zboCYkwO0AMwr54VrpBIKBldlxjHD6IpX/n8hEJ5zIVd7yq3zUrRpwHWtxPqLw/j
CTJTfzp4ivTM3DkGblUdv95vIavvJK0dr7ANFQJiJEwftg0JZLKBv76ejfeurpbr
T3iMQ3FUuDhE7uut/i/lUhuy99I8hrsUNacnqXzZVjoghSDXt2oNMDCodqk9A48Q
QJnjQVAF061bF7xnRJguBMzh1lGt6FhEwUOCHOkLWav3KgsuC/HfOUBcOGZHYChl
sXxXS45tw3zTcemCvucqzZk0seewxizzqPBtsTlhOvZdpLTVblmoxOLG6+6dQ8RC
MmRO6skCgYEA2IUakssHGx8cfIEdCSFYn++o5q94Xx262VNX4thec1VhVeFVRnNS
H5z5E7R8sN3LKieP/3VQ1ajbp9e4qJh+v1rFXTxHs95s4/1aPILVqxeKWCR0SpZd
7f4jzbPIJvH9e4hVEQ4GKVcqIz9l1T6WYiJftLg8EkhrY6eeGsrddvsCgYEAxEnO
7D78SZfcIcTMOeMiortofcbRCom3H3n/9isW7GMdJT6HeHy3MicpDniam0sGRf8a
wd5hWrR5E8BPRDqNWba2bNvqEs2TdNdXHwwumE/+TmiIOX6S3iosLmNQW6/DU29U
Jl/n2Z3yTOQZ0ozq3+S84ApDDKl7e/8tTOGMNM8CgYBhFpZK2oVOMQ4p+g9WB8Dg
vquC/Y3BQOiHCOswygrYNqHVy5vcYluh11aM8nKzMFEojuLwDt/3XqdYRNAFsZOs
JHy5iQ0x53v2Y6Wx2o0LEhwz1+zZgUGPNVVCqOoIJJygZwqWAi7bHL3FXmlATLdM
O9OkirRNEnItFn070FmsPwKBgH5SxeGSk4jFO71bytdCTysNkyzHBAdVI84VFN6X
UpRlIP+0IzkugjO7sheHFHD2sp3flJfKBzt5xCYq8JiHWiqvhO3ABf993/UlFQN9
MouBh7dsXKcrx1dFKtPbxH6NOhZ7IlvkAvExThuf/OJdIFdg/RDuacI/XKIrUjsV
OMdPAoGAWinDd4M6kTDBLEagUogleV07EEo1l/D7cK41r3am6hEt/djQC6rHqDoy
yoWY195klYJiJA+qhzxas23eYZZuBuL8d4ETHhappVlfXJFbYWzgXbZwm41V6p9L
elILWAH0mM5bIpDnsb9CEnzqag63tQ1imfEOw8MATw0RseKHXmw=
-----END RSA PRIVATE KEY-----
private_key_type    rsa
serial_number       44:70:e1:ce:cd:5e:5b:4e:2a:d6:9c:c5:4a:07:e8:08:27:b1:8b:60
```

# HTTPS для vault. 
Таймкод в лекции zoom_0_4560_c55a68.mp4:
27:40 - 28:40 или более подробно - 1:10:10

Нужно выустить сертификат для vault, используя в качестве CA kubernetes (шпаргалка - https://gist.github.com/fntlnz/cf14feb5a46b2eda428e000157447309 ):
```
# генерируем ключ:
openssl genrsa -out vault.key 2048
# Создаем запрос сертификата (csr)
openssl req -new -sha256 -key vault.key -subj "/O=K8S/CN=vault" -out vault.csr
# Генерируем сертификат, используя в качестве CA корневой сертификат кластера Kubernetes
openssl x509 -req -in vault.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out vault.crt -days 3650 -sha256
```
Затем - создать из сертификата tls-секрет:
```
kubectl create secret tls vault-certs --cert=vault.crt --key=vault.key
```
 и затем в values.yaml:
  - задать переменные среды VAULT_ADDR (указать https), VAULT_CACERT (путь в /var/run/...)
  - Прописать секрет с сертификатом в extraVolumes
  - прописать путь до ключа и сертификата в ha.config -> listener "tcp" и там же выставить tls_disabled = 0
Из подов мы cможем обращаться к Vault примерно так:
```
VAULT_ADDR=https://vault:8200
KUBE_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
curl --cacert /var/run/secrets/kubernets.io/serviceaccount/ca.crt --request POST --data '{"jwt": "'$KUBE_TOKEN'", "role": "otus"}' $VAULT_ADDR/v1/auth/kubernetes/login
TOKEN=$(curl --cacert /var/run/secrets/kubernets.io/serviceaccount/ca.crt -s --request POST --data '{"jwt": "'$KUBE_TOKEN'", "role": "otus"}' $VAULT_ADDR/v1/auth/kubernetes/login | jq '.auth.client_token' | awk -F\" '{print $2}')
curl --cacert /var/run/secrets/kubernets.io/serviceaccount/ca.crt --header "X-Vault-Token:$TOKEN" $VAULT_ADDR/v1/otus/otus-rw/config
```

# Автоматическое обновление сертификатов с помощью consul-template

Как все работает.

  * в поде помимио прикладного контейнера (nginx) прописываются два дополнительных контейнера. Первый - init-контейнер vault-agent, который берет конфигурацию из конфигмапа и получает токен. Этот токен в дальнейшем использует второй контейнер - consul-template, который занимается тем, что обновляет данные в соответствии с темплейтом записаным в конфигмап. Обновленные данные он кладет в папку, которая смонтирована в него и в прикладной под с nginx.
  * Для того, чтобы все работало в Vault должна быть заведена политика, которая бы разрешала доступ для заданной роли в путь, где выпускаются сертификаты.

![](1.png)

![](2.png)