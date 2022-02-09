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
        Resource = "arn:aws:iam::*:user/demo/$${aws:username}"
      },
    ]
  })
}

resource "aws_iam_user_policy" "RolyPoly" {
  name = "ec2-permission"
  user = aws_iam_user.demo.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iam:PassRole",
          "iam:AttachRolePolicy"
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

resource "aws_iam_user_policy_attachment" "ec2-developer" {
  user       = aws_iam_user.demo.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role" "AdministrativeRole" {
  name               = "Administrative"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect": "Allow",
        "Action": [
          "sts:AssumeRole"
        ],
        "Principal": {
          "Service": [
            "ec2.amazonaws.com"
          ]
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "AdministrativeRoleProfile" {
  name = "AdministrativeRoleProfile"
  role = aws_iam_role.AdministrativeRole.name
}

resource "aws_iam_role_policy_attachment" "AdministrativeRolePolicy" {
  role       = aws_iam_role.AdministrativeRole.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}


output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "iam_user_key" {
	value = aws_iam_access_key.demo.id
}

output "iam_user_secret" {
	value = nonsensitive(aws_iam_access_key.demo.secret)
}
