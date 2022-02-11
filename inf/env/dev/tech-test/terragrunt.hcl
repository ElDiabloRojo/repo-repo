locals {
  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))

  project  = local.project_vars.locals.project
  module  = "${basename(get_terragrunt_dir())}"
}

include "root" {
  path = find_in_parent_folders()
}

include "module" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/env_module_spec.hcl"
}

inputs = {
  project_name = "${local.project}-${local.module}"
}