vpc_name       = "lesson-5-vpc"
vpc_cidr_block = "10.0.0.0/16"

availability_zones = [
  "us-west-2a",
  "us-west-2b",
  "us-west-2c"
]

public_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24"
]

private_subnets = [
  "10.0.4.0/24",
  "10.0.5.0/24",
  "10.0.6.0/24"
]

ecr_name     = "lesson-5-ecr"
