
terraform {
  backend "s3" {
      bucket = "gravatar-terraform-546525900473-us-east-1"
      key    = "terraform.tfstate"
      region = "us-east-1"
  }
}
