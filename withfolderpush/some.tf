resource "aws_api_gateway_rest_api" "api-dev-aws-collectors-com" {
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "api-dev.aws-collectors.com"
      version = "1.0"
    }
    paths = {
      "/path1" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "GET"
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "https://ip-ranges.amazonaws.com/ip-ranges.json"
          }
        }
      }
    }
  })

  name        = "api-dev.aws-collectors.com"
  description = "Shared Public API Gateway - Managed by Terraform"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

#  code-

resource "aws_api_gateway_rest_api_policy" "example" {
  rest_api_id = aws_api_gateway_rest_api.api-dev-aws-collectors-com.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "execute-api:*",
                "lambda:InvokeFunction"
            ],
            "Resource": "${aws_api_gateway_rest_api.api-dev-aws-collectors-com.execution_arn}/*/GET/api-dev.aws-collectors.com"
        }
    ]
}
EOF
}


resource "aws_api_gateway_authorizer" "api-dev-aws-collectors-com" {
  name                   = "api-auth-1"
  rest_api_id            = aws_api_gateway_rest_api.api-dev-aws-collectors-com.id
  authorizer_uri         = aws_lambda_function.test_lambda.invoke_arn #
  authorizer_credentials = aws_iam_role.iam_for_lambda.arn #
}

resource "aws_api_gateway_resource" "api-dev-aws-collectors-com" {
  parent_id   = aws_api_gateway_rest_api.api-dev-aws-collectors-com.root_resource_id
  path_part   = "api-dev.aws-collectors.com"
  rest_api_id = aws_api_gateway_rest_api.api-dev-aws-collectors-com.id
}

resource "aws_api_gateway_method" "api-dev-aws-collectors-com" {
  authorization = "CUSTOM"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.api-dev-aws-collectors-com.id
  rest_api_id   = aws_api_gateway_rest_api.api-dev-aws-collectors-com.id
  authorizer_id = aws_api_gateway_authorizer.api-dev-aws-collectors-com.id
}

resource "aws_api_gateway_integration" "api-dev-aws-collectors-com" {
  http_method = aws_api_gateway_method.api-dev-aws-collectors-com.http_method
  resource_id = aws_api_gateway_resource.api-dev-aws-collectors-com.id
  rest_api_id = aws_api_gateway_rest_api.api-dev-aws-collectors-com.id
  #type        = "MOCK"
  type = "HTTP_PROXY"
  integration_http_method = "GET"
  uri          = "https://ip-ranges.amazonaws.com/ip-ranges.json"
}

resource "aws_api_gateway_deployment" "api-dev-aws-collectors-com" {
  rest_api_id = aws_api_gateway_rest_api.api-dev-aws-collectors-com.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.api-dev-aws-collectors-com.id,
      aws_api_gateway_method.api-dev-aws-collectors-com.id,
      aws_api_gateway_integration.api-dev-aws-collectors-com.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_api_gateway_stage" "api-dev-aws-collectors-com" {
  deployment_id = aws_api_gateway_deployment.api-dev-aws-collectors-com.id
  rest_api_id   = aws_api_gateway_rest_api.api-dev-aws-collectors-com.id
  stage_name    = "v1"
}



resource "aws_api_gateway_usage_plan" "api-dev-aws-collectors-com" {
  name         = "api-dev-aws-collectors-com"
  description  = "api-dev-aws-collectors-com"
  product_code = "MYCODE"
}

resource "aws_api_gateway_api_key" "api-dev-aws-collectors-com" {
  name = "api-dev.aws-collectors.com"
}
