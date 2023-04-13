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

resource "aws_s3_bucket_policy" "allow_lambda_access_to_bucket" {
  bucket = aws_s3_bucket.inventory-app-bucket.id
  policy = data.aws_iam_policy_document.allow_lambda_access_to_bucket.json
}

data "aws_iam_policy_document" "allow_lambda_access_to_bucket" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::606026656431:role/iam_for_lambda"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      "${aws_s3_bucket.inventory-app-bucket.arn}/*"
    ]
  }
}