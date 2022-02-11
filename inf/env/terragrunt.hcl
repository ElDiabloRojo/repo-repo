locals {
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))

  aws_region = local.region_vars.locals.provider_region
  project  = local.project_vars.locals.project
  module  = "${basename(get_terragrunt_dir())}"
}

inputs = {
}

# stage/terragrunt.hcl
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = "cg-${local.project}-terraform-state"
    key            = "${path_relative_to_include()}.tfstate"
    region         = "${local.aws_region}"
    encrypt        = true
    dynamodb_table = "terraform_locks"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  max_retries = "10"
  region      = "${local.aws_region}"
}
EOF
}