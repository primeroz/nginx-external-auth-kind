local opa = import 'opa.libsonnet';

local config = {

};

opa {
  _config+:: config,
}
