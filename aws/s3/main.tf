# S3 resources

locals {
  uploads = merge([
    for key, data in var.buckets : {
      for file in data.uploads : (file) => key
    }
  ]...)
}

resource "aws_s3_bucket" "sandbox_buckets" {
  for_each = var.buckets
  bucket   = each.key
  tags = merge(var.tags, {
    Name = each.value.name
  })
}

resource "aws_s3_bucket_versioning" "versioning_sandbox" {
  for_each = var.buckets
  bucket   = aws_s3_bucket.sandbox_buckets[each.key].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_sandbox" {
  for_each = var.buckets
  bucket   = aws_s3_bucket.sandbox_buckets[each.key].id
  rule {
    id     = "remove-old-versions"
    status = "Enabled"
    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

resource "aws_s3_object" "uploads" {
  depends_on = [
    aws_s3_bucket.sandbox_buckets,
  ]
  for_each = local.uploads
  key      = basename(each.key)
  bucket   = aws_s3_bucket.sandbox_buckets[each.value].id
  source   = each.key
}