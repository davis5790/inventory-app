resource "aws_s3_bucket" "inventory-app-bucket" {
  bucket = var.bucket-name
}

resource "aws_s3_object" "test-csv" {
  bucket = aws_s3_bucket.inventory-app-bucket.id
  key    = "/test/test.csv"
  source = "./Test.csv"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("/Test.csv")
}