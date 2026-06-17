data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  oidc_issuer = trimprefix(module.eks.cluster_oidc_issuer_url, "https://")
}

data "aws_iam_policy_document" "get_parameter_store" {
  statement {
    effect    = "Allow"
    actions   = ["ssm:GetParameter*"]
    resources = ["arn:aws:ssm:${data.aws_region.current.region}:${data.aws_caller_identity.current.id}:parameter/*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["kms:Decrypt", "kms:GenerateDataKey"]
    resources = ["arn:aws:ssm:${data.aws_region.current.region}:${data.aws_caller_identity.current.id}:parameter/*"]
  }
}

resource "aws_iam_policy" "get_parameter_store" {
  name        = "GetParameterStore"
  description = "Policy to allow access to SSM Parameter Store and KMS decryption"

  policy = data.aws_iam_policy_document.get_parameter_store.json
}

data "aws_iam_policy_document" "get_secrets_manager" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = ["arn:aws:secretsmanager:${data.aws_region.current.region}:${data.aws_caller_identity.current.id}:secret:*"]
  }
}

resource "aws_iam_policy" "get_secrets_manager" {
  name        = "GetSecretsManager"
  description = "Policy to allow access to AWS Secrets Manager"

  policy = data.aws_iam_policy_document.get_secrets_manager.json
}

resource "aws_iam_role" "eks-role" {
  assume_role_policy = data.aws_iam_policy_document.trust.json
}

data "aws_iam_policy_document" "trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_issuer}:sub"
      values = [
        "system:serviceaccount:${var.namespace}:${var.service_account_name}"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_issuer}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}
