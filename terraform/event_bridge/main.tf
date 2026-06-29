# Create the Custom Event Bus
resource "aws_cloudwatch_event_bus" "app_bus" {
  name = "application-event-bus"
}

# Create the Rule to intercept specific incoming telemetry data events
resource "aws_cloudwatch_event_rule" "sqs_routing_rule" {
  name           = "route-to-sqs-rule"
  event_bus_name = aws_cloudwatch_event_bus.app_bus.name
  description    = "Matches user login events and routes them to our SQS target."

  # The exact JSON structure required to trigger a routing event
  event_pattern = jsonencode({
    source      = ["my.company.auth"]
    detail-type = ["datasendingtosqs"]
  })
}

resource "aws_sqs_queue" "event_destination_queue" {
  name                      = "eventbridge-receiver-queue"
  message_retention_seconds = 86400 # Keep messages for 1 day
}

# Create the Rule to intercept specific incoming telemetry data events
resource "aws_cloudwatch_event_rule" "sqs_routing_rule" {
  name           = "route-to-sqs-rule"
  event_bus_name = aws_cloudwatch_event_bus.app_bus.name
  description    = "Matches user login events and routes them to our SQS target."

  # The exact JSON structure required to trigger a routing event
  event_pattern = jsonencode({
    source      = ["my.company.auth"]
    detail-type = ["UserLogin"]
  })
}

resource "aws_cloudwatch_event_target" "sqs_target" {
  event_bus_name = aws_cloudwatch_event_bus.app_bus.name
  rule           = aws_cloudwatch_event_rule.sqs_routing_rule.name
  target_id      = "SendDirectToSQS"
  arn            = aws_sqs_queue.event_destination_queue.arn
}
