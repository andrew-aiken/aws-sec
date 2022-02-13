# Solutions / Walk through

Lets start off by viewing what permissions are attached to our user.

Run the following commands while authenticated as demo.

```sh
aws iam list-attached-user-policies --user-name demo

aws iam list-user-policies --user-name demo
```

The first command lists existing policies managed by aws and your account. While the seconds lists inline policies that only exist for the object they are attached too.

Lets look into the following inline policy IAM.

```sh
aws iam get-user-policy --user-name demo --policy-name IAM
```

The second policy **IAM**, has the action **sts:AssumeRole** this allows the user to assume permissions that are attached to the role *OrganizationAccountAccessRole*.

Lets look what permissions the role has.

```sh
aws iam get-role --role-name OrganizationAccountAccessRole

aws iam list-attached-role-policies --role-name OrganizationAccountAccessRole
```

The first command shows general information about the role where the seconds shows the permissions it has access to.

Lets use the permissions the policy has, lets try attaching more permissions to our user.

```sh
aws sts assume-role --role-arn arn:aws:iam::ACCOUNT_ID:role/OrganizationAccountAccessRole --role-session-name demo-user
```

Replace **ACCOUNT_ID** with the 12 digit account id you got from your terraform output.

In a new terminal copy the output from the perviouse aws sts command into the following shell commands.

```sh
export AWS_ACCESS_KEY_ID=XXXXXXXXXXXXXX
# Value from AccessKeyId

export AWS_SECRET_ACCESS_KEY=YYYYYYYYYYYYYYYYYYYYYYYY
# Value from SecretAccessKey

export AWS_SESSION_TOKEN=ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
# Value from SessionToken
```

We can now attach admin permissions to the demo user.

```sh
aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AdministratorAccess --user-name demo

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
