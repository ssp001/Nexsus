################################
// cognito function
################################
resource "aws_cognito_user_pool" "user_pool" {
  name = "congnito-pool-service"
}


resource "aws_cognito_user_pool_client" "userpool_client" {
  name                = "client"
  user_pool_id        = aws_cognito_user_pool.user_pool.id
  explicit_auth_flows = ["ADMIN_NO_SRP_AUTH"]
  refresh_token_rotation {
    feature                    = "ENABLED"
    retry_grace_period_seconds = 10
  }
}
