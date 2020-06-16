provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "us-west-1"
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh-key"
  public_key = var.ssh-key
}


