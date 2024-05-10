Install-Module Az 
#$vaultName = "BuhlerBkpVault"
#create backup vault
#Define Parameter
$ResourceGroup = 'Bühler_task_RG' 
$Location = "centralus"
$tagName1 = "ResourceOwner"
$tagValue1 = "atlas"
$tagName2 = "ResourceOwnerType"
$tagValue2 = "infrastructure"
$tagName3 = "ResourceDescription"
$tagValue3 = "Blob Storage Backup ensure"
$tagName4 = "Environment"
$tagValue4 = "dev"


# Create a dictionary for new tags (modify as needed)
$newTags = @{}
$newTags[$tagName1] = $tagValue1
$newTags[$tagName2] = $tagValue2
$newTags[$tagName3] = $tagValue3
$newTags[$tagName4] = $tagValue4


#Create Backup vault ,can efficiently manage backups for multiple storage accounts
$storageSetting = New-AzDataProtectionBackupVaultStorageSettingObject -Type GeoRedundant -DataStoreType VaultStore
New-AzDataProtectionBackupVault -ResourceGroupName $ResourceGroup -VaultName "TestBkpVault" -Location $Location -StorageSetting $storageSetting -Tag $newTags
$TestBkpVault = Get-AzDataProtectionBackupVault -ResourceGroupName $ResourceGroup -VaultName "TestBkpVault"

$TestBKPVault | Format-List


#IAM ROLE ASSIGN FOR BACK VAULT
# Get the Backup Vault resource ID
$vaultResourceId = "/subscriptions/e45492dd-089c-45a0-b1dd-1226649f3176/resourceGroups/Bühler_task_RG/providers/Microsoft.
DataProtection/backupVaults/TestBkpVault"                  
#enter user object id
$userObjectId3 = Read-Host "enter User3- object id"
Write-Host "User2-Objectid:$userObjectId3"                   

# Get the user object (replace 'user@example.com' with the actual user)
$user = Get-AzADUser -UserPrincipalName "luka@savitapadarya22gmail.onmicrosoft.com"
Write-Host ($user)
# Assign the Backup Operator role
New-AzRoleAssignment -RoleDefinitionName "Backup MUA Admin" -Scope(Get-AzDataProtectionBackupVault -ResourceGroupName $ResourceGroup -VaultName "TestBkpVault").Id -PrincipalId $userObjectId3
