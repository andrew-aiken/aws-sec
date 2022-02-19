# Lambda Lab

## Setup the environment

Configured to use the aws profile `default` when building the infrastructure.

Instructions on how to setup the cli [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

```sh
terraform init
terraform apply -auto-approve
```

Copy the outputs that look like similar to the following and past them into a new terminal shell.

```sh
export AWS_ACCESS_KEY_ID=XXXXXXXXXX

export AWS_SECRET_ACCESS_KEY=YYYYYYYYYYYYYYYYY
```

## Destroy

All resources created by you outside of the terraform is your responsibility to remove.

Make sure to remove roles attacked to user account before running the following command, else it will fail.

```sh
terraform destroy -auto-approve
```
