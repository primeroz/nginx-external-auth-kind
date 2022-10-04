include ../env.$(ENVIRONMENT).mk
include ../common.mk

export KIND_CONFIG_FILE_NAME=kind.config.yaml

## Create file definition for the kind cluster
define get_kind_config_file
# Define config file
cat << EOF > ${KIND_CONFIG_FILE_NAME}
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  apiServerAddress: "0.0.0.0"
  apiServerPort: 6443
nodes:
# the control plane node config
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
        # authorization-mode: "AlwaysAllow"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
# the workers
- role: worker
EOF
endef

export KIND_CLUSTER_FILE_CREATOR = $(value get_kind_config_file)

.PHONY: create-kind-config-file
create-kind-config-file:; @ eval "$$KIND_CLUSTER_FILE_CREATOR"

.PHONY: deploy
deploy: create-kind-config-file
	kind create cluster --name ${CLUSTER_NAME} --config=${KIND_CONFIG_FILE_NAME} --image=kindest/node:v1.23.12 --wait=120s
	# Remove config file
	@rm -f ${KIND_CONFIG_FILE_NAME}

.PHONY: delete
delete:
	kind delete cluster --name ${CLUSTER_NAME}
	@docker system prune -f

.PHONY: display
display:
	kubectl --context ${KCTX} cluster-info --context kind-${CLUSTER_NAME}
