#!/usr/bin/env sh

for email in $sns_emails; do
  echo $email
  echo $aws_profile
  echo $sns_arn
  echo $region
  aws --profile "$aws_profile" sns subscribe --topic-arn "$sns_arn" --protocol email --notification-endpoint "$email" --region "$region"
done