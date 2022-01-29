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

variable "inline_policy" {
  type    = string
  default = null
}
