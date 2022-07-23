provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      onset = "terraform"
      app   = "lambda-scraper"
    }
  }
}

resource "random_uuid" "bucket" {
  keepers = tomap({ type = "lambda", name = "scraper" })
}

locals {
  lambda_name             = "lambda-scraper"
  lambda_layer_package    = "layers.zip"
  lambda_function_package = "lambda.zip"
  lambda_layer_path       = "${path.module}/../../src/package/${local.lambda_layer_package}"
  lambda_package_path     = "${path.module}/../../src/package/${local.lambda_function_package}"
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "${local.lambda_name}-${random_uuid.bucket.id}"
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

resource "aws_s3_object" "lambda" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = local.lambda_function_package
  source = local.lambda_package_path

  etag = filemd5(local.lambda_package_path)
}

resource "aws_s3_object" "layers" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = local.lambda_layer_package
  source = local.lambda_layer_path

  etag = filemd5(local.lambda_layer_path)
}







# variable "resource_prefix" {}
# variable "lambda_warmer_role_arn" {}
# variable "deployment_package_bucket" {}
# variable "deployment_package_key" {}
# variable "lambda_package_hash" {}
# variable "lambda_layers" {}
# variable "subnets" {}
# variable "vpc_id" {}
# variable "tags" {}
#
#
# resource "aws_lambda_function" "lambda_warmer" {
#   function_name    = "${var.resource_prefix}-lambda-warmer"
#   handler          = "sdu_commons.lambdas.warmer_lambda.handler"
#   role             = var.lambda_warmer_role_arn
#   runtime          = "python3.8"
#   s3_bucket        = var.deployment_package_bucket
#   s3_key           = var.deployment_package_key
#   timeout          = 300
#   source_code_hash = var.lambda_package_hash
#   layers           = var.lambda_layers
#   memory_size      = 3008
#   tags             = var.tags
#
#   vpc_config {
#     security_group_ids = [aws_security_group.warmer_security_group.id]
#     subnet_ids         = var.subnets
#   }
#
#   environment {
#     variables = {
#       NAME_PREFIXES_TO_WARM = var.resource_prefix
#       WARMER_CONCURRENCY    = 2
#       LAMBDAS_NAMES_TO_OMIT = "${var.resource_prefix}-extract-geotiff-coord"
#     }
#   }
# }
#
# resource "aws_cloudwatch_event_rule" "lambda_warmer" {
#   name                = "${var.resource_prefix}-schedule-lambda-warmer"
#   schedule_expression = "rate(3 minutes)"
# }
#
# resource "aws_cloudwatch_event_target" "lambda_warmer" {
#   rule      = aws_cloudwatch_event_rule.lambda_warmer.name
#   target_id = "${var.resource_prefix}-lambda-warmer-event-target"
#   arn       = aws_lambda_function.lambda_warmer.arn
# }
#
# resource "aws_lambda_permission" "cloudwatch_invoke_lambda" {
#   statement_id  = "${var.resource_prefix}-lambda-warmer-event-invoke"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.lambda_warmer.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.lambda_warmer.arn
# }
#
# resource "aws_security_group" "warmer_security_group" {
#   name        = "${var.resource_prefix}-lambda-warmer"
#   description = "Security group for warmer"
#   vpc_id      = var.vpc_id
#   tags        = var.tags
# }
#
# resource "aws_security_group_rule" "allow_egress" {
#   type              = "egress"
#   protocol          = "-1"
#   from_port         = 0
#   to_port           = 0
#   security_group_id = aws_security_group.warmer_security_group.id
#   cidr_blocks = [
#     "0.0.0.0/0",
#   ]
# }
