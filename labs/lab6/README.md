# ec2 with higher permissions

Setup aws environment

```sh
terraform init
terraform apply -auto-approve
```

Console password setup

```sh
aws iam create-login-profile --user-name demo --password 'My!User1Login8P@ssword'
```

https://docs.aws.amazon.com/codedeploy/latest/userguide/instances-ec2-create.html#instances-ec2-create-cli

Create a key pair to allow you to ssh into the instance.

Attach the role () to the instance

```sh
ssh ec2-user@54.236.48.188 -i foo-demo.pem

aws iam attach-user-policy --user-name demo --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
```

https://aws.amazon.com/premiumsupport/knowledge-center/install-ssm-agent-ec2-linux/
