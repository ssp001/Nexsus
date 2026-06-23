variable "env" {
  description = "this is for enviourment value which enviourment should this service will be produced"
}

variable "name" {
  description = "name for this service"
}

variable "delay_seconds" {
  type        = number
  description = "delay in senconds for this service"
}

variable "max_message_size" {
  type        = number
  description = "max message size for this service"
}

variable "message_retention_seconds" {
  type        = number
  description = "message retention in seconds for this service"
}

variable "receive_wait_time_seconds" {
  type        = number
  description = "receive wait time in seconds for this service"
}
