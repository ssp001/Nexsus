
resource "aws_lambda_function" "this" {
  role          = var.role
  function_name = var.name
  handler       = var.function
  runtime       = var.py_version
  filename      = var.file_name
  tags = {
    "enviourment" : var.enviourment
  }
}
