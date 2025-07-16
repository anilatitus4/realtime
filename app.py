from flask import Flask, request, jsonify
import json
import os
from google.cloud import pubsub_v1
import datetime

app = Flask(__name__)

# Initialize Pub/Sub publisher
publisher = pubsub_v1.PublisherClient()
project_id = os.environ.get("GOOGLE_CLOUD_PROJECT")
topic_id = "realtime-stream-topic"
topic_path = publisher.topic_path(project_id, topic_id)

@app.route("/", methods=["POST"])
def publish():
    try:
        data = request.get_json()
        if not data:
            return jsonify({"error": "No JSON received"}), 400

        # Add timestamp
        data["timestamp"] = datetime.datetime.utcnow().isoformat()
        data_str = json.dumps(data)
        publisher.publish(topic_path, data_str.encode("utf-8"))

        return jsonify({"status": "Message published", "data": data}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/", methods=["GET"])
def index():
    return "Service is running. Use POST to publish messages.", 200
