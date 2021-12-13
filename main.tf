locals {
  cluster_oidc_issuer = replace(var.cluster_oidc_issuer_url, "https://", "")
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "this" {
  name = "eks-${var.cluster_id}-sa-${var.service_account_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.cluster_oidc_issuer}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringLike = {
            "${local.cluster_oidc_issuer}:sub" = "system:serviceaccount:${var.service_account_namespace}:${var.service_account_name}"
            "${local.cluster_oidc_issuer}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = length(var.iam_policy_attachments)
  policy_arn = var.iam_policy_attachments[count.index]
  role       = aws_iam_role.this.id
}

resource "aws_iam_role_policy" "this" {
  count  = var.iam_inline_policy != null ? 1 : 0
  name   = "eks-${var.cluster_id}-sa-${var.service_account_name}"
  policy = var.iam_inline_policy
  role   = aws_iam_role.this.id
}
