## RDS

Terraform files to create RDS instances:

- RDS instance (mysql, mariadb, postgres)
- Security Group for RDS traffic (3306, 5432)

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

### Outputs

```sh
tofu output
```
```go
db_hosts = {
  "db_mysql" = "<host-mysql>"
  "db_postgres" = "<host-psql>"
}

```

### Additional Commands

- To get the versions by db engine:
```sh
aws rds describe-db-engine-versions --engine postgres --query "*[].{Engine:Engine,EngineVersion:EngineVersion}" --output text

aws rds describe-db-engine-versions --engine mysql --query "*[].{Engine:Engine,EngineVersion:EngineVersion}" --output text

aws rds describe-db-engine-versions --engine mariadb --query "*[].{Engine:Engine,EngineVersion:EngineVersion}" --output text
```

- To connect to the remote db:
	- Mysql / MariaDB:
	```sh
	curl -o global-bundle.pem https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem
	mysql -h <host> -P 3306 -u <user> -p --ssl-verify-server-cert --ssl-ca=./global-bundle.pem
	```
 	- Postgres:
	```sh
	curl -o global-bundle.pem https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem
	RDSHOST="<host>" 
	psql "host=$RDSHOST port=5432 dbname=<db> user=<user> sslmode=verify-full sslrootcert=./global-bundle.pem"
	```

### References

- [Aws Postgres Versions](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/PostgreSQL.Concepts.General.DBVersions.html)
- [Aws MySQL Versions](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/MySQL.Concepts.VersionMgmt.html)
- [Aws MariaDB Versions](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/MariaDB.Concepts.VersionMgmt.html)
