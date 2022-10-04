{
  _config+:: {
    name: 'external-auth',
    namespace: 'external-auth',
    image: 'primeroz/simple-ingress-external-auth:v0.3.0-amd64',
    logLevel: 'info',
    md5Config: true,
    enableSidecarContainer: false,
    configuration: {
      version: 'v1',
      // openssl rand -base64 32
      tokens: [
        {
          value: 'EjtRC2A+jbXWjuerytkM1mLTBFwx6XBpVKtD32qdNzs=',
          client_id: 'client1',
        },
        {
          value: 'gKCnEPWa8Ez3/nCSD/0i/4t5F8RNVhFG71u0W5K2eUc=',
          client_id: 'client2',
        },
      ],
    },
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
      name: $._config.name,
      namespace: $._config.namespace,
      labels: {
        app: $._config.name,
      },
    },
    spec: {
      replicas: 2,
      minReadySeconds: 60,
      selector: {
        matchLabels: {
          app: $._config.name,
        },
      },
      template: {
        metadata: {
          labels: {
            app: $._config.name,
          },
          annotations: {
            [if $._config.md5Config then 'config/checksum']: std.md5(std.toString($._config)),
          },
        },
        spec: {
          nodeSelector: {
            'kubernetes.io/arch': 'amd64',
            'kubernetes.io/os': 'linux',
          },
          containers: [
                        {
                          name: $._config.name,
                          image: $._config.image,
                          //securityContext: {
                          //  runAsUser: 1111,
                          //},
                          volumeMounts: [
                            {
                              readOnly: true,
                              mountPath: '/config',
                              name: 'external-auth-config',
                            },
                          ],
                          args: [
                                  '--token-config-file=/config/tokens.yaml',
                                  '--client-id-header=X-Scope-OrgId',
                                  '--authentication-path=/',
                                ] +
                                (if $._config.logLevel == 'debug' then ['--debug'] else []),
                          livenessProbe: {
                            httpGet: {
                              path: '/status',
                              scheme: 'HTTP',
                              port: 8081,
                            },
                            initialDelaySeconds: 5,
                            periodSeconds: 5,
                          },
                          readinessProbe: {
                            httpGet: {
                              path: '/status',
                              scheme: 'HTTP',
                              port: 8081,
                            },
                            initialDelaySeconds: 5,
                            periodSeconds: 5,
                          },
                        },
                      ] +
                      (if $._config.enableSidecarContainer then
                         [{
                           name: 'debug',
                           image: 'nixery.dev/shell/curl/unixtools.netstat/unixtools.procps',
                           command: ['sleep', '360000'],
                         }]
                       else []),
          volumes: [
            {
              name: 'external-auth-config',
              configMap: {
                name: 'external-auth-config',
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
      name: 'external-auth-config',
      namespace: $._config.namespace,
    },
    data: {
      'tokens.yaml': std.native('manifestYaml')($._config.configuration),
    },
  },

  service: {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      name: $._config.name,
      namespace: $._config.namespace,
      labels: {
        app: $._config.name,
      },
    },
    spec: {
      ports: [
        {
          port: 8080,
          protocol: 'TCP',
          targetPort: 8080,
        },
      ],
      selector: {
        app: $._config.name,
      },
    },
  },
}
