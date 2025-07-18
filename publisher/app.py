from flask import Flask, request, jsonify
from google.cloud import pubsub_v1
import os
import json

app = Flask(__name__)

publisher = pubsub_v1.PublisherClient()
topic_path = publisher.topic_path(os.environ["GCP_PROJECT"], "realtime-stream-topic")

@app.route("/", methods=["POST"])
def publish_message():
    data = request.json
    if not data:
        return "No JSON received", 400
    data_str = json.dumps(data)
    publisher.publish(topic_path, data=data_str.encode("utf-8"))
    return "Message published", 200

@app.route("/", methods=["GET"])
def hello():
    return "Cloud Run publisher service is running!"

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8080))
    app.run(host="0.0.0.0", port=8080)
