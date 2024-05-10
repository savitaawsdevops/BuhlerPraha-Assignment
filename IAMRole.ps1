# Replace placeholders with your values
$StorageAccountName  = "prodbuhler"
$ResourceGroup  = "Bühler_task_RG"
$roleName1 = "Storage Blob Data Contributor"  # Or other desired role (e.g., "Storage Account Contributor")
$userObjectId1 = Read-Host "enter User1 - object id"
Write-Host "User1-Objectid:$userObjectId1"
$StorageAccountName2 = "nonprodbuhler"
$roleName2 = "Storage Blob Data Contributor"  # Or other desired role
$userObjectId2 = Read-Host "enter User2- object id"
Write-Host "User2-Objectid:$userObjectId2"

# Assign role to storage account 1
New-AzRoleAssignment -RoleDefinitionName $roleName1 -Scope (Get-AzStorageAccount -ResourceGroupName $ResourceGroup  -Name $StorageAccountName ).Id -PrincipalId $userObjectId1

# Assign role to storage account 2
New-AzRoleAssignment -RoleDefinitionName $roleName2 -Scope (Get-AzStorageAccount -ResourceGroupName $ResourceGroup  -Name $StorageAccountName2).Id -PrincipalId $userObjectId2

# Optional: Verification (Get assigned roles for each storage account)
Get-AzRoleAssignment -Scope (Get-AzStorageAccount -ResourceGroupName $ResourceGroup  -Name $StorageAccountName ).Id
Get-AzRoleAssignment -Scope (Get-AzStorageAccount -ResourceGroupName $ResourceGroup  -Name $StorageAccountName2).Id

#Set the storage account encryption settings
$storageEncryptionSettings = Get-AzStorageAccount -ResourceGroupName $ResourceGroup -AccountName $StorageAccountName
$storageEncryptionSettings2 = Get-AzStorageAccount -ResourceGroupName $ResourceGroup -AccountName $StorageAccountName2 
# Output the encryption status

# Enable Server-Side Encryption with Storage Service Encryption (SSE)
$storageEncryptionSettings.EnableEncryption = "StorageServiceEncryption"
$storageEncryptionSettings2.EnableEncryption = "StorageServiceEncryption2"

# Update Storage Account with Encryption enabled
Set-AzStorageAccount -InputObject $storageEncryptionSettings
Set-AzStorageAccount -InputObject $storageEncryptionSettings2

Write-Host "Server-Side Encryption (SSE) enabled for storage account: $StorageAccountName"
$storageEncryptionSettings.Encryption.Services | Format-List
$storageEncryptionSettings2.Encryption.Services | Format-List


