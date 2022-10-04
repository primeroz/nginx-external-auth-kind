include ../env.$(ENVIRONMENT).mk
include ../common.mk

.PHONY: deploy
deploy:
	@kubecfg update $(ENVIRONMENT).jsonnet
	@kubectl rollout status -n opa-ext-auth deployment opa

.PHONY: display
display: 
	@echo ""
	@echo ""
	@echo "OPA"
	@echo ""
