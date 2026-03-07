output "bucket1_id" {
  description = "ID of the first S3 bucket"
  value       = azurerm_storage_account.storage1.id
}

output "bucket2_id" {
  description = "ID of the second S3 bucket"
  value       = azurerm_storage_account.storage2.id
}

