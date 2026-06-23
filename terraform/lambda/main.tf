################################
// lambda function
################################
resource "aws_lambda_function" "lamda_function" {
  function_name = var.function_name
  timeout       = var.timeout
  role          = var.iam_role
  filename      = var.filename
  runtime       = var.runtime
  handler       = var.handler
  logging_config {
    log_format            = var.formate
    application_log_level = var.log_level
    system_log_level      = var.system_level
  }
  depends_on = [var.log_module]
  tags = {
    "Enviourment" = var.env
  }

}

