variable "lambda_function_name" {
  type        = string
  description = "Name of the Lambda function to create"
}

variable "python_version" {
  type        = string
  default     = "python3.13"
  description = "version of Python to use"
}

variable "lambda_source_filename" {
  type        = string
  default     = "lambda_handler.py"
  description = "Source file for lambda_handler script"
}

# variable "lambda_source_function" {
#   type = string
#   default = "lambda_handler"
#   description = "lambda_handler script as function name"
# }

# variable "lambda_source_zipfile" {
#   type = string
#   default = "lambda_handler.zip"
#   description = "lambda_handler script zipped filename"
# }

locals {
  lambda_source_function = regex("([[:ascii:]]+).py", var.lambda_source_filename)[0]
  lambda_source_zipfile  = join(".", [local.lambda_source_function, "zip"])
}
