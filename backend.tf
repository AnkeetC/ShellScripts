terraform {
  backend "s3" {
    bucket  = "ankeeterabucket"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    #dynamodb_table = "tf-state-lock"
  }
}

