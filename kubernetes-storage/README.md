# Устанавливаем необходимые CRDs
https://github.com/kubernetes-csi/csi-driver-host-path/blob/master/docs/deploy-1.17-and-later.md \
Текущую версию Snapshotter смотрим тут: https://kubernetes-csi.github.io/docs/external-snapshotter.html
```
$ SNAPSHOTTER_VERSION=v2.1.0

# Apply VolumeSnapshot CRDs
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/${SNAPSHOTTER_VERSION}/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/${SNAPSHOTTER_VERSION}/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/${SNAPSHOTTER_VERSION}/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml

# Create snapshot controller
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/${SNAPSHOTTER_VERSION}/deploy/kubernetes/snapshot-controller/rbac-snapshot-controller.yaml
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/${SNAPSHOTTER_VERSION}/deploy/kubernetes/snapshot-controller/setup-snapshot-controller.yaml
```

# Установка CSI Host Path Driver
На машинке, с которой есть доступ к кластеру выполняем (кажется установочный скрипт включает в себя установку CDRs, но документация противоречива): 
```
git clone https://github.com/kubernetes-csi/csi-driver-host-path.git
./csi-driver-host-path/deploy/kubernetes-1.17/deploy.sh
```

# Тестируем создание и восстановление снепшотов.
https://www.velotio.com/engineering-blog/kubernetes-csi-in-action-explained-with-features-and-use-cases
  - Создаем StorageClass
```
kubectl apply -f ./kubernetes-storage/hw/storageClass.yaml
```
  - Создаем PersistentVolumeClaim (в результате создастся PersistentVolume)
```
kubectl apply -f ./kubernetes-storage/hw/persistentVolumeClaim.yaml
```
  - Создаем Pod
```
kubectl apply -f ./kubernetes-storage/hw/po.yaml
```
  - Запишем в PersistentVolume какие-нибудь данные и поглядим на то что там записано:
```
kubectl exec -it storage-pod -- /bin/sh -c 'echo `date` > /data/date.txt'
kubectl exec -it storage-pod -- cat /data/date.txt
```
  - Создаем VolumeSnapshot
```
kubectl apply -f ./kubernetes-storage/hw/volumeSnapshot.yaml
```
  - Удаляем Pod и PersistentVolumeClaim (в результате удалится и PersistentVolume)
```
kubectl delete pod storage-pod 
kubectl delete pvc storage-pvc
```
  - Восстанвливаем PersistentVolume с помощью PersistentVolumeClaim, снова создаем Pod и проверяем, что данные на месте:
```
kubectl apply -f ./kubernetes-storage/hw/restore_pvc.yaml 
kubectl apply -f ./kubernetes-storage/hw/po.yaml 
kubectl exec -it storage-pod -- cat /data/date.txt
```