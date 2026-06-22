

#################################
/* 
- stape fuction access
*/
#################################

resource "aws_iam_role" "step_function" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "states.amazonaws.com"
        }
      },
    ]

  })
}
resource "aws_iam_policy" "states_policy" {
  name        = "states_policy"
  description = "IAM policy for step function"
  policy = jsonencode({
    Action = [
      "s3:PutObject*",
      "lambda:InvokeFunction*",
      "sqs:SendMessage*"
    ]
    Effect   = "Allow"
    Resource = "*"
  })
  tags = {
    "Enviourment" = var.env
  }
}


resource "aws_iam_policy_attachment" "states_attacchement_role_policy" {
  name       = "states_attacchement_role_policy"
  policy_arn = aws_iam_policy.states_policy.arn
  roles      = [aws_iam_role.step_function.name]
}


#################################
/* 
- sqs access
*/
#################################
resource "aws_iam_role" "sqs" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "sqs.amazonaws.com"
        }
      },
    ]

  })
}

resource "aws_iam_policy" "sqs_policy" {
  name        = "states_policy"
  description = "IAM policy for step function"
  policy = jsonencode({
    Action = [
      "dynamodb:PutItem",
      "dynamodb:UpdateItem"
    ]
    Effect   = "Allow"
    Resource = "*"
  })
  tags = {
    "Enviourment" = var.env
  }
}

resource "aws_iam_policy_attachment" "sqs_attacchement_role_policy" {
  name       = "sqs_attacchement_role_policy"
  policy_arn = aws_iam_policy.sqs_policy.arn
  roles      = [aws_iam_role.sqs.name]
}



#################################
/* 
- lambda_fuction_role 
*/
#################################


resource "aws_iam_role" "embedding_fuction" {
  name = "embedding_fuction"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]

  })
}
resource "aws_iam_role" "retriver_fuction" {
  name = "retriver_fuction"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]

  })
}

##################################
// s3 acessa for api getway 
##################################

resource "aws_iam_role" "api_getway_role" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "api_getway_lamda_policy" {
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lambda:Invoke"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


resource "aws_iam_policy_attachment" "s3_access_for_api_getway" {
  name       = "s3_access_for_api_getway"
  policy_arn = aws_iam_policy.api_getway_lamda_policy.arn
  roles      = [aws_iam_role.api_getway_role.name]
}


