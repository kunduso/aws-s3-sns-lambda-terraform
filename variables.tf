#Define AWS Region
variable "region" {
  description = "Infrastructure region"
  type        = string
  default     = "us-east-2"
}
variable "name" {
  description = "The name of the application."
  type        = string
  default     = "app-13"
}