resource "aws_iam_role" "lambda_role" {
  name = "terraform_aws_lambda_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
        "Effect": "Allow",
        "Principal": {
         "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
    }    
  ]
}
EOF
}

# IAM policy for logging from a lambda

resource "aws_iam_policy" "iam_policy_for_lambda" {
  name = "aws_iam_policy_for_terraform_aws_lambda_role"
  path = "/"
  description = "AWS IAM policy for managing aws lambda role"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }    
  ]
}
EOF
}

# Policy attachment on the role

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn 
}

# Generates an archive from content, a file, or a directory of files.

data "archive_file" "zip_the_python_code" {
  type = "zip"
  source_dir = "${path.module}/scripts/"
  output_path = "${path.module}/scripts/function.zip"
}

# Create a lambda function

resource "aws_lambda_function" "lambda_func" {
  filename = "${path.module}/scripts/function.zip"
  function_name = "Test_Lambda_function"
  role = aws_iam_role.lambda_role.arn
  handler = "function.lambda_handler"
  runtime = "python3.8"
  depends_on = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}

#Configuring API Gateway

resource "aws_api_gateway_rest_api" "example" {
  name        = "ServerlessExample"
  description = "Terraform Serverless Application Example"
}
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  parent_id   = "${aws_api_gateway_rest_api.example.root_resource_id}"
  path_part   = "proxy-1"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = "${aws_api_gateway_rest_api.example.id}"
  resource_id   = "${aws_api_gateway_resource.proxy.id}"
  http_method   = "POST"
  authorization = "NONE"
}

# Outputs

output "terraform_aws_role" {
  value = aws_iam_role.lambda_role.name
}

output "terraform_aws_role_arn_output" {
  value = aws_iam_role.lambda_role.arn
}

output "terraform_logging_arn_output" {
  value = aws_iam_policy.iam_policy_for_lambda.arn
}



