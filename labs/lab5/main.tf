terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

data "aws_caller_identity" "current" {}

resource "aws_iam_user" "demo" {
  name = "demo"
  path = "/demo/"
  force_destroy = true
}

resource "aws_iam_access_key" "demo" {
  user = aws_iam_user.demo.name
}

resource "aws_iam_user_policy" "consolePasswordPolicy" {
  name = "consolePassword"
  user = aws_iam_user.demo.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iam:CreateLoginProfile",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_user_policy" "updateAccessKey" {
  name = "updateAccessKey"
  user = aws_iam_user.demo.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iam:DeleteAccessKey",
          "iam:GetAccessKeyLastUsed",
          "iam:UpdateAccessKey",
          "iam:CreateAccessKey",
          "iam:ListAccessKeys"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_user_policy_attachment" "demoIAMRead" {
  user       = aws_iam_user.demo.name
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

resource "aws_iam_user" "johnDoe" {
  name = "jdoe"
  path = "/admin/"
  force_destroy = true
}

resource "aws_iam_user_policy_attachment" "johnDoeAdminPolicy" {
  user       = aws_iam_user.johnDoe.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "iam_user_key" {
	value = "export AWS_ACCESS_KEY_ID=${aws_iam_access_key.demo.id}"
}

output "iam_user_secret" {
	value = "export AWS_SECRET_ACCESS_KEY=${nonsensitive(aws_iam_access_key.demo.secret)}"
}
