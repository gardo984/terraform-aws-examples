
output "db_hosts" {
  value = { for key, data in aws_db_instance.databases : (key) => data.address }
}