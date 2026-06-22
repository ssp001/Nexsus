data "archive_file" "archive_file_embedding_function" {
  type        = "zip"
  source_file = "../embedding/main.py"
  output_path = "../embedding/embedding.zip"
}

data "archive_file" "archive_file_retriver_function" {
  type        = "zip"
  source_file = "../retriver/main.py"
  output_path = "../retriver/retriver.zip"
}
