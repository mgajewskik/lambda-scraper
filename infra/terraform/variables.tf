variable "lambda_log_level" {
  description = "Log level for the Lambda Python runtime."
  default     = "DEBUG"
}

variable "from_email" {
  description = "Email address which sends the email."
  default     = "mgajewskik+SES@gmail.com"
}

variable "to_email" {
  description = "Email address to send an email to."
  default     = "mgajewskik@gmail.com"
}
