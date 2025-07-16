terraform {
  required_version = ">= 1.3.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  credentials = file("/Users/anilatitus/Desktop/creds/realtime.json")
  project     = var.project_id
  region      = var.region
}
