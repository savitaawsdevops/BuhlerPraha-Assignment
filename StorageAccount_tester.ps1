Install-Module -Name Pester -Force -SkipPublisherCheck
Import-Module Pester
Import-Module Az.Storage
$StorageHT = @{
    ResourceGroupName = $ResourceGroup
    Name              = 'prodbuhler'
    SkuName           = 'Standard_GRS'
    Location          =  $Location
  }
Describe "Azure Blob Storage Configuration" {
    It "should have soft delete enabled" {
     # $container = Get-AzStorageContainer -ResourceGroupName $ResourceGroup -AccountName $StorageAccountName-Error
          $Context = $StorageAccount.Context
     $softDeleteEnabled = $Context.SoftDeleteEnabled 
      Should -BeTrue $softDeleteEnabled -Message "Soft delete is not enabled for blob storage container."
    }

  It "should have versioning enabled" {
   #$serviceProperties = Get-AzStorageServiceProperty -ResourceGroupName $ResourceGroup -StorageAccountName $StorageAccountName
    $versioningEnabled = $Context.Versioning.Enabled
    Should -BeTrue $versioningEnabled -Message "Versioning is not enabled for blob storage."
  }
  It "should have Tags in storage account" {
    Write-Host "Tags:"
$context.Tags | Format-List
}
}




$StorageHT = @{
    ResourceGroupName = $ResourceGroup
    Name              = 'nonprodbuhler'
    SkuName           = 'Standard_GRS'
    Location          =  $Location
  }
Describe "Azure Blob Storage Configuration" {
    It "should have soft delete enabled" {
     # $container = Get-AzStorageContainer -ResourceGroupName $ResourceGroup -AccountName $StorageAccountName-Error
          $Context2 = $StorageAccount.$Context2
     $softDeleteEnabled = $Context2.SoftDeleteEnabled
      Should -BeTrue $softDeleteEnabled -Message "Soft delete is not enabled for blob storage container."
    }

  It "should have versioning enabled" {
   #$serviceProperties = Get-AzStorageServiceProperty -ResourceGroupName $ResourceGroup -StorageAccountName $StorageAccountName
    $versioningEnabled = $context2.Versioning.Enabled
    Should -BeTrue $versioningEnabled -Message "Versioning is not enabled for blob storage."
  }
}

