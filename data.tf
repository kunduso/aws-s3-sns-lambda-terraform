# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region
data "aws_region" "current" {}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity
data "aws_caller_identity" "current" {}

locals {
  principal_root_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
}