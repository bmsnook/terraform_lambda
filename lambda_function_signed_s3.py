import boto3

s3_client = boto3.client('s3')

bucket_name = 'bms-gm-pdfs'
object_key = 'lorem_ipsum.pdf'
expiration_seconds = 600

def lambda_handler(event, context):
    """
    Lambda handler function.
    """

  presigned_url = s3_client.generate_presigned_url(
    ClientMethod='get_object',
    Params={'Bucket': bucket_name, 'Key': object_key},
    ExpiresIn=expiration_seconds
  )

  return {
    'statusCode': 200,
    'body': presigned_url
  }
