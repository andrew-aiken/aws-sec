# Solutions / Walk through

Lets start off by viewing what permissions are attached to our user.

Run the following commands while authenticated as demo.

```sh
aws iam list-attached-user-policies --user-name demo

aws iam list-user-policies --user-name demo
```

The first command lists existing policies managed by aws and your account. While the seconds lists inline policies that only exist for the object they are attached too.

Lets look into the following inline policies.

```sh
aws iam get-user-policy --user-name demo --policy-name consolePassword

aws iam get-user-policy --user-name demo --policy-name IAM
```

The first policy you will see **consolePassword** is added in all labs to allow you to reset your console password.

The second policy **IAM**, has the action **iam:\*** this grant whatever the policy is attached to all permissions the related topic and the **"Resource": "\*"** lets it affect all iam resources.

Lets use the permissions the policy has, lets try attaching more permissions to our user.

```sh
aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AdministratorAccess --user-name demo
```

We can check if that worked.

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
