provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      onset = "terraform"
      app   = local.lambda_name
    }
  }
}

resource "random_uuid" "bucket" {
  keepers = tomap({ type = "lambda", name = "scraper" })
}

resource "random_uuid" "lambda_dependencies_hash" {
  keepers = tomap({ "requirements.txt" = filemd5("${local.root_path}/requirements.txt") })
}

resource "random_uuid" "lambda_package_hash" {
  keepers = {
    for filename in setunion(
      fileset(local.lambda_package_path, "*"),
      fileset(local.lambda_package_path, "**/*")
    ) :
    filename => filemd5("${local.lambda_package_path}/${filename}")
  }
}

locals {
  # TODO change when changing name of the main app folder
  lambda_name         = "lambda-scraper"
  root_path           = "${path.module}/../.."
  lambda_package_path = "${local.root_path}/${local.lambda_name}"
  package_path        = "${local.root_path}/infra/package"
  pip_target_path     = "${local.package_path}/python/lib/python3.9/site-packages"
  lambda_zip_path     = "${local.package_path}/${random_uuid.lambda_package_hash.result}.zip"
  layers_zip_path     = "${local.package_path}/${random_uuid.lambda_dependencies_hash.result}.zip"
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "${local.lambda_name}-${random_uuid.bucket.id}"
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

resource "null_resource" "install_dependencies" {
  provisioner "local-exec" {
    command = "pip install --target ${local.pip_target_path} -r ${local.root_path}/requirements.txt"
  }

  triggers = {
    dependencies_versions = filemd5("${local.root_path}/pyproject.toml")
  }
}

data "archive_file" "lambda_dependencies" {
  type        = "zip"
  source_dir  = local.package_path
  output_path = local.layers_zip_path
  excludes = [
    "__pycache__",
    "**/__pycache__",
    "*.zip"
  ]
  depends_on = [null_resource.install_dependencies]
}

data "archive_file" "lambda_package" {
  type        = "zip"
  source_dir  = "${local.root_path}/${local.lambda_name}"
  output_path = local.lambda_zip_path
}

resource "aws_s3_object" "lambda" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "lambda.zip"
  source = local.lambda_zip_path
  etag   = filemd5(local.lambda_zip_path)

  depends_on = [data.archive_file.lambda_package]
}

resource "aws_s3_object" "layers" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "layers.zip"
  source = local.layers_zip_path
  etag   = filemd5(local.layers_zip_path)

  depends_on = [data.archive_file.lambda_dependencies]
}

resource "aws_cloudwatch_event_rule" "scheduler" {
  name                = "schedule-lambda-scraper"
  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "scheduler" {
  rule      = aws_cloudwatch_event_rule.scheduler.name
  target_id = "lambda-scraper"
  arn       = aws_lambda_function.lambda.arn
}

resource "aws_lambda_permission" "cloudwatch_invoke_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scheduler.arn
}
