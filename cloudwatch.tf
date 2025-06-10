#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group
resource "aws_cloudwatch_log_group" "lambda_log" {
  name              = "${var.log_group_prefix}${var.name}"
  retention_in_days = var.log_retention_days
  kms_key_id        = aws_kms_key.encrypt_cloudwatch.arn
  depends_on        = [aws_kms_key_policy.encrypt_cloudwatch]
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key
resource "aws_kms_key" "encrypt_cloudwatch" {
  enable_key_rotation     = true
  description             = "Key to encrypt all the lambda cloudwatch logs for ${var.name}."
  deletion_window_in_days = 7
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias
resource "aws_kms_alias" "encrypt_cloudwatch" {
  name          = "alias/${var.name}-encrypt-cloudwatch-logs"
  target_key_id = aws_kms_key.encrypt_cloudwatch.key_id
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "encrypt_cloudwatch" {
  statement {
    sid       = "Enable IAM User Permissions"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["arn:aws:kms:${var.region}:${data.aws_caller_identity.current.account_id}:key/*"]
    principals {
      type        = "AWS"
      identifiers = [local.principal_root_arn]
    }
  }

  statement {
    sid    = "Allow CloudWatch Logs to use the key"
    effect = "Allow"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt",
      "kms:GenerateDataKey*",
      "kms:CreateGrant",
      "kms:ReEncrypt*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = [local.principal_logs_arn]
    }
    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = [local.cloudwatch_log_group_arn]
    }
  }
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy
resource "aws_kms_key_policy" "encrypt_cloudwatch" {
  key_id = aws_kms_key.encrypt_cloudwatch.id
  policy = data.aws_iam_policy_document.encrypt_cloudwatch.json
}