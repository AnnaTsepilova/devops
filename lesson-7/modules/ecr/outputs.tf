output "vpc_id" {
  description = "ID створеної VPC"
  value       = aws_ecr_repository.this.name
}
