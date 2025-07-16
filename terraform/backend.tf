terraform {
  backend "gcs" {
    bucket = "realtime-data-pipeline-terraform-state"  # your bucket name here
    prefix = "terraform/state"                         # a folder prefix inside the bucket
  }
}
