variable "kubeconfig" {
  description = "Шлях до kubeconfig файлу"
  type        = string
  default     = ""
}

variable "namespace" {
  description = "Jenkins namespace"
  type        = string
  default     = "jenkins"
}

variable "cluster_name" {
  description = "Назва Kubernetes кластера"
  type        = string
}

variable "oidc_provider_arn" {
  description = "OIDC-provider ARN"
  type = string
}

variable "oidc_provider_url" {
  description = "OIDC-provider URL"
  type = string
}
