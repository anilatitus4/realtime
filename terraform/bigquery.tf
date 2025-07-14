resource "google_bigquery_dataset" "realtime_dataset" {
  dataset_id = "realtime_dataset"
  location   = var.region
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
