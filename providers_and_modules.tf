provider "aws" {
  region = var.region
}

provider "null" {
  # Configuration options
}

locals {
  resources_tag = "prov-example"
}
