# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region
data "aws_region" "current" {}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity
data "aws_caller_identity" "current" {}

locals {
  principal_root_arn       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  principal_logs_arn       = "logs.${data.aws_region.current.id}.amazonaws.com"
  cloudwatch_log_group_arn = "arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:log-group:${var.log_group_prefix}${var.name}*"
}