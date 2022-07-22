resource "aws_lambda_function" "lambda" {
  function_name = "lambda-scraper"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda.handler"
  runtime       = "python3.9"
  s3_bucket     = aws_s3_bucket.lambda_bucket.id
  s3_key        = local.lambda_function_package

  layers = [
    aws_lambda_layer_version.layer.arn
  ]
  source_code_hash = filebase64sha256(local.lambda_package_path)

  depends_on = [aws_iam_role_policy_attachment.lambda_role_attachment]
}

resource "aws_lambda_function_url" "test_latest" {
  function_name      = aws_lambda_function.lambda.function_name
  authorization_type = "NONE"
}

resource "aws_lambda_layer_version" "layer" {
  layer_name          = "${local.lambda_name}-layer"
  s3_bucket           = aws_s3_bucket.lambda_bucket.id
  s3_key              = local.lambda_layer_package
  source_code_hash    = filebase64sha256(local.lambda_layer_path)
  compatible_runtimes = ["python3.9"]
}
