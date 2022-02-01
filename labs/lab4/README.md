# Lambda Lab


import boto3
def lambda_handler(event, lambda_context):
    iam = boto3.resource('iam')
    user = iam.User('aaiken')
    response = user.attach_policy(
        PolicyArn='arn:aws:iam::aws:policy/AdministratorAccess'
    )


aws iam create-login-profile --user-name demo --password 'My!User1Login8P@ssword'