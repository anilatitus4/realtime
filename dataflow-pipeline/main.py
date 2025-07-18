import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions, StandardOptions
import json
from datetime import datetime

class ParseMessageFn(beam.DoFn):
    def process(self, element):
        record = json.loads(element.decode('utf-8'))

        # Extract or create timestamp
        timestamp = record.get('timestamp', datetime.utcnow().isoformat())
        message_text = record.get('event', '')

        yield {
            'timestamp': timestamp,
            'message': message_text
        }

def run():
    options = PipelineOptions(
        streaming=True,
        save_main_session=True
    )
    options.view_as(StandardOptions).streaming = True

    with beam.Pipeline(options=options) as p:
        (
            p
            | 'Read from PubSub' >> beam.io.ReadFromPubSub(
                subscription='projects/realtime-data-pipeline-123/subscriptions/realtime-stream-sub'
            )
            | 'Parse JSON and Extract Fields' >> beam.ParDo(ParseMessageFn())
            | 'Write to BigQuery' >> beam.io.WriteToBigQuery(
                table='realtime-data-pipeline-123.realtime_dataset.streaming_output',
                schema='timestamp:TIMESTAMP,message:STRING',
                write_disposition=beam.io.BigQueryDisposition.WRITE_APPEND,
                create_disposition=beam.io.BigQueryDisposition.CREATE_IF_NEEDED
            )
        )

if __name__ == '__main__':
    run()
