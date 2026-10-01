output "cloudfront_url" {
  value = aws_cloudfront_distribution.web.domain_name
}

output "public_bucket_name" {
  value = aws_s3_bucket.public_bucket.bucket
}