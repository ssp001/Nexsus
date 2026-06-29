resource "aws_dynamodb_table" "this" {
  name           = var.dbname
  read_capacity  = var.read_cap
  write_capacity = var.write_cap
  hash_key       = "user_id"
  range_key      = "doc_id"

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "doc_id"
    type = "S"
  }
  tags = {
    "Enviourment" = var.enviourment
  }
}
