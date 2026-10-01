# ================================================================
# Config
# ================================================================

terraform {
  required_version = "~> 1.15"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.67"
    }
  }
}

# ================================================================
# Provider
# ================================================================

provider "aws" {
  region = "ap-northeast-1"
}

# ================================================================
# Modules
# ================================================================

module "common" {
  source = "../../modules/common"
}

# ================================================================
# Outputs
# ================================================================

output "cloudfront_url" {
  value = module.common.cloudfront_url
}

output "public_bucket_name" {
  value = module.common.public_bucket_name
}