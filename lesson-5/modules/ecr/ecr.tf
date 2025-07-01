resource "aws_ecr_repository" "this" {
  name                 = var.ecr_name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}

resource "aws_iam_policy" "ecr_policy" {
  name        = "ecr-${aws_ecr_repository.this.name}-repository-policy"
  description = "Full read access to the ECR ${aws_ecr_repository.this.name} repository"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:PutImageTagMutability",
          "ecr:StartImageScan",
          "ecr:DescribeImageReplicationStatus",
          "ecr:ListTagsForResource",
          "ecr:UploadLayerPart",
          "ecr:BatchDeleteImage",
          "ecr:ListImages",
          "ecr:BatchGetRepositoryScanningConfiguration",
          "ecr:DeleteRepository",
          "ecr:CompleteLayerUpload",
          "ecr:TagResource",
          "ecr:DescribeRepositories",
          "ecr:BatchCheckLayerAvailability",
          "ecr:ReplicateImage",
          "ecr:GetLifecyclePolicy",
          "ecr:PutLifecyclePolicy",
          "ecr:DescribeImageScanFindings",
          "ecr:GetLifecyclePolicyPreview",
          "ecr:PutImageScanningConfiguration",
          "ecr:GetDownloadUrlForLayer",
          "ecr:DeleteLifecyclePolicy",
          "ecr:PutImage",
          "ecr:UntagResource",
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:StartLifecyclePolicyPreview",
          "ecr:InitiateLayerUpload",
          "ecr:GetRepositoryPolicy",
        ]
        Resource = "arn:aws:ecr:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:repository/${var.ecr_name}"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:GetRegistryPolicy",
          "ecr:BatchImportUpstreamImage",
          "ecr:CreateRepository",
          "ecr:DescribeRegistry",
          "ecr:DescribePullThroughCacheRules",
          "ecr:GetAuthorizationToken",
          "ecr:PutRegistryScanningConfiguration",
          "ecr:CreatePullThroughCacheRule",
          "ecr:DeletePullThroughCacheRule",
          "ecr:GetRegistryScanningConfiguration",
          "ecr:PutReplicationConfiguration",
        ]
        Resource = "*"
      }
    ]
  })
}
