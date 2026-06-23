################################
// step function
################################
resource "aws_sfn_state_machine" "stap_fuction" {
  name       = var.name
  role_arn   = var.role_arn
  definition = var.path
  logging_configuration {
    log_destination        = "${var.log_module}:*"
    include_execution_data = true
    level                  = "ERROR"
  }
}

