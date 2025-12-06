[![License: Unlicense](https://img.shields.io/badge/license-Unlicense-white.svg)](https://choosealicense.com/licenses/unlicense/) [![GitHub pull-requests closed](https://img.shields.io/github/issues-pr-closed/kunduso/aws-s3-sns-lambda-terraform)](https://github.com/kunduso/aws-s3-sns-lambda-terraform/pulls?q=is%3Apr+is%3Aclosed) [![GitHub pull-requests](https://img.shields.io/github/issues-pr/kunduso/aws-s3-sns-lambda-terraform)](https://GitHub.com/kunduso/aws-s3-sns-lambda-terraform/pull/) 
[![GitHub issues-closed](https://img.shields.io/github/issues-closed/kunduso/aws-s3-sns-lambda-terraform)](https://github.com/kunduso/aws-s3-sns-lambda-terraform/issues?q=is%3Aissue+is%3Aclosed) [![GitHub issues](https://img.shields.io/github/issues/kunduso/aws-s3-sns-lambda-terraform)](https://GitHub.com/kunduso/aws-s3-sns-lambda-terraform/issues/) 
[![terraform-infra-provisioning](https://github.com/kunduso/aws-s3-sns-lambda-terraform/actions/workflows/terraform.yml/badge.svg)](https://github.com/kunduso/aws-s3-sns-lambda-terraform/actions/workflows/terraform.yml) [![checkov-scan](https://github.com/kunduso/aws-s3-sns-lambda-terraform/actions/workflows/code-scan.yml/badge.svg)](https://github.com/kunduso/aws-s3-sns-lambda-terraform/actions/workflows/code-scan.yml)

![Image](https://skdevops.wordpress.com/wp-content/uploads/2025/11/image-1-1.png)

## Introduction
This repository demonstrates how to build a serverless event-driven architecture using Amazon S3, SNS, Lambda, and CloudWatch with Terraform and GitHub Actions. The solution creates an automated file processing pipeline that triggers Lambda functions when files are uploaded to S3, providing real-time processing capabilities without polling mechanisms.

The architecture implements enterprise-grade security with customer-managed KMS encryption for all services, comprehensive monitoring through CloudWatch, and automated deployment via GitHub Actions with OpenID Connect (OIDC) integration.

For detailed implementation guidance, please visit - [Amazon S3-SNS-Lambda Event-Driven Architecture with Terraform](https://skundunotes.com/2025/12/05/amazon-s3-sns-lambda-event-driven-architecture-with-terraform/).

## Architecture Overview
![Architecture Diagram](https://skdevops.wordpress.com/wp-content/uploads/2025/12/122-image-1.png)

The event-driven workflow follows this sequence:
1. File uploaded to an Amazon S3 bucket triggers an event notification
2. Amazon SNS receives the notification with file metadata and event details
3. An AWS Lambda function processes the event payload and extracts file information
4. Amazon CloudWatch log captures structured logs for monitoring and troubleshooting

The solution creates 27 AWS resources with zero security violations and includes:

1. **AWS KMS Encryption Setup**: Separate customer-managed encryption keys for S3, SNS, Lambda, and CloudWatch with automatic rotation enabled
2. **Amazon S3 Configuration**: Secure bucket with server-side encryption, versioning, and event notifications
3. **Amazon SNS Integration**: Encrypted topic for reliable message delivery between S3 and Lambda
4. **AWS Lambda Processing**: Serverless function with Python 3.12 runtime, structured logging, and X-Ray tracing
5. **Amazon CloudWatch Monitoring**: Encrypted log groups with 365-day retention for comprehensive audit trails
6. **GitHub Actions Automation**: Secure CI/CD pipeline using OIDC for credential management

## Key Features
- **Security-First Approach**: End-to-end encryption using separate KMS keys for service isolation
- **Serverless Architecture**: Scales automatically with up to 5 concurrent file operations (configurable)
- **Cost Optimization**: Pay-per-use model eliminates continuous polling costs
- **Enterprise Monitoring**: Structured JSON logging and comprehensive CloudWatch metrics
- **Automated Deployment**: GitHub Actions pipeline with Checkov security scanning
- **Zero Security Violations**: Passes all security best practice checks

## Prerequisites
For this code to function without errors, create an OpenID Connect identity provider in Amazon Identity and Access Management that has a trust relationship with this GitHub repository. You can read about it [here](https://skundunotes.com/2023/02/28/securely-integrate-aws-credentials-with-github-actions-using-openid-connect/) to get a detailed explanation with steps.

Store the `ARN` of the `IAM Role` as a GitHub secret which is referenced in the [`terraform.yml`](./.github/workflows/terraform.yml) file.

For Infracost integration in this repository, the `INFRACOST_API_KEY` needs to be stored as a repository secret. It is referenced in the [`terraform.yml`](./.github/workflows/terraform.yml) GitHub actions workflow file.

Additionally, the cost estimate process is managed using a GitHub Actions variable `INFRACOST_SCAN_TYPE` where the value is either `hcl_code` or `tf_plan`, depending on the type of scan desired.

You can read about that at - [integrate-Infracost-with-GitHub-Actions](https://skundunotes.com/2023/07/17/estimate-aws-cloud-resource-cost-with-infracost-terraform-and-github-actions/).

## Supporting References
This repository includes [Infracost](https://www.infracost.io/) integration to generate cost estimates of the architecture. If you want to learn more about adding Infracost estimates to your repository, head over to this note - [estimate AWS Cloud resource cost with Infracost, Terraform, and GitHub Actions](https://skundunotes.com/2023/07/17/estimate-aws-cloud-resource-cost-with-infracost-terraform-and-github-actions/).

The resource provisioning process is automated using GitHub Actions pipeline which is discussed at - [CI-CD with Terraform and GitHub Actions to deploy to AWS](https://skundunotes.com/2023/03/07/ci-cd-with-terraform-and-github-actions-to-deploy-to-aws/).

For security scanning implementation, refer to - [automate Terraform configuration scan with Checkov and GitHub Actions](https://skundunotes.com/2023/04/12/automate-terraform-configuration-scan-with-checkov-and-github-actions/).

## Usage
Ensure that the policy attached to the IAM role whose credentials are being used in this configuration has permission to create and manage all the resources included in this repository, including S3 buckets, SNS topics, Lambda functions, KMS keys, and CloudWatch log groups.

Review the code, including the [`terraform.yml`](./.github/workflows/terraform.yml) to understand the steps in the GitHub Actions pipeline.

### Testing the Event-Driven Pipeline
After deployment, validate the complete workflow:

1. **Upload a test file** to the S3 bucket:
   ```bash
   aws s3 cp test-file.txt s3://your-bucket-name/
   ```

2. **Verify processing** in CloudWatch Logs at `/aws/lambda/your-function-name` for structured JSON log entries

3. **Monitor performance metrics** including execution time (~10ms), memory usage (~37MB), and cold start times (~107ms)

If you want to check the pipeline logs, click on the **Build Badges** above the image in this README.

## Contributing
If you find any issues or have suggestions for improvement, feel free to open an issue or submit a pull request. Contributions are always welcome!

## License
This code is released under the Unlicense License. See [LICENSE](LICENSE).