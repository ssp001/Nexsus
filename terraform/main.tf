provider "aws" {
  region = var.regioun
}



################################
// lambda function
################################
module "retriver_function" {
  source        = "./lambda"
  function_name = "retriver_fuction"
  timeout       = 30
  iam_role      = aws_iam_role.retriver_fuction.arn
  filename      = data.archive_file.archive_file_retriver_function.output_path
  runtime       = "python3.13"
  handler       = "retriver.main.lambda_event"
  log_module    = [module.lambda_logs.log_manager]
  formate       = "JSON"
  system_level  = "ERROR"
  log_level     = "INFO"
  env           = var.env
}


module "embedding_function" {
  source        = "./lambda"
  function_name = "embedding_fuction"
  iam_role      = aws_iam_role.embedding_fuction.arn
  timeout       = 30
  filename      = data.archive_file.archive_file_embedding_function.output_path
  runtime       = "python3.13"
  log_module    = [module.lambda_logs.log_manager]
  formate       = "JSON"
  system_level  = "ERROR"
  log_level     = "INFO"
  handler       = "embedding.main.lamda_fuction"
  env           = var.env
}

module "api_endpoint_embedding_function" {
  source        = "./lambda"
  function_name = "embedding_fuction"
  iam_role      = aws_iam_role.embedding_fuction.arn
  timeout       = 30
  filename      = NONE
  runtime       = "python3.13"
  log_module    = [module.lambda_logs.log_manager]
  formate       = "JSON"
  system_level  = "ERROR"
  log_level     = "INFO"
  handler       = "embedding.main.lamda_fuction"
  env           = var.env
}
module "api_endpointe_retriver_function" {
  source        = "./lambda"
  function_name = "retriver_function"
  iam_role      = aws_iam_role.embedding_fuction.arn
  timeout       = 30
  filename      = NONE
  runtime       = "python3.13"
  log_module    = [module.lambda_logs.log_manager]
  formate       = "JSON"
  system_level  = "ERROR"
  log_level     = "INFO"
  handler       = "embedding.main.lamda_fuction"
  env           = var.env
}

################################
// s3 bucket
################################
resource "aws_s3_bucket" "pdf_bucket" {
  bucket = "pdf_storage"

}
################################
// cognito function
################################
module "cognito" {
  source = "./cognito"
}


################################
// sqs service
################################
module "sqs_service" {
  source                    = "./sqs"
  name                      = "terraform-example-queue"
  delay_seconds             = 80
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  env                       = var.env
}

################################
// aws dynamodb
################################
module "data_base" {
  source         = "./database"
  name           = "database_table"
  read_capacity  = 20
  write_capacity = 20
  env            = var.env
}


################################
// api getway
################################
module "api_getway" {
  source              = "./api_getway"
  api_authorizer_name = "api_getway"
  regioun             = var.regioun
  lambda_instance     = module.api_endpoint_embedding_function.lambda_inctance
  role_arn            = aws_iam_role.api_getway_role.arn
  env                 = var.env
}

################################
// step function
################################
module "aws_sfn_state_machine_embeddig" {
  source     = "./orcastrator"
  name       = "aws_stap_fuction"
  role_arn   = aws_iam_role.step_function.arn
  log_module = module.sfn_logs.log_manager
  path       = file("../ingetion.asl.json")

}
module "aws_sfn_state_machine_retriver" {
  source     = "./orcastrator"
  name       = "aws_stap_fuction"
  role_arn   = aws_iam_role.step_function.arn
  log_module = module.sfn_logs.log_manager
  path       = file("../retriver.asl.json")
}

################################
// cloud watch
################################
module "sfn_logs" {
  source            = "./monitoring"
  name              = "monitoring_srevice_for_sfn"
  retention_in_days = 7
}
module "lambda_logs" {
  source            = "./monitoring"
  name              = "monitoring_srevice_lambda"
  retention_in_days = 7
}

