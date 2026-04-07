
locals {
  /*filter just the ones that are enabled*/
  lambdas = { for key, data in var.lambdas : (key) => data if data.enabled == true }
}

# Role permissions
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_execution_role" {
  name               = "lambda_execution_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Lambda configuration

data "local_file" "lambda_archive" {
  filename = "${path.module}/template/function.zip"
}

resource "aws_lambda_function" "lambda_app" {
  for_each      = local.lambdas
  filename      = data.local_file.lambda_archive.filename
  code_sha256   = data.local_file.lambda_archive.content_base64sha256
  function_name = each.value.name
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = each.value.handler
  runtime       = each.value.runtime

  environment {
    variables = {
      env = "dev",
      runtime = each.value.runtime
    }
  }

  tags = merge(var.tags, {
    Name = each.value.name
  })
}
