locals {
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))

  aws_region = local.region_vars.locals.provider_region
  project  = local.project_vars.locals.project
  module  = "${basename(get_terragrunt_dir())}"

  base_source_ref = run_cmd("git", "rev-parse", "--abbrev-ref", "HEAD")
  base_source_url = "git::git@github.com:ElDiabloRojo/repo-repo.git//inf/modules/logical/${local.module}?ref=${local.base_source_ref}"
}

terraform {
  source = "${local.base_source_url}"

  extra_arguments "common_var" {
    commands  = get_terraform_commands_that_need_vars()
    arguments = ["-var-file=${dirname(find_in_parent_folders())}/variables/${local.project}/${local.module}/terraform.tfvars"]
  }
}

# Indicate the input values to use for the variables of the module.
inputs = {
}