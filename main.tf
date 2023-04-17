module "s3" {
  source = "./modules/s3"
}

module "dynamodb" {
    source = "./modules/dynamodb"
}

module "lambda" {
    source = "./modules/lambda"
}

module "github-actions-role" {
  source = "./modules/github-actions-role"
}