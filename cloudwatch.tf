# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group
resource "aws_cloudwatch_log_group" "lambda_log" {
  name              = "/aws/lambda/${var.name}-lambda"
  retention_in_days = 14
  kms_key_id        = aws_kms_key.lambda_key.arn
}