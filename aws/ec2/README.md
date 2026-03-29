## EC2

Terraform files to create Ec2 instances containing:

- Security Group (as a firewall for traffic).
- Ssh key for authentication.
- User data (commands to be run when launching the instance).

### Execution
```sh
tofu init
tofu plan
tofu apply -auto-approve
```

### Deletion

```sh
tofu destroy -auto-approve
```