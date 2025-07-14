resource "google_pubsub_topic" "stream_topic" {
  name = "realtime-stream-topic"
}

resource "google_pubsub_subscription" "stream_subscription" {
  name  = "realtime-stream-sub"
  topic = google_pubsub_topic.stream_topic.id
  ack_deadline_seconds = 20
}
