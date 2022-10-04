local opa = import 'opa.libsonnet';

local config = {
  logLevel: 'debug',
};

opa {
  _config+:: config,
}
