data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "db_backups" {
  bucket = "${data.aws_caller_identity.current.account_id}-tv-db-backups"

  lifecycle_rule {
    id      = "backups"
    enabled = true

    expiration {
      days = 7
    }
  }
}

resource "aws_s3_bucket_public_access_block" "db_backups" {
  bucket = aws_s3_bucket.db_backups.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


data "aws_iam_policy_document" "offline_site_full_access" {
  statement {
    actions = [
      "s3:GetBucketAcl",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:ListBucket",
      "s3:PutBucketAcl",
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::arn:aws:s3:::tvs-offline/",
      "arn:aws:s3:::arn:aws:s3:::tvs-offline/*"
    ]
  }
}

resource "aws_iam_policy" "offline_site_full_access" {
  name   = "offline_site_full_access"
  policy = data.aws_iam_policy_document.db_backups_in_s3.json
}

resource "aws_iam_user_policy_attachment" "offline_site_full_access" {
  user       = aws_iam_user.deploy.name
  policy_arn = aws_iam_policy.offline_site_full_access.arn
}
