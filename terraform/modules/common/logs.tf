resource "aws_cloudwatch_log_group" "ssr" {
  name = "/aws/lambda/${aws_lambda_function.ssr.function_name}"
  retention_in_days = 7
}