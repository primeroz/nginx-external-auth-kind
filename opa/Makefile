include ../env.$(ENVIRONMENT).mk
include ../common.mk

.PHONY: deploy
deploy:
	@kubecfg update $(ENVIRONMENT).jsonnet

.PHONY: display
display: 
	@echo ""
	@echo ""
	@echo "OPA"
	@echo ""
