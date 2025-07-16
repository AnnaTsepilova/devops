data "aws_region" "current" {}

locals {
  name = format("%s-%s",
    var.project,
    replace(data.aws_region.current.region, "-", "")
  )
  tags = merge(
    {
      Terraform_managed = "True"
      AWS_REGION        = data.aws_region.current.region
    },
    var.tags
  )
}
