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

