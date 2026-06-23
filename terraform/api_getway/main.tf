################################
// api getway
################################

resource "aws_api_gateway_rest_api" "rest_api" {
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "example"
      version = "1.0"
    }
    paths = {
      "/path1" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "GET"
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "https://ip-ranges.amazonaws.com/ip-ranges.json"
          }
        }
      }
    }
  })

  name = "rest_api_getway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
resource "aws_api_gateway_authorizer" "api_getway_authorizer" {
  name          = var.api_authorizer_name
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = [aws_api_gateway_rest_api.rest_api.arn]
}

resource "aws_api_gateway_deployment" "api_getway" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  region = var.regioun

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.rest_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_api_gateway_resource" "api_getway_resource" {
  path_part   = "resource"
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
}

resource "aws_api_gateway_method" "MyDemoMethod" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.api_getway_resource.id
  http_method   = "POST"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.api_getway_resource.id
  http_method             = aws_api_gateway_method.MyDemoMethod.rest_api_id
  integration_http_method = "PUT"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.regioun}:lambda:path/${var.lambda_instance}/{key}"
  credentials             = var.role_arn
}
