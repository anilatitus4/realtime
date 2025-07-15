resource "google_storage_bucket" "staging_bucket" {
  name     = "${var.project_id}-staging"
  location = var.region
  force_destroy = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket" "raw_data_bucket" {
  name     = "${var.project_id}-raw-data"
  location = var.region
  force_destroy = true
  uniform_bucket_level_access = true
}
