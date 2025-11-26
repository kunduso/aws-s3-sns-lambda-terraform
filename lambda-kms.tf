# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key
resource "aws_kms_key" "lambda_key" {
  description             = "KMS key for Lambda environment variables"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy
resource "aws_kms_key_policy" "lambda_key" {
  key_id = aws_kms_key.lambda_key.id
  policy = data.aws_iam_policy_document.lambda_key_policy.json
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias
resource "aws_kms_alias" "lambda_key_alias" {
  name          = "alias/${var.name}-lambda-key"
  target_key_id = aws_kms_key.lambda_key.key_id
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "lambda_key_policy" {
  statement {
    sid    = "Allow Lambda to use the key"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [aws_kms_key.lambda_key.arn]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }

  statement {
    sid    = "Allow use of the key by Lambda role"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey"
    ]
    resources = [aws_kms_key.lambda_key.arn]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.lambda_role.arn]
    }
  }
}