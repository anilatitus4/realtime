from google.cloud import pubsub_v1
import time
import json

project_id = "realtime-data-pipeline-123"
topic_id = "realtime-stream-topic"

publisher = pubsub_v1.PublisherClient()
topic_path = publisher.topic_path(project_id, topic_id)

for i in range(10):
    message_data = {
        "id": i,
        "event": f"Test message {i}"
    }
    data_str = json.dumps(message_data)
    publisher.publish(topic_path, data=data_str.encode("utf-8"))
    print(f"Published: {data_str}")
    time.sleep(1)
