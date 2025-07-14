output "project_id" {
  value = var.project_id
}

output "region" {
  value = var.region
}

output "pubsub_topic" {
  value = google_pubsub_topic.realtime_topic.name
}

output "pubsub_subscription" {
  value = google_pubsub_subscription.realtime_subscription.name
}

output "bigquery_dataset" {
  value = google_bigquery_dataset.realtime_dataset.dataset_id
}

output "bigquery_table" {
  value = google_bigquery_table.realtime_table.table_id
}

output "gcs_bucket_raw_data" {
  value = google_storage_bucket.raw_data_bucket.name
}

output "gcs_bucket_staging" {
  value = google_storage_bucket.staging_bucket.name
}
