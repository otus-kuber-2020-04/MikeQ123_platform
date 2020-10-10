# Ссылка на репозиторий
https://gitlab.com/mike.obninsk/microservices-demo

# Строки логе helm-operator, указывающие на обновление helm-релиза
```
ts=2020-10-10T20:26:45.719441108Z caller=logwriter.go:28 component=helm version=v3 info="...Successfully got an update from the \"stable\" chart repository"
ts=2020-10-10T20:26:45.719537322Z caller=logwriter.go:28 component=helm version=v3 info="Update Complete. ⎈Happy Helming!⎈"
ts=2020-10-10T20:26:47.873672606Z caller=release.go:79 component=release release=frontend targetNamespace=microservices-demo resource=microservices-demo:helmrelease/frontend helmVersion=v3 info="starting sync run"
ts=2020-10-10T20:26:48.431704498Z caller=release.go:353 component=release release=frontend targetNamespace=microservices-demo resource=microservices-demo:helmrelease/frontend helmVersion=v3 info="running upgrade" action=upgrade
ts=2020-10-10T20:26:48.463727106Z caller=helm.go:69 component=helm version=v3 info="preparing upgrade for frontend" targetNamespace=microservices-demo release=frontend
ts=2020-10-10T20:26:48.468503918Z caller=helm.go:69 component=helm version=v3 info="resetting values to the chart's original version" targetNamespace=microservices-demo release=frontend
ts=2020-10-10T20:26:49.06339873Z caller=helm.go:69 component=helm version=v3 info="performing update for frontend" targetNamespace=microservices-demo release=frontend
ts=2020-10-10T20:26:49.169516406Z caller=helm.go:69 component=helm version=v3 info="creating upgraded release for frontend" targetNamespace=microservices-demo release=frontend
ts=2020-10-10T20:26:49.195741762Z caller=helm.go:69 component=helm version=v3 info="checking 6 resources for changes" targetNamespace=microservices-demo release=frontend
ts=2020-10-10T20:26:49.261050188Z caller=helm.go:69 component=helm version=v3 info="Looks like there are no changes for Canary \"frontend\"" targetNamespace=microservices-demo release=frontend
ts=2020-10-10T20:26:49.287133556Z caller=helm.go:69 component=helm version=v3 info="Looks like there are no changes for Gateway \"frontend\"" targetNamespace=microservices-demo release=frontend
ts=2020-10-10T20:26:49.302633595Z caller=helm.go:69 component=helm version=v3 info="Looks like there are no changes for ServiceMonitor \"frontend\"" targetNamespace=microservices-demo release=frontend
ts=2020-10-10T20:26:49.32673941Z caller=helm.go:69 component=helm version=v3 info="Looks like there are no changes for VirtualService \"frontend\"" targetNamespace=microservices-demo release=frontend
ts=2020-10-10T20:26:49.342003823Z caller=helm.go:69 component=helm version=v3 info="updating status for upgraded release for frontend" targetNamespace=microservices-demo release=frontend
ts=2020-10-10T20:26:49.387768702Z caller=release.go:364 component=release release=frontend targetNamespace=microservices-demo resource=microservices-demo:helmrelease/frontend helmVersion=v3 info="upgrade succeeded" revision=a8577abe53df355e78908a87b5bc490936d17299 phase=upgrade
```

# Canaries
```
$ kubectl get canaries -n microservices-demo 
NAME       STATUS      WEIGHT   LASTTRANSITIONTIME
frontend   Succeeded   0        2020-10-10T20:33:38Z
```

```
$ kubectl describe canaries -n microservices-demo frontend 
Name:         frontend
Namespace:    microservices-demo
Labels:       <none>
Annotations:  helm.fluxcd.io/antecedent: microservices-demo:helmrelease/frontend
API Version:  flagger.app/v1beta1
Kind:         Canary
Metadata:
  Creation Timestamp:  2020-10-10T13:54:36Z
  Generation:          1
  Resource Version:    510960
  Self Link:           /apis/flagger.app/v1beta1/namespaces/microservices-demo/canaries/frontend
  UID:                 d1994894-6673-4d00-a409-a27a1c7ebbd0
Spec:
  Analysis:
    Interval:    1m
    Max Weight:  30
    Metrics:
      Interval:               1m
      Name:                   istio_requests_total
      Threshold:              99
    Step Weight:              10
    Threshold:                1
  Progress Deadline Seconds:  60
  Provider:                   istio
  Service:
    Gateways:
      frontend
    Hosts:
      *
    Port:  80
    Retries:
      Attempts:         3
      Per Try Timeout:  1s
      Retry On:         gateway-error,connect-failure,refused-stream
    Target Port:        8080
    Traffic Policy:
      Tls:
        Mode:  DISABLE
  Target Ref:
    API Version:  apps/v1
    Kind:         Deployment
    Name:         frontend
Status:
  Canary Weight:  0
  Conditions:
    Last Transition Time:  2020-10-10T20:33:38Z
    Last Update Time:      2020-10-10T20:33:38Z
    Message:               Canary analysis completed successfully, promotion finished.
    Reason:                Succeeded
    Status:                True
    Type:                  Promoted
  Failed Checks:           0
  Iterations:              0
  Last Applied Spec:       6796bdcfcd
  Last Promoted Spec:      6796bdcfcd
  Last Transition Time:    2020-10-10T20:33:38Z
  Phase:                   Succeeded
  Tracked Configs:
Events:
  Type    Reason  Age                    From     Message
  ----    ------  ----                   ----     -------
  Normal  Synced  9m32s (x3 over 6h39m)  flagger  New revision detected! Scaling up frontend.microservices-demo
  Normal  Synced  8m32s (x3 over 6h38m)  flagger  Starting canary analysis for frontend.microservices-demo
  Normal  Synced  8m32s (x3 over 6h38m)  flagger  Advance frontend.microservices-demo canary weight 10
  Normal  Synced  7m32s (x3 over 6h37m)  flagger  Advance frontend.microservices-demo canary weight 20
  Normal  Synced  6m32s (x3 over 6h36m)  flagger  Advance frontend.microservices-demo canary weight 30
  Normal  Synced  5m32s (x3 over 6h35m)  flagger  Copying frontend.microservices-demo template spec to frontend-primary.microservices-demo
  Normal  Synced  4m32s (x3 over 6h34m)  flagger  Routing all traffic to primary
  Normal  Synced  3m32s (x2 over 11m)    flagger  Promotion completed! Scaling down frontend.microservices-demo
```


