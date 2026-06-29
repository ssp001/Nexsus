variable "sqs_name" {
  description = "sqs_name"
  type        = string
}
variable "fifo" {
  type        = bool
  description = "fifo bool value"
}
variable "content_based_deduplicate" {
  type        = bool
  description = "duplication boolean value"
}


variable "max_receive_count" {
  type        = number
  description = "max reciceive countt for dead letter queue"
}
