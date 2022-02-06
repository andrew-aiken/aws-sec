# My Admin Friend

Setup aws environment

```sh
terraform init
terraform apply -auto-approve
```

Console password setup

```sh
aws iam create-login-profile --user-name demo --password 'My!User1Login8P@ssword'
```
