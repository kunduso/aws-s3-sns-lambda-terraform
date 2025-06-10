# https://registry.terraform.io/language/values/variables
variable "region" {
  description = "Infrastructure region"
  type        = string
  default     = "us-east-2"
}
#application name
variable "name" {
  description = "The name of the application."
  type        = string
  default     = "app-13"
}
variable "log_group_prefix" {
  description = "The name of the log group."
  type        = string
  default     = "/aws/lambda/"
}
variable "log_retention_days" {
  description = "Number of days to retain Lambda logs"
  type        = number
  default     = 365
}