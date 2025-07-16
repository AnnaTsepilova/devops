variable "region" {
  description = "Region for the resources"
  type        = string
}

variable "vpc_name" {
  description = "Ім'я VPC"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR блок для VPC"
  type        = string
}

variable "public_subnets" {
  description = "Список CIDR блоків для публічних підмереж"
  type        = list(string)
}

variable "private_subnets" {
  description = "Список CIDR блоків для приватних підмереж"
  type        = list(string)
}

variable "availability_zones" {
  description = "Список зон доступності для підмереж"
  type        = list(string)
}

variable "eks_name" {
  description = "EKS name"
  type        = string
}

variable "ecr_name" {
  description = "ECR repository name"
  type        = string
}
