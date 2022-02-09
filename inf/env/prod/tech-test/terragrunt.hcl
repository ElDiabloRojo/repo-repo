# backend
include "root" {
  path = find_in_parent_folders()
}

include "module" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/env_module_spec.hcl"
}