import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions, StandardOptions
import json
from datetime import datetime

class ParseMessageFn(beam.DoFn):
    def process(self, element):
        record = json.loads(element.decode('utf-8'))
        # Validate and clean timestamp
        record['timestamp'] = record.get('timestamp', datetime.utcnow().isoformat())
        yield record

def run():
    options = PipelineOptions()
    options.view_as(StandardOptions).streaming = True
    with beam.Pipeline(options=options) as p:
        (
            p
            | 'Read from PubSub' >> beam.io.ReadFromPubSub(subscription='projects/realtime-data-pipeline-123/subscriptions/realtime-stream-sub')
            | 'Parse JSON' >> beam.ParDo(ParseMessageFn())
            | 'Write to BigQuery' >> beam.io.WriteToBigQuery(
                table='realtime-data-pipeline-123.realtime_dataset.streaming_output',
                schema='timestamp:TIMESTAMP,message:STRING',
                write_disposition=beam.io.BigQueryDisposition.WRITE_APPEND,
                create_disposition=beam.io.BigQueryDisposition.CREATE_IF_NEEDED
            )
        )

if __name__ == '__main__':
    run()
