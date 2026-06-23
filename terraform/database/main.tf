################################
// aws dynamodb
################################
resource "aws_dynamodb_table" "nexsus_db_table" {
  name           = var.env
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
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
