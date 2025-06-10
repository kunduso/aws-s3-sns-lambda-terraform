import json
import logging
import urllib.parse

# Set up logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    # Parse the SNS message
    message = json.loads(event['Records'][0]['Sns']['Message'])
    
    # Extract S3 event information
    s3_event = message['Records'][0]['s3']
    bucket_name = s3_event['bucket']['name']
    object_key = urllib.parse.unquote_plus(s3_event['object']['key'])
    
    # Log the file information
    logger.info(f"File uploaded: {object_key} in bucket: {bucket_name}")
    
    return {
        'statusCode': 200,
        'body': json.dumps(f'Successfully processed file: {object_key}')
    }