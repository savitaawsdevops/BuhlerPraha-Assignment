$policyDefn = Get-AzDataProtectionPolicyTemplate -DatasourceType AzureBlob
$policyDefn | Format-List

$policyDefn.PolicyRule | Format-List

New-AzDataProtectionBackupPolicy -ResourceGroupName $ResourceGroup -VaultName "TestBkpVault" -Name "ProductionPolicy" -Policy $policyDefn

