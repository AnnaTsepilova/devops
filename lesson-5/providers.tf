terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      ## Версія провайдера заблоквована через помилку в репозіторії модулів hashicorp для версії 6.1.0
      version = "= 6.0.0"
    }
  }
}
