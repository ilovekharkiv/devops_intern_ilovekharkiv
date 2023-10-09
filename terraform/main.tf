terraform {
    backend "s3" {
        bucket = "medterraformstate"
        key    = "state.tfstate"
        region = "eu-north-1"
    }
}

provider "aws" {}

