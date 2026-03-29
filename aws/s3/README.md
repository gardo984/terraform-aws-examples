## S3

Terraform files to create S3 buckets containing:

- Lifecycle configuration
- Versioning enabled
- S3 objects (uploads)

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