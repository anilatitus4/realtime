import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions, StandardOptions
import json
import datetime

class ParseMessage(beam.DoFn):
    def process(self, element):
        message = element.decode('utf-8')  # raw Pub/Sub message
        timestamp = datetime.datetime.utcnow().isoformat()

        # Tag raw message for GCS
        yield beam.pvalue.TaggedOutput('raw', message)

        # Create structured row for BigQuery
        row = {
            'timestamp': timestamp,
            'message': message
        }
        yield row

def run():
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('--project', required=True)
    parser.add_argument('--region', required=True)
    parser.add_argument('--input_subscription', required=True)  # Changed from input_topic
    parser.add_argument('--output_path', required=True)
    parser.add_argument('--bq_table', required=True)
    known_args, pipeline_args = parser.parse_known_args()

    # Beam pipeline options
    options = PipelineOptions(pipeline_args)
    google_cloud_options = options.view_as(beam.options.pipeline_options.GoogleCloudOptions)
    google_cloud_options.project = known_args.project
    google_cloud_options.region = known_args.region
    google_cloud_options.job_name = 'realtime-dataflow-job'
    google_cloud_options.staging_location = 'gs://realtime-data-pipeline-123-staging/staging'
    google_cloud_options.temp_location = 'gs://realtime-data-pipeline-123-staging/temp'
    options.view_as(StandardOptions).streaming = True

    with beam.Pipeline(options=options) as p:
        messages = (
            p
            | 'ReadFromPubSub' >> beam.io.ReadFromPubSub(subscription=known_args.input_subscription)
            | 'ParseMessage' >> beam.ParDo(ParseMessage()).with_outputs('raw', main='bq')
        )

        # Write parsed messages to BigQuery
        messages.bq | 'WriteToBigQuery' >> beam.io.WriteToBigQuery(
            known_args.bq_table,
            schema='timestamp:TIMESTAMP,message:STRING',
            write_disposition=beam.io.BigQueryDisposition.WRITE_APPEND,
            create_disposition=beam.io.BigQueryDisposition.CREATE_IF_NEEDED
        )

        # Write raw messages to GCS in 60-second windows
        from apache_beam.transforms.window import FixedWindows

        messages.raw | 'WindowForGCS' >> beam.WindowInto(FixedWindows(60)) \
                     | 'WriteToGCS' >> beam.io.WriteToText(
                         known_args.output_path,
                         file_name_suffix='.txt',
                         shard_name_template='-SS-of-NN'
                     )

if __name__ == '__main__':
    run()
