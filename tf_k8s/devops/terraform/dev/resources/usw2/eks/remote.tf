terraform {
  backend "s3" {
    acl            = "private"
    bucket         = "mayank.4aug-bucket"
    key            = "terraform/dev/resources/usw2/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "mayank.4aug-lock"
  }
}


data "terraform_remote_state" "usw2" {
  backend = "s3"

  config = {
    bucket  = "mayank.4aug-bucket"
    key     = "terraform/dev/usw2/terraform.tfstate" 
    region  = "us-west-2"
  }
}


data "aws_vpc" "hub" {
  id = data.terraform_remote_state.usw2.outputs.vpcs["hub"]
}

data "aws_subnet" "private" {
  count = length(
    data.terraform_remote_state.usw2.outputs.private_subnets[data.aws_vpc.hub.id],
  )
  id = element(
    data.terraform_remote_state.usw2.outputs.private_subnets[data.aws_vpc.hub.id],
    count.index,
  )
}

data "aws_subnet" "public" {
  count = length(
    data.terraform_remote_state.usw2.outputs.public_subnets[data.aws_vpc.hub.id],
  )
  id = element(
    data.terraform_remote_state.usw2.outputs.public_subnets[data.aws_vpc.hub.id],
    count.index,
  )
}

# end

