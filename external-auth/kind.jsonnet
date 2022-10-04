local externalAuth = import 'external-auth.libsonnet';

local config = {
  logLevel: 'debug',
  enableSidecarContainer: true,
};

externalAuth {
  _config+:: config,
}
