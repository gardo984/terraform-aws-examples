# Terraform Examples

The following repo contains terraform templates for creating resources on AWS cloud platform.

Some of the services are:

- Ec2
- S3
- RDS

## Prerequisites

```sh
export TF_VAR_access_key=<access-key>
export TF_VAR_secret_key=<secret-key>
```

## Execution Steps

```sh
tofu init
tofu plan
tofu apply
```

## Deletion Steps

```sh
tofu destroy
```