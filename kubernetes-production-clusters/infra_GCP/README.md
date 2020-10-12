# Подготовка хоста
Все манипуляции я выполнял на Ubuntu 20.04.

## Terraform
### Установка terraform
```
wget https://releases.hashicorp.com/terraform/0.13.1/terraform_0.13.1_linux_amd64.zip
unzip ./terraform_0.13.1_linux_amd64.zip 
sudo mv ./terraform /usr/local/bin/terraform
```

### Установска модулей terraform
```
terraform init
```

## Установка gcloud
```
echo "deb https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y install google-cloud-sdk kubectl
```
инициализация:
```
gcloud init
```

### Включаем сервисы на GCP
```
gcloud services enable compute.googleapis.com
gcloud services enable servicenetworking.googleapis.com
```

## Ansible
### Установка ansible и модулей python
```
sudo pip install ansible netaddr
```