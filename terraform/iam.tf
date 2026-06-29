###################################
// s3
###################################

resource "aws_iam_role" "lambda" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "s3.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }

}

resource "aws_iam_policy" "lambda" {
  policy = jsonencode({
    sion = "2012-10-17"
    Statement = [
      {
        Action = [
          "lambda:Invoke*",
        ]
        Effect   = "Allow"
        Resource = "*"
    }, ]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = aws_iam_policy.lambda.arn
  role       = aws_iam_policy.lambda.id
}


###################################
// apigetway
###################################
resource "aws_iam_role" "s3" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "apigetway.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }

}


resource "aws_iam_policy" "s3" {
  policy = jsonencode({
    sion = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3.PutObject*",
        ]
        Effect   = "Allow"
        Resource = "*"
    }, ]
  })
}


resource "aws_iam_policy_attachment" "this" {
  name       = "apigetway_s3_poliy_attachment"
  policy_arn = aws_iam_policy.s3.arn
  roles      = [aws_iam_role.s3.id]
}
###################################
// Dynamodb 
###################################
resource "aws_iam_role" "db" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "dynamodb.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "this_db" {
  policy = jsonencode({
    sion = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:GetItem*",
        ]
        Effect   = "Allow"
        Resource = "*"
    }, ]
  })
}

resource "aws_iam_policy_attachment" "this_policy" {
  name       = "db_policy"
  policy_arn = aws_iam_policy.this_db.arn
  roles      = [aws_iam_role.db.id]
}
###################################
// sqs db acces role  
###################################

resource "aws_iam_role" "sqs" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "sqs.amazonaws.com"
        }
      },
    ]
  })
}
resource "aws_iam_role" "pipe_execution_role" {
  name = "sqs-to-dynamodb-connector-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "://amazonaws.com" }
    }]
  })
}


resource "aws_iam_policy" "this_sqs" {
  policy = jsonencode({
    sion = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:PutItem*",
        ]
        Effect   = "Allow"
        Resource = "*"
    }, ]
  })
}

resource "aws_iam_policy_attachment" "this_sqs_policy" {
  name       = "db_policy"
  policy_arn = aws_iam_policy.this_sqs.arn
  roles      = [aws_iam_role.sqs.id]
}
resource "aws_pipes_pipe" "sqs_to_dynamodb" {
  name     = "sqs-to-dynamodb-pipe"
  role_arn = aws_iam_role.pipe_execution_role.arn
  source   = aws_iam_role.pipe_execution_role.arn
  target   = module.database.data_base_arn

  source_parameters {
    sqs_queue_parameters {
      batch_size = 1
    }
  }
  target_parameters {
    # If you want to format the JSON data being sent to DynamoDB
    input_template = <<EOT
    {
      "id": {"S": <$.body.id>},
      "message": {"S": <$.body.message_text>}
    }
    EOT
  }
}
