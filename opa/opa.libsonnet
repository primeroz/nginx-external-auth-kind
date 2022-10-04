{
  _config+:: {
    namespace: 'opa-ext-auth',
    configuration: {
      plugins: {
        // envoy_ext_authz_grpc: {
        //   addr: ':9191',
        //   path: 'envoy/authz/allow',
        // },
        decision_logs: {
          console: true,
        },
      },
    },
    policy: |||
      package envoy.authz

      import input.attributes.request.http as http_request

      default allow = false
    |||,
  },

  namespace: {
    apiVersion: 'v1',
    kind: 'Namespace',
    metadata: {
      name: $._config.namespace,
    },
  },

  deployment: {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: 'opa',
      namespace: $._config.namespace,
      labels: {
        app: 'opa',
      },
    },
    spec: {
      replicas: 2,
      selector: {
        matchLabels: {
          app: 'opa',
        },
      },
      template: {
        metadata: {
          labels: {
            app: 'opa',
          },
        },
        spec: {
          nodeSelector: {
            'kubernetes.io/arch': 'amd64',
            'kubernetes.io/os': 'linux',
          },
          containers: [
            {
              name: 'opa-envoy',
              image: 'openpolicyagent/opa:0.44.0-envoy',
              securityContext: {
                runAsUser: 1111,
              },
              volumeMounts: [
                {
                  readOnly: true,
                  mountPath: '/policy',
                  name: 'opa-policy',
                },
                {
                  readOnly: true,
                  mountPath: '/config',
                  name: 'opa-envoy-config',
                },
              ],
              args: [
                'run',
                '--server',
                '--config-file=/config/config.yaml',
                '--addr=0.0.0.0:8181',
                '--diagnostic-addr=0.0.0.0:8282',
                '--ignore=.*',
                '/policy/policy.rego',
              ],
              livenessProbe: {
                httpGet: {
                  path: '/health?plugins',
                  scheme: 'HTTP',
                  port: 8282,
                },
                initialDelaySeconds: 5,
                periodSeconds: 5,
              },
              readinessProbe: {
                httpGet: {
                  path: '/health?plugins',
                  scheme: 'HTTP',
                  port: 8282,
                },
                initialDelaySeconds: 5,
                periodSeconds: 5,
              },
            },
          ],
          volumes: [
            {
              name: 'proxy-config',
              configMap: {
                name: 'proxy-config',
              },
            },
            {
              name: 'opa-policy',
              configMap: {
                name: 'opa-policy',
              },
            },
            {
              name: 'opa-envoy-config',
              configMap: {
                name: 'opa-envoy-config',
              },
            },
          ],
        },
      },
    },
  },

  opaConfigMap: {
    apiVersion: 'v1',
    kind: 'ConfigMap',
    metadata: {
      name: 'opa-envoy-config',
      namespace: $._config.namespace,
    },
    data: {
      'config.yaml': std.native('manifestYaml')($._config.configuration),
    },
  },

  service: {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      name: 'opa',
      namespace: $._config.namespace,
      labels: {
        app: 'opa',
      },
    },
    spec: {
      ports: [
        {
          port: 8181,
          protocol: 'TCP',
          targetPort: 8181,
        },
      ],
      selector: {
        app: 'opa',
      },
    },
  },

  policyConfigMap: {
    apiVersion: 'v1',
    kind: 'ConfigMap',
    metadata: {
      name: 'opa-policy',
      namespace: $._config.namespace,
    },
    data: {
      'policy.rego': $._config.policy,
    },
  },
}
