terraform {
  required_version = "~>1.2"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "mgajewskik"
    workspaces {
      name = "lambda-scraper"
    }
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
