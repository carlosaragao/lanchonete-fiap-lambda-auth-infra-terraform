variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_access_key_id" {
  description = "AWS Access Key ID"
  type        = string
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key"
  type        = string
}

variable "aws_session_token" {
  description = "AWS Session Token"
  type        = string
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "cognito_domain_name" {
  description = "AWS Cognito Domain Name"
  type        = string
}

variable "cognito_client_name" {
  description = "AWS Cognito Client Name"
  type        = string
}

variable "cognito_user_pool_name" {
  description = "AWS Cognito User Pool Name"
  type        = string
}

variable "api_gateway_name" {
  description = "AWS API Gateway Name"
  type        = string
}

variable "cognito_url_callback" {
  description = "AWS Cognito URL Callback"
  type        = string
}

variable "cognito_url_logout" {
  description = "AWS Cognito URL Logout"
  type        = string
}
