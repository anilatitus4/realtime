terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"   # or any recent stable version
    }
  }
  required_version = ">= 1.0.0"
}

provider "google" {
  project = "realtime-data-pipeline-123"   # your GCP project ID
  region  = "us-central1"                   # your preferred region
  # You can add credentials here if not using default auth
}
