import boto3
import json
import logging
import os
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError


SLACK_CHANNEL = os.environ['slackChannel']
HOOK_URL = os.environ['slackUrl']

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info("Event: " + str(event))
    
    for record in event['Records']:
        subject = record['EventSource']
        if record['Sns']['Subject']:
            subject += ' / ' + record['Sns']['Subject']
    
        try:
            message_json = json.loads(record['Sns']['Message'])
            print(message_json)
            message = json.dumps(message_json, indent=4)
            message_block = f"``` {message} ```"
            color = 'good'

        except (json.JSONDecodeError, TypeError):
            message = str(record['Sns']['Message'])
            color = 'warning'
    
        slack_message = {
            'channel': SLACK_CHANNEL,
            'attachments': [
                {
                    'title': subject,
                    'text': message_block,
                    'color': color,
                }
            ]
        }

        req = Request(HOOK_URL, json.dumps(slack_message).encode('utf-8'))
        try:
            response = urlopen(req)
            response.read()
            logger.info("Message posted to %s", slack_message['channel'])
        except HTTPError as e:
            logger.error("Request failed: %d %s", e.code, e.reason)
        except URLError as e:
            logger.error("Server connection failed: %s", e.reason)