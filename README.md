# nginx-external-auth
testing Nginx with external-auth using https://github.com/primeroz/simple-ingress-external-auth 

# Requirements

* kind 0.16.0 +
* helm 3
* kubecfg 0.27.0 +

#

* make kind-create
* make deploy-all
* grab host ip for a node `DESTINATION=$(kubectl get node nginx-extauth-worker -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')`
* curl podinfo with token and check headers returned 
* `curl -v -H "host: podinfo.local" -H "X-Scope-OrgId: foo" -H "Authorization: Bearer EjtRC2A+jbXWjuerytkM1mLTBFwx6XBpVKtD32qdNzs=" http://$DESTINATION:32080/headers | jq '."X-Scope-Orgid"'`

---
`curl -v -H "host: podinfo.local" -H "X-Scope-OrgId: foo" -H "Authorization: Bearer EjtRC2A+jbXWjuerytkM1mLTBFwx6XBpVKtD32qdNzs=" http://$DESTINATION:32080/headers`

```
> GET /headers HTTP/1.1
> Host: podinfo.local
> User-Agent: curl/7.85.0
> Accept: */*
> X-Scope-OrgId: foo
> Authorization: Bearer EjtRC2A+jbXWjuerytkM1mLTBFwx6XBpVKtD32qdNzs=
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Date: Tue, 04 Oct 2022 18:02:03 GMT
< Content-Type: application/json; charset=utf-8
< Content-Length: 658
< Connection: keep-alive
< X-Content-Type-Options: nosniff
< 
{ [658 bytes data]

100   658  100   658    0     0   104k      0 --:--:-- --:--:-- --:--:--  128k
* Connection #0 to host 172.24.0.3 left intact
{
  "Accept": [
    "*/*"
  ],
  "Authorization": [
    "Bearer EjtRC2A+jbXWjuerytkM1mLTBFwx6XBpVKtD32qdNzs="
  ],
  "User-Agent": [
    "curl/7.85.0"
  ],
  "X-Api-Revision": [
    "44157ecd84c0d78b17e4d7b43f2a7bb316372d6c"
  ],
  "X-Api-Version": [
    "6.2.1"
  ],
  "X-Forwarded-For": [
    "10.244.1.1"
  ],
  "X-Forwarded-Host": [
    "podinfo.local"
  ],
  "X-Forwarded-Port": [
    "80"
  ],
  "X-Forwarded-Proto": [
    "http"
  ],
  "X-Forwarded-Scheme": [
    "http"
  ],
  "X-Real-Ip": [
    "10.244.1.1"
  ],
  "X-Request-Id": [
    "e66f5adc2e21e5bbfe2117d28e7917ef"
  ],
  "X-Scheme": [
    "http"
  ],
  "X-Scope-Orgid": [
    "client1"
  ]
}
```
