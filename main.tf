terraform {
  backend "remote" {
    organization = "jon-richmond"
    workspaces {
      name = "ember-rails-infrastructure"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_s3_bucket" "test-app-bucket" {
  bucket = "s3-website-test.jon-richmond-test-app.com"
  acl    = "public-read"
  policy = file("policy.json")
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-02e136e904f3da870"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}
