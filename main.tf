# main.tf

# Configure the AWS provider
provider "aws" {
  region = "us-east-1" # Replace with your desired region
}

# Create an IAM Role for the Lambda function
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

# Attach a policy to the IAM role for basic Lambda execution and logging
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create a ZIP archive of your Lambda function code
data "archive_file" "lambda_zip" {
  type        = "zip"
  # source_file = "lambda_function.py" # Path to your Python Lambda code
  # output_path = "lambda_function.zip"
  source_file = "lambda_function_signed_s3.py" # Path to your Python Lambda code
  output_path = "lambda_function_signed_s3.zip"
}

# Create the AWS Lambda Function
resource "aws_lambda_function" "python_lambda" {
  function_name = "my-python-lambda"
  runtime       = "python3.13" # Choose your desired Python runtime
  handler       = "lambda_function.lambda_handler" # File name.handler_function_name
  role          = aws_iam_role.lambda_exec_role.arn
  filename      = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  tags = {
    Environment = "Development",
    CreatedBy   = "terraform"
  }
}

resource "aws_lambda_function_url" "latest_function_url" {
  function_name = aws_lambda_function.python_lambda.function_name
  authorization_type = "NONE"

  cors {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST"]
    allow_headers = ["content-type"]
    max_age       = 86400
  }
}

# Optional: Output the Lambda function ARN
output "lambda_function_arn" {
  value = aws_lambda_function.python_lambda.arn
}
output "lambda_function_url" {
  value = aws_lambda_function_url.latest_function_url.function_url
}
