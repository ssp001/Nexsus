
#########################
// terraform provider
#########################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.52.0"
    }
  }
}

#############################
//provisioning regioun 
#############################
provider "aws" {
  # Configuration options
  region = "ap-south-1"
}

#####################################
// lambda modules
#####################################


module "lambda_retriver" {
  source      = "./lambda"
  name        = "lambd_retriver_endpoint"
  role        = aws_iam_role.db.arn
  enviourment = var.env
  py_version  = "python3.13"
  file_name   = data.archive_file.lambda_retriver.output_path
  function    = "lamda_retriver_api.lambda_handeler"
}

module "lambda_embedding" {
  source      = "./lambda"
  name        = "lambd_embedding_api_endpoint"
  role        = aws_iam_role.lambda.arn
  enviourment = var.env
  py_version  = "python3.13"
  file_name   = data.archive_file.lambda_embedding.output_path
  function    = "lamda_retriver_api.lambda_handeler"
}


#####################################
// dynamodb module
#####################################
module "database" {
  source      = "./database"
  dbname      = "dynamo_db"
  read_cap    = 10
  write_cap   = 10
  enviourment = var.env
}


#####################################
// s3 
#####################################
resource "aws_s3_bucket" "this" {
  bucket = "Bucket_storage"
  tags = {
    "Enviourment" = var.env
  }
}

#####################################
// sqs 
#####################################
module "sqs_queue" {
  source                    = "./sqs"
  sqs_name                  = "terraform_queue"
  fifo                      = false
  content_based_deduplicate = true
  max_receive_count         = 5
}
#####################################
// eventbridge 
#####################################
