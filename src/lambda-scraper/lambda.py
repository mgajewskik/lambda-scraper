import os

import boto3

CHARSET = "UTF-8"
HTML_EMAIL_CONTENT = """
    <html>
        <head></head>
        <h1 style='text-align:center'>This is the heading</h1>
        <p>Hello, world</p>
        </body>
    </html>
"""


def send_plain_email():
    ses_client = boto3.client("ses", region_name="us-east-1")

    response = ses_client.send_email(
        Destination={
            "ToAddresses": [
                os.environ["FROM_EMAIL"],
            ],
        },
        Message={
            "Body": {
                "Text": {
                    "Charset": CHARSET,
                    "Data": "Hello, world!",
                }
            },
            "Subject": {
                "Charset": CHARSET,
                "Data": "Test Email",
            },
        },
        Source=os.environ["FROM_EMAIL"],
    )
    return response


def handler(event, context):
    return send_plain_email()
