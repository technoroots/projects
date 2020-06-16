#

terraform {
  backend "s3" {
    acl            = "private"
    bucket         = "mayank.4aug-bucket"
    key            = "terraform/dev/usw2/terraform.tfstate"
    region         = "us-west-2"
#    profile        = ""
    dynamodb_table = "mayank.4aug-lock"
  }
}
#
