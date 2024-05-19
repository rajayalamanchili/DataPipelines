resource "aws_s3_bucket" "s3_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_ssm_parameter" "mlflow-bucket-url" {
  name  = "/${var.app_name}/${var.env}/ARTIFACT_URL"
  type  = "SecureString"
  value = "s3://${aws_s3_bucket.s3_bucket.bucket}"
}

output "mlflow_artifact_url_ssm_name" {
  value = aws_ssm_parameter.mlflow-bucket-url.name
}