# AWS POLICY VERSION

Setup aws environment

```sh
terraform init
terraform apply -var versionVar=true -auto-approve

tf apply -var versionVar=false -auto-approve
```

Console password setup

```sh
aws iam create-login-profile --user-name demo --password 'My!User1Login8P@ssword'
```
