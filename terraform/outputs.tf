output "pubsub_topic" {
  value = google_pubsub_topic.stream_topic.name
}

output "pubsub_subscription" {
  value = google_pubsub_subscription.stream_subscription.name
}

output "bigquery_dataset" {
  value = google_bigquery_dataset.realtime_dataset.dataset_id
}

output "gcs_bucket_staging" {
  value = google_storage_bucket.staging_bucket.name
}

output "gcs_bucket_raw_data" {
  value = google_storage_bucket.raw_data_bucket.name
}
