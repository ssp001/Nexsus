variable "dbname" {
  type        = string
  description = "name for data base"

}
variable "read_cap" {
  type        = numberc
  description = "read capacity of the database"
}

variable "write_cap" {
  type        = number
  description = "write capacity of the database"
}

variable "enviourment" {
  type    = string
  default = "eviourment value"
}

