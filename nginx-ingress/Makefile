include ../env.$(ENVIRONMENT).mk
include ../common.mk

.PHONY: deploy
deploy:
	@helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
	@helm repo update > /dev/null
	@kubectl create namespace ingress || true
	helm upgrade \
		--version $(NGINX_INGRESS_CHART_VERSION) \
		--namespace ingress \
		-i nginx-ingress \
		-f ./values.common.yaml \
		-f ./values.$(ENVIRONMENT).yaml \
		--wait \
		ingress-nginx/ingress-nginx

.PHONY: display
display: 
	@kubectl status -n ingress deployment nginx-ingress-ingress-nginx-controller
	@kubectl status -n ingress deployment nginx-ingress-ingress-nginx-defaultbackend
	@kubectl status -n ingress service nginx-ingress-ingress-nginx-controller

