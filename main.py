import json
import boto3
from pydantic import BaseModel, EmailStr, ValidationError, constr
from typing import Optional
import logging
# Pydantic model for form data validation
class FormData(BaseModel):
    client_name: constr(min_length=1)
    client_email: EmailStr
    client_message: constr(min_length=1)
    honeypot_field_fullname: Optional[str] = None
    honeypot_field_organization: Optional[str] = None

# Initialize boto3 clients
ses = boto3.client('ses', region_name='eu-central-1')
ssm = boto3.client('ssm', region_name='eu-central-1')
email_for_sending = ssm.get_parameter(Name='/portfolio/email_for_sending')['Parameter']['Value']
email_for_receiving = ssm.get_parameter(Name='/portfolio/email_for_receiving')['Parameter']['Value']

logger = logging.getLogger()
logger.setLevel(logging.INFO)
def lambda_handler(event, context):
    
    try:
        body = json.loads(event['body'])
        form_data = FormData(**body)
        
        # Checking if the honeypot fields are not empty
        if form_data.honeypot_field_fullname or form_data.honeypot_field_organization:
            return {
                'statusCode': 400,
                'body': json.dumps({'message': 'Honeypot fields must be empty'})
            }

        # Sending mail using Amazon SES
        ses.send_email(
            Source=email_for_sending,
            Destination={
                'ToAddresses': [email_for_receiving]
            },
            Message={
                'Subject': {
                    'Data': 'New Form Submission from Portfolio Website'
                },
                'Body': {
                    'Html': {
                        'Data': f"""
                        <h1 style="color: blue;">New Form Submission</h1>
                        <p><strong>Name of client:</strong> {form_data.client_name}</p>
                        <p><strong style="color: green;">Client email:</strong> {form_data.client_email}</p>
                        <p><strong style="color: green;">Message from client on portfolio website:</strong></p>
                        <p>{form_data.client_message}</p>
                        """
                    }
                }
            }
        )

        # Determining the origin of the request correctly
        origin = event['headers'].get('origin', '')
        logging.info(f"Origin: {origin}")
        # Defining response headers
        allowed_origins = ['https://ivanravic.com', 'https://www.ivanravic.com']

        # Checking if the origin is allowed
        if origin in allowed_origins:
            response_headers = {
                'Access-Control-Allow-Origin': origin,
                'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token, X-Amz-Invocation-Type',
                'Access-Control-Allow-Methods': "POST,OPTIONS,GET"
            }
        else:
            return {
                'statusCode': 403,
                'body': json.dumps({'message': 'Origin not allowed'})
            }

        return {
            'statusCode': 200,
            'headers': response_headers,
            'body': json.dumps({'message': 'Email sent successfully, I will get back to you soon!'})
        }

    except ValidationError as e:
        return {
            'statusCode': 400,
            'body': json.dumps({'message': 'Validation failed', 'errors': e.errors()})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'An unexpected error occurred', 'error': str(e)})
        }
