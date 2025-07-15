resource "google_cloud_run_service" "my_app" {
  name     = "my-cloud-run-app"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/realtime-data-pipeline-123/flask-app:v1"
        ports {
          container_port = 8080
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "invoker" {
  service    = google_cloud_run_service.my_app.name
  location   = google_cloud_run_service.my_app.location
  role       = "roles/run.invoker"
  member     = "allUsers"
}
