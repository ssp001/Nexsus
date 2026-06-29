resource "aws_sqs_queue" "aws_queuqe" {
  name                        = var.sqs_name
  fifo_queue                  = var.fifo
  content_based_deduplication = var.content_based_deduplicate
  redrive_policy = jsonencode(({
    deadLetterTargetArn = aws_sqs_queue.this_queue_deadletter.arn
    maxReceiveCount     = var.max_receive_count
  }))
}
resource "aws_sqs_queue" "terraform_queue" {
  name = "terraform-example-queue"

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.this_queue_deadletter.arn
    maxReceiveCount     = 4
  })
}

resource "aws_sqs_queue" "this_queue_deadletter" {
  name = "terraform-example-deadletter-queue"
}

resource "aws_sqs_queue_redrive_allow_policy" "terraform_queue_redrive_allow_policy" {
  queue_url = aws_sqs_queue.this_queue_deadletter.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.terraform_queue.arn]
  })
}

