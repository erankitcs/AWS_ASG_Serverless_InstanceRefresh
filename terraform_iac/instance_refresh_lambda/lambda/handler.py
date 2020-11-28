import json
import boto3

#ec2_client = boto3.client('ec2')
#asg_client = boto3.client('autoscaling')
ssm = boto3.client('ssm', 'us-east-1')

def get_ami_id_from_ssmps(ssmpsname):
    response = ssm.get_parameters(
        Names=[ssmpsname]
    )
    for parameter in response['Parameters']:
        return parameter['Value']

def lambda_handler(event, context):
    print(event)
    msg=event['detail']
    print(msg)
    ssmpsname=msg['name']
    print(ssmpsname)
    ami_id=get_ami_id_from_ssmps(ssmpsname)
    print(ami_id)
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
