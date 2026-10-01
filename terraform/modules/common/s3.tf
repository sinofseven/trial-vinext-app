resource "aws_s3_bucket" "public_bucket" {
  bucket = format("trial-vinext-app-%s-%s-an", data.aws_caller_identity.current.account_id, data.aws_region.current.region)
  bucket_namespace = "account-regional"
}

resource "aws_s3_bucket" "package_bucket" {
  bucket = format("trial-vinext-app-for-package-%s-%s-an", data.aws_caller_identity.current.account_id, data.aws_region.current.region)
  bucket_namespace = "account-regional"
}

data "aws_iam_policy_document" "public_bucket" {
  policy_id = "public_bucket"
  statement {
    sid = "PublicBucket"
    effect = "Allow"
    principals {
      identifiers = ["cloudfront.amazonaws.com"]
      type = "Service"
    }
    actions = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.public_bucket.arn}/*"]
    condition {
      test     = "StringEquals"
      values = [aws_cloudfront_distribution.web.arn]
      variable = "AWS:SourceArn"
    }
  }
}

resource "aws_s3_bucket_policy" "public_bucket" {
  bucket = aws_s3_bucket.public_bucket.bucket
  policy = data.aws_iam_policy_document.public_bucket.json
}