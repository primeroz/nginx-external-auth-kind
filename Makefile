export CLUSTER_NAME=nginxopa
export KCTX=kind-nginxopa

export KIND_CONFIG_FILE_NAME=kind.config.yaml

## Create file definition for the kind cluster
define get_kind_config_file
# Remove config file
rm -f ${KIND_CONFIG_FILE_NAME}
# Define config file
cat << EOF >> ${KIND_CONFIG_FILE_NAME}
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

WAIT_FOR_KIND_READY = '{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}'
WAIT_FOR_OPA_READY = '{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}'

.PHONY: all create-kind-config-file create-kind delete-kind display-kind

create-kind-config-file:; @ eval "$$KIND_CLUSTER_FILE_CREATOR"

create-kind: create-kind-config-file
	kind create cluster --name ${CLUSTER_NAME} --config=${KIND_CONFIG_FILE_NAME} --image=kindest/node:v1.23.12 --wait=120s
	# Remove config file
	@rm -f ${KIND_CONFIG_FILE_NAME}

delete-kind:
	@kind delete cluster --name ${CLUSTER_NAME}
	@docker system prune -f

display-kind:
	kubectl --context ${KCTX} cluster-info --context kind-${CLUSTER_NAME}

#all: test kind-integration



