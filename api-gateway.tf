resource "aws_apigatewayv2_api" "this" {
  name          = var.API_GATEWAY_NAME
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "fiap_create_user_api" {
  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  payload_format_version = "2.0"
  integration_uri        = aws_lambda_function.fiap_create_user_api.invoke_arn
}

resource "aws_apigatewayv2_integration" "fiap_auth_user_api" {
  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  payload_format_version = "2.0"
  integration_uri        = aws_lambda_function.fiap_auth_user_api.invoke_arn
}

resource "aws_apigatewayv2_route" "create_user_post" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "POST /v1/create-user"
  target    = "integrations/${aws_apigatewayv2_integration.fiap_create_user_api.id}"
}

resource "aws_apigatewayv2_route" "auth_user_get" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "POST /v1/auth-user"
  target    = "integrations/${aws_apigatewayv2_integration.fiap_auth_user_api.id}"
}