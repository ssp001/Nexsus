variable "name" {
  type    = string
  default = "databse name"
}

variable "env" {
  type        = string
  description = "production enviourment"
}

variable "read_capacity" {
  type        = number
  description = "the read capacity of the database"
}

variable "write_capacity" {
  type        = number
  description = "dabase write capacity"
}
