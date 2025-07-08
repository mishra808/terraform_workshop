variable "my_enviroment" {
  description = "Instance type for the EC2 instance"
  default     = "test"
  type = string
}

variable "aws_root_storage_size" {
  description = "Instance type for the EC2 instance"
  default     = 15
  type = number
}