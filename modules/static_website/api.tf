resource "aws_api_gateway_rest_api" "portfolio_api" {
  name        = "Portfolio API"
  description = "API for sending emails via Lambda and SES"
}

# POST method directly on the root resource
resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.portfolio_api.id
  resource_id   = aws_api_gateway_rest_api.portfolio_api.root_resource_id  # Reference root resource directly
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.portfolio_api.id
  resource_id = aws_api_gateway_rest_api.portfolio_api.root_resource_id  # Reference root resource directly
  http_method = aws_api_gateway_method.post_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.send_email_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "email_deployment" {
  depends_on = [
    aws_api_gateway_method.post_method,
    aws_api_gateway_integration.post_lambda_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.portfolio_api.id
  stage_name  = "prod"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.send_email_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.portfolio_api.execution_arn}/*/*"
}

# Enable CORS for the root resource
resource "aws_api_gateway_method" "options_email" {
  rest_api_id   = aws_api_gateway_rest_api.portfolio_api.id
  resource_id   = aws_api_gateway_rest_api.portfolio_api.root_resource_id 
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_email_integration" {
  rest_api_id = aws_api_gateway_rest_api.portfolio_api.id
  resource_id = aws_api_gateway_rest_api.portfolio_api.root_resource_id  
  http_method = aws_api_gateway_method.options_email.http_method

  type = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}
resource "aws_api_gateway_method_response" "post_email_200" {
  rest_api_id = aws_api_gateway_rest_api.portfolio_api.id
  resource_id = aws_api_gateway_rest_api.portfolio_api.root_resource_id
  http_method = aws_api_gateway_method.post_method.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "post_email_integration_200" {
  rest_api_id = aws_api_gateway_rest_api.portfolio_api.id
  resource_id = aws_api_gateway_rest_api.portfolio_api.root_resource_id
  http_method = aws_api_gateway_method.post_method.http_method
  status_code = aws_api_gateway_method_response.post_email_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS,GET'"
    "method.response.header.Access-Control-Allow-Origin"  = join(",", ["'https://www.ivanravic.com'", "'https://ivanravic.com'"])
  }
  response_templates = {
    "application/json" = ""
  }
}
resource "aws_api_gateway_method_response" "options_email_200" {
  rest_api_id = aws_api_gateway_rest_api.portfolio_api.id
  resource_id = aws_api_gateway_rest_api.portfolio_api.root_resource_id  
  http_method = aws_api_gateway_method.options_email.http_method
  
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "options_email_integration_200" {
  rest_api_id = aws_api_gateway_rest_api.portfolio_api.id
  resource_id = aws_api_gateway_rest_api.portfolio_api.root_resource_id  
  http_method = aws_api_gateway_method.options_email.http_method
  status_code = aws_api_gateway_method_response.options_email_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS,GET'"
    "method.response.header.Access-Control-Allow-Origin"  = join(",", ["'https://www.ivanravic.com'", "'https://ivanravic.com'"])
  }

  response_templates = {
    "application/json" = ""
  }
}

#API Gateway Usage Plan
resource "aws_api_gateway_usage_plan" "api_usage_plan" {
  name = "APIUsagePlan"

  throttle_settings {
    burst_limit = 2
    rate_limit  = 1
  }

  api_stages {
    api_id     = aws_api_gateway_rest_api.portfolio_api.id
    stage      = aws_api_gateway_deployment.email_deployment.stage_name
  }
}

# Uncomment these lines if you need an API key
# resource "aws_api_gateway_api_key" "client_api_key" {
#   name    = "ClientAPIKey"
#   enabled = true
# }

# resource "aws_api_gateway_usage_plan_key" "client_usage_plan_key" {
#   key_id        = aws_api_gateway_api_key.client_api_key.id
#   key_type      = "API_KEY"
#   usage_plan_id = aws_api_gateway_usage_plan.api_usage_plan.id
# }

resource "aws_api_gateway_domain_name" "ivanravic_domain" {
  domain_name = "api.ivanravic.com"

  certificate_arn = aws_acm_certificate.api_certification.arn
}

resource "aws_api_gateway_base_path_mapping" "ivanravic_base_path" {
  api_id      = aws_api_gateway_rest_api.portfolio_api.id
  stage_name  = aws_api_gateway_deployment.email_deployment.stage_name
  domain_name = aws_api_gateway_domain_name.ivanravic_domain.domain_name
}

