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
│   └── ecr/                 # Модуль для ECR
│       ├── data.tf          # Отримання змінних хмарного провайдера
│       ├── ecr.tf           # Створення ECR репозиторію
│       ├── variables.tf     # Змінні для ECR
│       └── outputs.tf       # Виведення URL репозиторію ECR
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

# Команди для ініціалізації та запуску
```
terraform init
terraform plan
terraform apply

helm install django-app ./django-app

terraform destroy
```

# Деплой

1. В Jenkins запускаємо pipeline seed-job для динамічного створення іншого pipeline goit-django-docker
2. В Jenkins запускаємо pipeline goit-django-docker для збірки та деплою Docker image у AWS ECR
3. В ArgoCD перевіряємо статус застосунку після синхронізації
