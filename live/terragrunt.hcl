remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = "eks-terragrunt-recipes-il-central-1"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "il-central-1"
    encrypt        = true
    dynamodb_table = "eks-terragrunt-recipes-lock-table"
  }
}