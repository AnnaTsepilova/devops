module "s3_backend" {
  source      = "./modules/s3-backend"           # Шлях до модуля
  bucket_name = "terraform-state-bucket-lesson5" # Ім'я S3-бакета
  table_name  = "terraform-locks"                # Ім'я DynamoDB
}

# Підключаємо модуль для VPC
module "vpc" {
  source             = "./modules/vpc"        # Шлях до модуля VPC
  vpc_cidr_block     = var.vpc_cidr_block     # CIDR блок для VPC
  public_subnets     = var.public_subnets     # Публічні підмережі
  private_subnets    = var.private_subnets    # Приватні підмережі
  availability_zones = var.availability_zones # Зони доступності
  vpc_name           = var.vpc_name           # Ім'я VPC
}

# Підключаємо модуль ECR
module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = var.ecr_name
  scan_on_push = true
}

module "eks" {
  source        = "./modules/eks"
  cluster_name  = var.eks_name              # Назва кластера
  subnet_ids    = module.vpc.public_subnets # ID підмереж
  region        = var.region
  instance_type = "t3.medium" # Тип інстансів
  desired_size  = 1           # Бажана кількість нодів
  max_size      = 2           # Максимальна кількість нодів
  min_size      = 1           # Мінімальна кількість нодів
}

resource "aws_eks_access_entry" "root_access" {
  cluster_name      = var.eks_name
  principal_arn     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  kubernetes_groups = []
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "example" {
  cluster_name  = var.eks_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"

  access_scope {
    type       = "cluster"
    ##namespaces = ["example-namespace"]
  }
}

data "aws_eks_cluster" "eks" {
  name = module.eks.eks_cluster_name

  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.eks_cluster_name

  depends_on = [module.eks]
}

module "jenkins" {
  source       = "./modules/jenkins"
  cluster_name = module.eks.eks_cluster_name

  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url

  providers = {
    helm = helm
    kubernetes = kubernetes
  }
}

module "argo_cd" {
  source        = "./modules/argo_cd"
  namespace     = "argocd"
  chart_version = "5.46.4"
}
