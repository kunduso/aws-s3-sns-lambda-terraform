[![License: Unlicense](https://img.shields.io/badge/license-Unlicense-white.svg)](https://choosealicense.com/licenses/unlicense/) [![GitHub pull-requests closed](https://img.shields.io/github/issues-pr-closed/kunduso/aws-s3-sns-lambda-terraform)](https://github.com/kunduso/aws-s3-sns-lambda-terraform/pulls?q=is%3Apr+is%3Aclosed) [![GitHub pull-requests](https://img.shields.io/github/issues-pr/kunduso/aws-s3-sns-lambda-terraform)](https://GitHub.com/kunduso/aws-s3-sns-lambda-terraform/pull/) 
[![GitHub issues-closed](https://img.shields.io/github/issues-closed/kunduso/aws-s3-sns-lambda-terraform)](https://github.com/kunduso/aws-s3-sns-lambda-terraform/issues?q=is%3Aissue+is%3Aclosed) [![GitHub issues](https://img.shields.io/github/issues/kunduso/aws-s3-sns-lambda-terraform)](https://GitHub.com/kunduso/aws-s3-sns-lambda-terraform/issues/) 
[![terraform-infra-provisioning](https://github.com/kunduso/aws-s3-sns-lambda-terraform/actions/workflows/terraform.yml/badge.svg?branch=main)](https://github.com/kunduso/aws-s3-sns-lambda-terraform/actions/workflows/terraform.yml) [![checkov-scan](https://github.com/kunduso/aws-s3-sns-lambda-terraform/actions/workflows/code-scan.yml/badge.svg?branch=main)](https://github.com/kunduso/aws-s3-sns-lambda-terraform/actions/workflows/code-scan.yml)
# AWS S3-SNS-Lambda Terraform Project

This project sets up a serverless architecture using Terraform with the following components:

1. An S3 bucket that triggers events when files are uploaded
2. An SNS topic that receives these events
3. A Lambda function (in Python) that processes the notifications and logs the file name to CloudWatch

## Architecture

```
File Upload → S3 Bucket → SNS Topic → Lambda Function → CloudWatch Logs
```

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform installed (v1.0.0+)

## Deployment

1. Initialize Terraform:
   ```
   terraform init
   ```

2. Review the plan:
   ```
   terraform plan
   ```

3. Apply the configuration:
   ```
   terraform apply
   ```

## Testing

1. Upload a file to the created S3 bucket
2. Check CloudWatch Logs for the Lambda function to see the logged file name

## Cleanup

To remove all resources:
```
terraform destroy
```