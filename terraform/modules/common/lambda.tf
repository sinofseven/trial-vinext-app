data "archive_file" "lambda_deploy_package" {
  type        = "zip"
  output_path = "lambda_deploy_package.zip"
  source_dir  = "${path.root}/../../../.output/server"
}

resource "aws_s3_object" "lambda_deploy_package" {
  bucket = aws_s3_bucket.package_bucket.bucket
  key    = "lambda_deploy_package.zip"
  source = data.archive_file.lambda_deploy_package.output_path
  etag   = data.archive_file.lambda_deploy_package.output_md5
}

resource "aws_lambda_function" "ssr" {
  function_name    = "trial-vinext-tmp-ssr"
  role             = aws_iam_role.lambda.arn
  runtime          = "nodejs24.x"
  architectures    = ["arm64"]
  handler          = "index.handler"
  memory_size      = 512
  timeout          = 30
  s3_bucket        = aws_s3_object.lambda_deploy_package.bucket
  s3_key           = aws_s3_object.lambda_deploy_package.key
  source_code_hash = data.archive_file.lambda_deploy_package.output_base64sha256
  publish          = true
  environment {
    variables = {
      ABOUT_MESSAGE = "SSRで値を入れました！"
    }
  }
}

resource "aws_lambda_alias" "ssr" {
  function_name    = aws_lambda_function.ssr.function_name
  function_version = aws_lambda_function.ssr.version
  name             = "alias"
}

resource "aws_lambda_function_url" "ssr" {
  authorization_type = "AWS_IAM"
  invoke_mode        = "BUFFERED"
  function_name      = aws_lambda_function.ssr.function_name
  qualifier          = aws_lambda_alias.ssr.name
}

resource "aws_lambda_permission" "ssr_invoke_function" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ssr.function_name
  qualifier     = aws_lambda_alias.ssr.name
  principal     = "cloudfront.amazonaws.com"
  source_arn    = aws_cloudfront_distribution.web.arn
}

resource "aws_lambda_permission" "ssr_invoke_function_url" {
  action        = "lambda:InvokeFunctionUrl"
  function_name = aws_lambda_function.ssr.function_name
  qualifier     = aws_lambda_alias.ssr.name
  principal     = "cloudfront.amazonaws.com"
  source_arn    = aws_cloudfront_distribution.web.arn
}
