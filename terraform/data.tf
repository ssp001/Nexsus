data "archive_file" "lambda_embedding" {
  type        = "zip"
  source_file = "../lamdas/lamda_embedding.py"
  output_path = "../zip/lamda_embedding.zip"
}
data "archive_file" "lambda_retriver" {
  type        = "zip"
  source_file = "../lamdas/retriver.py"
  output_path = "../zip/retriver.zip"
}
