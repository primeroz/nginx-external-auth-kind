include ../env.$(ENVIRONMENT).mk
include ../common.mk

.PHONY: deploy
deploy:
	@kubecfg update $(ENVIRONMENT).jsonnet
	@kubectl rollout status -n external-auth deployment external-auth
