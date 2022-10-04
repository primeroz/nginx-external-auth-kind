include ../env.$(ENVIRONMENT).mk
include ../common.mk

.PHONY: deploy
deploy:
	@helm repo add podinfo https://stefanprodan.github.io/podinfo
	@helm repo update > /dev/null
	@kubectl create namespace podinfo || true
	helm upgrade \
		--namespace podinfo \
		-i frontend \
		-f ./values.common.yaml \
		-f ./values.frontend.yaml \
		--wait \
		podinfo/podinfo
	helm upgrade \
		--namespace podinfo \
		-i backend \
		-f ./values.common.yaml \
		-f ./values.backend.yaml \
		--wait \
		podinfo/podinfo

.PHONY: display
display: 
	@echo ""
	@echo ""
	@echo "To Access PODINFO use something like 'curl -H "Host: podinfo.local" http://172.20.0.2:32080'"
	@echo ""
