# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function
resource "aws_lambda_function" "lambda" {
  function_name    = "${var.name}-lambda"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  timeout          = 30
  memory_size      = 128
  kms_key_arn      = aws_kms_key.lambda_key.arn

  logging_config {
    log_format = "JSON"
    log_group  = aws_cloudwatch_log_group.lambda_log.name
  }

  tracing_config {
    mode = "Active"
  }

  environment {
    variables = {
      LOG_LEVEL = "INFO"
    }
  }
  #checkov:skip=CKV_AWS_117: Lambda function is not configured inside a VPC - not required for this simple use case
#checkov:skip=CKV_AWS_116: Dead Letter Queue not required for this simple notification processing function
#checkov:skip=CKV_AWS_272: Code signing not required for this simple function
#checkov:skip=CKV_AWS_115: Concurrent execution limit not required for this simple function
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/archive_file
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda_function.zip"
  source {
    content  = file("${path.module}/lambda_function.py")
    filename = "lambda_function.py"
  }
}