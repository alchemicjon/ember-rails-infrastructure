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

resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.domain_name}", "www.${var.domain_name}", "www.${var.domain_name}", "api.${var.domain_name}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_zone" "primary" {
  name = var.domain_name
}

resource "aws_s3_bucket" "primary-app-bucket" {
  bucket = var.domain_name
  acl    = "public-read"
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_s3_bucket" "secondary-app-bucket" {
  bucket = "www.${var.domain_name}"
  acl    = "log-delivery-write"
  website {
    redirect_all_requests_to = var.domain_name
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-02e136e904f3da870"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}
