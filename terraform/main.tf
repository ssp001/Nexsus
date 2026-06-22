provider "aws" {
  region = var.regioun
}



################################
// lambda function
################################
resource "aws_lambda_function" "retriver_function" {
  function_name = "retriver_fuction"
  timeout       = 30
  role          = aws_iam_role.retriver_fuction.arn
  filename      = data.archive_file.archive_file_retriver_function.output_path
  runtime       = "python3.13"
  handler       = "retriver.main.lambda_event"
  logging_config {
    log_format            = "JSON"
    application_log_level = "INFO"
    system_log_level      = "WARN"
  }
  depends_on = [aws_cloudwatch_log_group.lambda_logs]
  tags = {
    "Enviourment" = var.env
  }

}


resource "aws_lambda_function" "embedding_function" {
  function_name = "embedding_fuction"
  role          = aws_iam_role.embedding_fuction.arn
  timeout       = 30
  filename      = data.archive_file.archive_file_embedding_function.output_path
  runtime       = "python3.13"
  handler       = "embedding.main.lamda_fuction"
  logging_config {
    log_format            = "JSON"
    application_log_level = "INFO"
    system_log_level      = "WARN"
  }
  depends_on = [aws_cloudwatch_log_group.lambda_logs]
  tags = {
    "Enviourment" = var.env
  }
}

resource "aws_lambda_function" "retriver_api" {
  function_name = "retriver_api"
  role          = aws_iam_role.api_getway_role.id
}

################################
// s3 bucket
################################
resource "aws_s3_bucket" "pdf_bucket" {
  bucket = "pdf_storage"

}

################################
// sqs service
################################
resource "aws_sqs_queue" "queue_servcice" {
  name                      = "terraform-example-queue"
  delay_seconds             = 80
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  tags = {
    Environment = var.env
  }
}


################################
// aws dynamodb
################################
resource "aws_dynamodb_table" "nexsus_db_table" {
  name           = "dynamodb_table"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "User_id"
  range_key      = "thread_id"

  attribute {
    name = "User_id"
    type = "S"
  }
  attribute {
    name = "thread_id"
    type = "S"
  }

  tags = {
    "Enviourment" = var.env
  }

}

################################
// cognito function
################################
resource "aws_cognito_user_pool" "example" {
  name = "congnito-pool-service"
}


resource "aws_cognito_user_pool_client" "userpool_client" {
  name                = "client"
  user_pool_id        = aws_cognito_user_pool.pool.id
  explicit_auth_flows = ["ADMIN_NO_SRP_AUTH"]
  refresh_token_rotation {
    feature                    = "ENABLED"
    retry_grace_period_seconds = 10
  }
}

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
  name          = "api_getway_authoraizetr"
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
  uri                     = "arn:aws:apigateway:${var.regioun}:s3:path/${aws_s3_bucket.pdf_bucket.bucket}/{key}"
  credentials             = aws_iam_role.api_getway_role.arn
}
################################
// step function
################################
resource "aws_sfn_state_machine_embeddig" "stap_fuction" {
  name       = "aws_stap_fuction"
  role_arn   = aws_iam_role.step_function.arn
  definition = file("./ingetion.asl.json")
  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.sfn_logs.arn}:*"
    include_execution_data = true
    level                  = "ERROR"
  }
}
resource "aws_sfn_state_machine_retriver" "stap_fuction" {
  name       = "aws_stap_fuction"
  role_arn   = aws_iam_role.step_function.arn
  definition = file("./retriver.asl.json")
  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.sfn_logs.arn}:*"
    include_execution_data = true
    level                  = "ERROR"
  }
}

################################
// cloud watch
################################
resource "aws_cloudwatch_log_group" "sfn_logs" {
  name              = "monitoring_srevice"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "monitoring_srevice"
  retention_in_days = 7
}

