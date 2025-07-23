# Структура проекту
```
project/
│
├── main.tf                  # Головний файл для підключення модулів
├── backend.tf               # Налаштування бекенду для стейтів (S3 + DynamoDB)
├── outputs.tf               # Загальне виведення ресурсів
├── terraform.tfvars         # Файл конфігураційних значень для інфраструктури
├── providers.tf             # Опис провайдерів Terraform
│
├── modules/                 # Каталог з усіма модулями
│   │
│   ├── s3-backend/          # Модуль для S3 та DynamoDB
│   │   ├── s3.tf            # Створення S3-бакета
│   │   ├── dynamodb.tf      # Створення DynamoDB
│   │   ├── variables.tf     # Змінні для S3
│   │   └── outputs.tf       # Виведення інформації про S3 та DynamoDB
│   │
│   ├── vpc/                 # Модуль для VPC
│   │   ├── locals.tf        # Підготовка локальних змінних
│   │   ├── vpc.tf           # Створення VPC, підмереж, Internet Gateway
│   │   ├── routes.tf        # Налаштування маршрутизації
│   │   ├── variables.tf     # Змінні для VPC
│   │   └── outputs.tf       # Виведення інформації про VPC
│   │
│   ├── eks/                 # Модуль для Kubernetes кластера
│   │   ├── eks.tf           # Створення кластера
│   │   ├── variables.tf     # Змінні для EKS
│   │   └── outputs.tf       # Виведення інформації про кластер
│   │
│   ├── ecr/                 # Модуль для ECR
│   │   ├── data.tf          # Отримання змінних хмарного провайдера
│   │   ├── ecr.tf           # Створення ECR репозиторію
│   │   ├── variables.tf     # Змінні для ECR
│   │   └── outputs.tf       # Виведення URL репозиторію ECR
│   │
│   ├── rds/                 # Модуль для RDS
│   │   ├── rds.tf           # Створення RDS бази даних  
│   │   ├── aurora.tf        # Створення aurora кластера бази даних  
│   │   ├── shared.tf        # Спільні ресурси  
│   │   ├── variables.tf     # Змінні (ресурси, креденшели, values)
│   │   └── outputs.tf 
│   │
│   ├── jenkins/             # Модуль для Helm-установки Jenkins
│   │   ├── jenkins.tf       # Helm release для Jenkins
│   │   ├── variables.tf     # Змінні (ресурси, креденшели, values)
│   │   ├── providers.tf     # Оголошення провайдерів
│   │   ├── values.yaml      # Конфігурація jenkins
│   │   └── outputs.tf       # Виводи (URL, пароль адміністратора)
│   │ 
│   └── argo_cd/             # ✅ Новий модуль для Helm-установки Argo CD
│       ├── jenkins.tf       # Helm release для Jenkins
│       ├── variables.tf     # Змінні (версія чарта, namespace, repo URL тощо)
│       ├── providers.tf     # Kubernetes+Helm.  переносимо з модуля jenkins
│       ├── values.yaml      # Кастомна конфігурація Argo CD
│       ├── outputs.tf       # Виводи (hostname, initial admin password)
│		    └──charts/                  # Helm-чарт для створення app'ів
│ 	 	    ├── Chart.yaml
│	  	    ├── values.yaml          # Список applications, repositories
│			    └── templates/
│		        ├── application.yaml
│		        └── repository.yaml
│
├── charts/
│   └── django-app/
│       ├── templates/
│       │   ├── deployment.yaml
│       │   ├── service.yaml
│       │   ├── configmap.yaml
│       │   └── hpa.yaml
│       ├── Chart.yaml
│       └── values.yaml     # ConfigMap зі змінними середовища
│
└── README.md                # Документація проєкту
```

# RDS налаштування

Приклад використання модуля rds

```
module "rds" {
  source = "./modules/rds"

  name                       = "myapp-db"      # Назва бази данних чи кластера Aurora
  use_aurora                 = false           # Переключення між Aurora та Postgres
  aurora_instance_count      = 2               # Кількість нод Aurora

  # --- Aurora-only ---
  engine_cluster             = "aurora-postgresql"
  engine_version_cluster     = "15.3"
  parameter_group_family_aurora = "aurora-postgresql15"
  

  # --- RDS-only ---
  engine                     = "postgres"               # Ти бази данних "postgres" чи "mysql"
  engine_version             = "17.4"                   # Версія бази данних
  parameter_group_family_rds = "postgres17"             # Name of the DB parameter group to associate.

  # Common
  instance_class             = "db.t3.medium"           # Тип інстанса
  allocated_storage          = 20                       # Розмір сховища для бази данних у Gb
  db_name                    = "myapp"                  # Назва початкової бази в середені інстанса
  username                   = "postgres"               # Root користувач
  password                   = "admin123AWS23"          # Пароль Root користувача
  subnet_private_ids         = module.vpc.private_subnets
  subnet_public_ids          = module.vpc.public_subnets
  publicly_accessible        = false                    # Перемикач доступа до бази данних з мережі інтернет публічна \ приватна
  vpc_id                     = module.vpc.vpc_id        # VPC id
  multi_az                   = true                     # High Avaliabilty мультізона
  backup_retention_period    = 7                        # Кількість резервних копій
  parameters = {
    max_connections              = "200"                # Ліміт одночасних підключень
    log_min_duration_statement   = "500"
  }

  tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}
```

Для переключення на AuroraDB - змінити `use_aurora = true` 

Для використання "postgres" чи "mysql" змінити `engine = "postgres"` відповідно до типу
а також версію `engine_version` і `parameter_group_family_rds` згіддно документації Terraform https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance



# Команди для ініціалізації та запуску
```
terraform init
terraform plan
terraform apply
```

# Встановлення prometheus
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install prometheus prometheus-community/prometheus --namespace monitoring

kubectl get all -n monitoring
kubectl port-forward -n monitoring svc/prometheus-server 9090:80
```

# Встановлення grafana
```
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install grafana grafana/grafana \
  --namespace monitoring \
  --create-namespace \
  --set adminPassword=SecretPassword

kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode
kubectl port-forward svc/grafana 3000:80 -n monitoring
```

# Встановлення додатка
```
helm install django-app ./django-app
```


# Видалення ресурсів
```
terraform destroy
```

# Деплой

1. В Jenkins запускаємо pipeline seed-job для динамічного створення іншого pipeline goit-django-docker
2. В Jenkins запускаємо pipeline goit-django-docker для збірки та деплою Docker image у AWS ECR
3. В ArgoCD перевіряємо статус застосунку після синхронізації
