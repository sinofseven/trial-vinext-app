locals {
  cloudfront = {
    origin = {
      lambda_url = "LambdaUrlFunctions"
      s3 = "S3StaticFiles"
    }
  }
}

resource "aws_cloudfront_origin_access_control" "web" {
  name                              = "s3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_origin_access_control" "ssr" {
  name                              = "lambda-url"
  origin_access_control_origin_type = "lambda"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "web" {
  enabled         = true
  comment         = "tmp"
  is_ipv6_enabled = true
  price_class     = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  origin {
    domain_name              = "${aws_lambda_function_url.ssr.url_id}.lambda-url.${data.aws_region.current.region}.on.aws"
    origin_id                = local.cloudfront.origin.lambda_url
    origin_access_control_id = aws_cloudfront_origin_access_control.ssr.id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
      ip_address_type        = "ipv4"
    }
  }
  
  origin {
    domain_name = aws_s3_bucket.public_bucket.bucket_regional_domain_name
    origin_id   = local.cloudfront.origin.s3
    origin_access_control_id = aws_cloudfront_origin_access_control.web.id
  }

  default_cache_behavior {
    allowed_methods          = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = local.cloudfront.origin.lambda_url
    viewer_protocol_policy   = "redirect-to-https"
    compress                 = true
    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    origin_request_policy_id = "b689b0a8-53d0-40ab-baf2-68738e2966ac"
  }
  
  ordered_cache_behavior {
    allowed_methods = ["HEAD", "GET"]
    cached_methods = ["HEAD", "GET"]
    path_pattern           = "/_next/*"
    target_origin_id       = local.cloudfront.origin.s3
    viewer_protocol_policy = "redirect-to-https"
    compress = true
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }
}
