terraform {
    backend "remote" {
        hostname = "app.terraform.io"
        organization = "my-org"

        workspaces {
          name = "my-workspace"
        }
      
    }
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "4.18.0"
        }
    }

}

provider "aws" {
  profile = "default"
  region  = "ap-south-1"
}
