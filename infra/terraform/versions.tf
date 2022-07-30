terraform {
  required_version = "~>1.2"
  backend "s3" {
    bucket         = "terraform-state-files-z408xc9brfmno7u3"
    key            = "lambda-scraper/terraform.tfstate"
    dynamodb_table = "terraform-state-lock-z408xc9brfmno7u3"
    region         = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.5"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.3.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }
}
