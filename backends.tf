terraform {
  cloud {
    organization = "fixitdad"

    workspaces {
      name = "terraform-lambda-signed-s3-url"
    }
  }
}