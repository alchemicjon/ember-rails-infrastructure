variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "motwbuddy"
}

variable "domain_name" {
  description = "Value of the domain_name used for the app"
  type        = string
  default     = "motwbuddy.com"
}
