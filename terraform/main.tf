# All your resources here, example:

resource "google_pubsub_topic" "stream_topic" {
  name = "realtime-stream-topic"
}

resource "google_pubsub_subscription" "stream_subscription" {
  name  = "realtime-stream-sub"
  topic = google_pubsub_topic.stream_topic.name
}

resource "google_storage_bucket" "raw_data_bucket" {
  name                        = "realtime-data-pipeline-123-raw-data"
  location                    = "US-CENTRAL1"
  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket" "staging_bucket" {
  name                        = "realtime-data-pipeline-123-staging"
  location                    = "US-CENTRAL1"
  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "google_bigquery_dataset" "realtime_dataset" {
  dataset_id = "realtime_dataset"
  location   = "us-central1"
}

resource "google_bigquery_table" "realtime_table" {
  dataset_id = google_bigquery_dataset.realtime_dataset.dataset_id
  table_id   = "streaming_output"
  schema = jsonencode([
    {
      name = "timestamp"
      type = "TIMESTAMP"
      mode = "REQUIRED"
    },
    {
      name = "message"
      type = "STRING"
      mode = "REQUIRED"
    }
  ])
  time_partitioning {
    type = "DAY"
  }
}
