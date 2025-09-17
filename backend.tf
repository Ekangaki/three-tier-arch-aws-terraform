terraform {
  backend "s3" {
    bucket         = "ekangaki-nguti-terraform-backend"
    encrypt        = true
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "ekangaki-nguti--terraform-backend"
  }
}
