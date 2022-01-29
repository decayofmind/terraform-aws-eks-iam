variable "cluster_oidc_issuer_url" {
  type = string
}

variable "cluster_id" {
  type = string
}

variable "service_account_name" {
  type = string
}

variable "service_account_namespace" {
  type = string
}

variable "iam_inline_policy" {
  type    = string
  default = null
}

variable "iam_policy_attachments" {
  type    = list(string)
  default = []
}
