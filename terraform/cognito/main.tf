resource "aws_cognito_user_pool" "this" {
  name = "MyExamplePool"
}

resource "aws_cognito_user" "this" {
  user_pool_id = aws_cognito_user_pool.this.id
  username     = "cognito_user_pool"

}



