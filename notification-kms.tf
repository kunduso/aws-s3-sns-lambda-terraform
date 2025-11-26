# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key
resource "aws_kms_key" "sns_key" {
  description             = "KMS key for SNS topic encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias
resource "aws_kms_alias" "sns_key_alias" {
  name          = "alias/${var.name}-sns-key"
  target_key_id = aws_kms_key.sns_key.key_id
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy
resource "aws_kms_key_policy" "sns_key" {
  key_id = aws_kms_key.sns_key.id
  policy = data.aws_iam_policy_document.sns_key_policy.json
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "sns_key_policy" {
  statement {
    sid    = "Allow SNS to use the key"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [aws_kms_key.sns_key.arn]
    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
  }

  statement {
    sid    = "Allow S3 to use the key for SNS"
    effect = "Allow"
    actions = [
      "kms:GenerateDataKey*",
      "kms:Decrypt"
    ]
    resources = [aws_kms_key.sns_key.arn]
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
    resources = [aws_kms_key.sns_key.arn]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.lambda_role.arn]
    }
  }
}