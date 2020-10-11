# Разворачивание кластера GCP с помощью terrafom и kubespray
В директории **infra_GCP** содерджится код для разворачивания заданного в файлике **infra_GCP/variables.tf** числа нод. \
Там же есть все остальные настройки, касающиеся разворачивания нод в GCP. \
В файлике **infra_GCP/custom_cluster_settings.yml** содержатся настройки **kubespray**. В частности - там включены **nginx ingress**, а также автоматический провижионер для локальных томов - **Rancher Local Path Provisioner**. \
В директории **infra_playbooks** содержатся плейбуки, которые запускает скрипт после настройки инфраструктуры в GCP. \
Чтобы создать кластер достаточно перейти в директорию **infra_GCP** убедиться, что на локальном хосте установлено то что описано в файле **infra_GCP/README.md** и запустить:
```
terraform init
terraform plan
terrafrom apply
```
В итоге - кластер создастся, а в корневой директории проекта появится файлик **kube-cluster-admin.conf** с данными, необходимыми для управления кластером.
```
KUBECONFIG=../kube-cluster-admin.conf kubectl get no -o wide
NAME      STATUS   ROLES    AGE     VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION    CONTAINER-RUNTIME
master1   Ready    master   4h46m   v1.19.2   10.142.0.61   <none>        Ubuntu 18.04.2 LTS   4.15.0-1029-gcp   docker://19.3.13
master2   Ready    master   4h45m   v1.19.2   10.142.0.55   <none>        Ubuntu 18.04.2 LTS   4.15.0-1029-gcp   docker://19.3.13
master3   Ready    master   4h45m   v1.19.2   10.142.0.59   <none>        Ubuntu 18.04.2 LTS   4.15.0-1029-gcp   docker://19.3.13
worker1   Ready    <none>   4h44m   v1.19.2   10.142.0.60   <none>        Ubuntu 18.04.2 LTS   4.15.0-1029-gcp   docker://19.3.13
worker2   Ready    <none>   4h44m   v1.19.2   10.142.0.58   <none>        Ubuntu 18.04.2 LTS   4.15.0-1029-gcp   docker://19.3.13
```
Файлики 



