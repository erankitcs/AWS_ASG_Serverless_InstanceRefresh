## Trigger from System Manager Parameter store from Event Bridge
resource "aws_cloudwatch_event_rule" "ami_updated_rule" {
  name        = "webserver_ami_updated"
  description = "Event when AMI is updated in Parameter store."

  event_pattern = <<EOF
{
    "source": [
        "aws.ssm"
    ],
    "detail-type": [
        "Parameter Store Change"
    ],
    "detail": {
        "name": [
            "${var.ami_id_ssmps}"
        ],
        "operation": [
            "Update"
        ]
    }
}
EOF
}

## Creating Lambda function to kick start instance refresh.
resource "aws_iam_role" "asg_ir_lambda_role" {
  name = "asg_instance_refresh_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "archive_file" "lambda_package" {
  source_dir  = "${path.module}/lambda/"
  output_path = "${path.module}/lambda_function_payload.zip"
  type        = "zip"
}


resource "aws_lambda_function" "asg_ir_lambda" {
  filename         = data.archive_file.lambda_package.output_path
  source_code_hash = data.archive_file.lambda_package.output_base64sha256
  function_name = "asg_instance_refresh_lambda"
  role          = aws_iam_role.asg_ir_lambda_role.arn
  handler       = "handler.lambda_handler"
  runtime = "python3.8"
  environment {
    variables = {
      WebServerASGName = var.webservers_asg_name
    }
  }
}

## Lambda role
resource "aws_iam_policy" "lambda_logging" {
  name        = "asg_ir_lambda_logging"
  path        = "/"
  description = "IAM policy for logging from ASG lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_ssm" {
  name        = "asg_ir_lambda_ssm"
  path        = "/"
  description = "IAM policy for SSM Access from ASG lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeParameters"
            ],
            "Resource": "*"
        },
     {
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameters"
            ],
            "Resource": "arn:aws:ssm:us-east-1:*:parameter${var.ami_id_ssmps}"
        }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.asg_ir_lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_role_policy_attachment" "lambda_ssmps_read" {
  role       = aws_iam_role.asg_ir_lambda_role.name
  policy_arn = aws_iam_policy.lambda_ssm.arn
}

## Attaching lambda with event bridge.
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.ami_updated_rule.name
  target_id = "SentToLambda"
  arn       = aws_lambda_function.asg_ir_lambda.arn
}