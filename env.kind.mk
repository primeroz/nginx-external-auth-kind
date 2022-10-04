# Safety net, make sure we are using the correct kubectl context before
# deploying anything
KUBE_CONTEXT ?= kind-nginx-extauth
CLUSTER_NAME ?= nginx-extauth

# Azure Keyvault name where secrets are stored (ie: cloudflare password)
#AZURE_KEY_VAULT_NAME ?= my-infra

# Applications to deploy, order is important
APPS = \
	nginx-ingress \
	podinfo \
  external-auth

# Ref: https://github.com/helm/charts/tree/master/stable/nginx-ingress
NGINX_INGRESS_CHART_VERSION = 4.3.0
