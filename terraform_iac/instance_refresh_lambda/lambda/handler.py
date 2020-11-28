import json
import boto3
from botocore.exceptions import ClientError
import logging
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)
#ec2_client = boto3.client('ec2')
asg_client = boto3.client('autoscaling')
region = os.environ['AWS_REGION']
ssm = boto3.client('ssm',region )
ec2_client = boto3.client('ec2', region_name = region)

def get_ami_id_from_ssmps(ssmpsname):
    response = ssm.get_parameters(
        Names=[ssmpsname]
    )
    for parameter in response['Parameters']:
        return parameter['Value']

def check_ami_exists(ami_id, region): 
    response = ec2_client.describe_images(ImageIds=[
        ami_id,
    ])
    print(response)
    for image in response['Images']:
      if ami_id == image['ImageId']:
        return True
    return False

def get_launch_template_id(asg_name):
    try:
        asg = asg_client.describe_auto_scaling_groups(
            AutoScalingGroupNames=[asg_name])
        # Make sure the Auto Scaling group exists
        print(asg)
        if len(asg['AutoScalingGroups']) == 0:
            raise ValueError("Autoscaling group  : {} not found.".format(asg_name))
        asg_details = asg['AutoScalingGroups'][0]
        # Check if template exist into ASG
        if 'LaunchTemplate' in asg_details.keys():
            template_id = asg_details['LaunchTemplate']['LaunchTemplateId']
            return template_id
        elif 'MixedInstancesPolicy' in asg_details.keys():
            template_id = asg_details['MixedInstancesPolicy']['LaunchTemplate']['LaunchTemplateSpecification']['LaunchTemplateId']
            return template_id
        else:
            return None

    except ClientError as exp:
        logging.error("Error occured while getting template id from ASG.")
        raise exp
    
def create_new_launch_template(lt_id, ami_id):
    try:
        launch_templates = ec2_client.describe_launch_templates(
            LaunchTemplateIds=[lt_id])
        latest_version = launch_templates['LaunchTemplates'][0]['LatestVersionNumber']
        response = ec2_client.create_launch_template_version(
             LaunchTemplateId=lt_id,
             SourceVersion = str(latest_version),
             LaunchTemplateData={'ImageId': ami_id})
        logging.info("New Version of Launch Template created successfully.")
        print(response)
        return response['LaunchTemplateVersion'][0]['VersionNumber']
    except ClientError as exp:
        logging.error("Error occured during new launch template creation.")
        raise exp

def start_asg_instance_refresh(asg_name):
    try:
        response = client.start_instance_refresh(
                     AutoScalingGroupName=asg_name,
                     Strategy='Rolling',
                     Preferences={
                                'MinHealthyPercentage': 90,
                                'InstanceWarmup': 60  ##1 min to wait before next replacement.
                     })
    except ClientError as exp:
        logging.error("Error occured during instance refresh start.")
        raise exp
def lambda_handler(event, context):
    print(event)
    msg=event['detail']
    print(msg)
    ssmpsname=msg['name']
    print(ssmpsname)
    ami_id = get_ami_id_from_ssmps(ssmpsname)
    print(ami_id)
    ## Validate AMI ID
    check_status = check_ami_exists(ami_id, region)
    if !check_status 
        return("No AMI id found for region {}".format(
               region))

    ## Get ASG Name           
    asg_name = os.environ['WebServerASGName']
    ## Get LT from ASG
    lt_id = get_launch_template_id(asg_name)
    if lt_id is None:
        raise ValueError("No Launch template found in ASG: {}".format(asg_name))

    ## Update LT
    new_version_id = create_new_launch_template(lt_id,ami_id)
    print("New Template Version number: {}".format(new_version_id))
    ## Trigger Instance Refresh
    start_asg_instance_refresh(asg_name)
    return {
        'statusCode': 200,
        'body': json.dumps('Instance Refresh Lambda is Successful.')
    }
