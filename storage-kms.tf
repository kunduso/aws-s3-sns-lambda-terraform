# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key
resource "aws_kms_key" "s3_key" {
  description             = "KMS key for S3 bucket encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias
resource "aws_kms_alias" "s3_key_alias" {
  name          = "alias/${var.name}-s3-key"
  target_key_id = aws_kms_key.s3_key.key_id
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy
resource "aws_kms_key_policy" "s3_key" {
  key_id = aws_kms_key.s3_key.id
  policy = data.aws_iam_policy_document.s3_key_policy.json
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "s3_key_policy" {
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
      "kms:Create*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
      "kms:TagResource",
      "kms:UntagResource"
    ]
    resources = [aws_kms_key.s3_key.arn]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    sid    = "Allow S3 to use the key"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [aws_kms_key.s3_key.arn]
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }

  statement {
    sid    = "Allow Lambda to decrypt"
    effect = "Allow"
    actions = [
      "kms:Decrypt"
    ]
    resources = [aws_kms_key.s3_key.arn]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.lambda_role.arn]
    }
  }
}