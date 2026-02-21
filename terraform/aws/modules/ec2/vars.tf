variable "instance_type" {
  type        = string
  default     = "t3.medium"
  description = "Default ec2 instance type variable"
}

variable "subnet_id" {
  type        = string
  default     = "subnet-0852a4e422a2ea812"
  description = "Default public subnet ID"
}

variable "security_group_id" {
  description = "The ID of the security group to attach"
  type        = string
}