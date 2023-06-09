resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "Respiratory-Supplies"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "Id"

  attribute {
    name = "Id"
    type = "N"
  }
}