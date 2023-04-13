data "aws_iam_policy_document" "inventory-app-lambda-assume_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "inventory-app-lambda-role" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.inventory-app-lambda-assume_policy.json
}

data "aws_iam_policy_document" "inventory-app-lambda-policy" {
  statement {
    effect    = "Allow"
    actions   = [
        "s3:GetObject",
        "dynamodb:PutItem"
        ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "inventory-app-lambda-policy" {
  name        = "test-policy"
  description = "A test policy"
  policy      = data.aws_iam_policy_document.inventory-app-lambda-policy.json
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.inventory-app-lambda-role.name
  policy_arn = aws_iam_policy.inventory-app-lambda-policy.arn
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "./add_to_table.py"
  output_path = "inventory-add-to-table-lambda.zip"
}

resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "inventory-add-to-table-lambda.zip"
  function_name = "inventory-add-to-table"
  role          = aws_iam_role.inventory-app-lambda-role.arn
  handler       = "add_to_table.lambda_handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.9"
}