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

resource "google_cloud_run_service" "publisher_service" {
  name     = "publisher-service"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/realtime-data-pipeline-123/publisher-service:v1"

        env {
          name  = "GOOGLE_CLOUD_PROJECT"
          value = "realtime-data-pipeline-123"
        }
      }
      service_account_name = "10017251802-compute@developer.gserviceaccount.com"
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "noauth" {
  service  = google_cloud_run_service.publisher_service.name
  location = google_cloud_run_service.publisher_service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
