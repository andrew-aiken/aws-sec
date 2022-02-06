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

resource "aws_iam_user_policy_attachment" "demoIAMRead" {
  user       = aws_iam_user.demo.name
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
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
        Resource = "arn:aws:iam::*:user/demo/$${aws:username}"
      },
    ]
  })
}

resource "aws_iam_user_policy" "changePolicyVersion" {
  name = "changePolicyVersion"
  user = aws_iam_user.demo.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iam:GetPolicyVersion",
          "iam:ListPolicyVersions",
          "iam:SetDefaultPolicyVersion"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

variable "versionVar" {
  default = true
  type    = bool
}

resource "aws_iam_policy" "developerPermissions" {
  name        = "developerPermissions"
  path        = "/"
  description = "My test policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          var.versionVar ? "iam:*" : "iam:ListRoles"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_user_policy_attachment" "developerPermissions" {
  user       = aws_iam_user.demo.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/developerPermissions"
  depends_on = [
    aws_iam_policy.developerPermissions
  ]
}

# 

output "iam_user_key" {
	value = aws_iam_access_key.demo.id
}

output "iam_user_secret" {
	value = nonsensitive(aws_iam_access_key.demo.secret)
}
