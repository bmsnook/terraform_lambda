# lambda_function.py
import json

def lambda_handler(event, context):
    """
    Lambda handler function.
    """
    print(f"Received event: {json.dumps(event)}")
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
