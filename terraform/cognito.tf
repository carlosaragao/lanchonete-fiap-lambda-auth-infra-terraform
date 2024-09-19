terraform {
  required_version = "1.9.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.63.0"
    }
  }
}

data "aws_iam_role" "cognito_cluster_role" {
  name = "LabRole"
}

provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  token      = var.AWS_SESSION_TOKEN
}

resource "aws_cognito_user_pool" "lanchonete-fiap-user-pool-645215" {
  name = "lanchonete-fiap-user-pool-645215"

  username_attributes = ["email"]
  auto_verified_attributes = ["email"]
  password_policy {
    minimum_length = 8
    require_lowercase = true
    require_uppercase = true
    require_numbers   = true
    require_symbols   = true
  }

  # MFA disabled
  mfa_configuration = "OFF"

  # Recovery message delivery method: Email only
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  # Allow Cognito to automatically send messages to verify and confirm
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }

  # Allow Cognito to send emails
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  # Attributes settings
  schema {
    attribute_data_type = "String"
    name                = "email"
    required            = true
    mutable             = false
  }

  schema {
    attribute_data_type = "Boolean"
    name                = "email_verified"
    required            = true
    mutable             = true
  }

  schema {
    attribute_data_type = "String"
    name                = "name"
    required            = true
    mutable             = false
  }

  schema {
    attribute_data_type = "String"
    name                = "custom:cpf"
    required            = false
    mutable             = false
    string_attribute_constraints {
      min_length = 11
      max_length = 11
    }
  }

}

# Cognito User Pool Domain
resource "aws_cognito_user_pool_domain" "fiap-domain-87564537" {
  domain      = "fiap-domain-87564537"
  user_pool_id = aws_cognito_user_pool.lanchonete-fiap-user-pool-645215.id
}

# Cognito User Pool Client for Hosted UI
resource "aws_cognito_user_pool_client" "fiap-client-87564537" {
  name         = "fiap-client-87564537"
  user_pool_id = aws_cognito_user_pool.lanchonete-fiap-user-pool-645215.id

  # Enable the Cognito Hosted UI
  explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_ADMIN_USER_PASSWORD_AUTH"]

  # Callback URLs (add your own as needed)
  callback_urls = ["https://example.com/callback"]

  # Logout URLs (add your own as needed)
  logout_urls = ["https://example.com/logout"]

  # Prevent user credentials from being exposed to the client side
  allowed_oauth_flows_user_pool_client = true

  # Allow implicit grant for OAuth
  allowed_oauth_flows = ["implicit"]

  # Enable Hosted UI OAuth scopes
  allowed_oauth_scopes = ["openid", "profile", "email"]
}