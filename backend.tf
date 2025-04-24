terraform {
  backend "s3" {
    bucket = "s3-csg-dev-statefiles-cia9um2mevn1"
    key    = "dev_421184975327_eu-west-1_terraform_tsu.tfstate"
    region = "eu-central-1"
    dynamodb_table = "terraform_lock_state"
    encrypt        = true
  }
}