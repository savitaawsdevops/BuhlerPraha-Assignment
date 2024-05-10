Install-Module Az
Import-Module Az
Get-AzConfig

 
# Replace 'your_subscription_id' with your actual subscription ID
#subscriptionId = "e45492dd-089c-45a0-b1dd-1226649f3176"
# Connect to Azure using the correct subscription ID
Connect-AzAccount 
$Location = "centralus"
$ResourceGroup = 'Bühler_task_RG' 
$StorageAccountName  = 'prodbuhler'
$SkuName           = 'Standard_GRS'
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


#Update-AzConfig -DefaultSubscriptionForLogin 00000000-0000-0000-0000-000000000000`

#Create resource grp
New-AzResourceGroup -Name $ResourceGroup -Location $Location
##Create Production storage account
New-AzStorageAccount -ResourceGroupName $ResourceGroup -StorageAccountName $StorageAccountName -Location $Location -SkuName $SkuName -Kind StorageV2
#add tags in storage account
$resource = Get-AzStorageAccount -ResourceGroupName $ResourceGroup -StorageAccountName $StorageAccountName
New-AzTag -ResourceId $resource.id -Tag $NewTags

##Enter Access Key to access container
$ContainerName = 'prodbuhler4container' ##create container
 $StorageAccountKey = Read-Host "Enter Access key of Prod-storage account:" 
Write-Host "Succesfully Access Storage Account Name: $StorageAccountName"
   
  ##Add data in storage container
  $context = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey
  New-AzStorageContainer -Name $ContainerName -Context $context
$Blob1HT = @{
    File             = 'C:\Users\pc\Desktop\project\download.jpg'
    Container        = $ContainerName
    Blob             = "download.jpg"
    Context          = $Context
    StandardBlobTier = 'Hot'
  }
  Set-AzStorageBlobContent @Blob1HT #upload 1st file    
   # #upload another file to the Container
   $Blob2HT = @{
    File             = 'C:\Users\pc\Desktop\project\download1.png'
    Container        = $ContainerName
    Blob             = 'download1.png'
    Context          = $Context
    StandardBlobTier = 'Cool'
   }
   Set-AzStorageBlobContent @Blob2HT #uplaod 2nd file
    
  ## upload a file to a container
  $Blob3HT = @{
    File             = 'C:\Users\pc\Desktop\project\download2.png'
    Container        = $ContainerName
    Blob             = 'download2.png'
    Context          = $Context
    StandardBlobTier = 'Hot'
  }
  Set-AzStorageBlobContent @Blob3HT
  ##Enable blob Versioning
  Update-AzStorageBlobServiceProperty -ResourceGroupName $ResourceGroup -StorageAccountName $StorageAccountName -IsVersioningEnabled $true 
  ##Enable Soft Delete of bolb
  Enable-AzStorageBlobDeleteRetentionPolicy -ResourceGroupName $ResourceGroup -StorageAccountName $StorageAccountName -RetentionDays 7
  #while creating backup,there is issue related to cross tanet policy disable.Enable cross tanet policy
  Set-AzStorageAccount -ResourceGroupName $ResourceGroup -StorageAccountName $StorageAccountName -AllowCrossTenantReplication $true 


  #Creating Storage account for Non production 
  $Location = "centralus"
  $ResourceGroup = 'Bühler_task_RG' 
  $SkuName           = 'Standard_GRS'
  $StorageAccountName2  = 'nonprodbuhler'
  ##Create Non-Non-Production storage account
  New-AzStorageAccount -ResourceGroupName $ResourceGroup -StorageAccountName $StorageAccountName2 -Location $Location -SkuName $SkuName -Kind StorageV2 
## Add tags in storage account
$resource2 = Get-AzStorageAccount -ResourceGroupName $ResourceGroup -StorageAccountName $StorageAccountName2
New-AzTag -ResourceId $resource2.id -Tag $NewTags
  #$StorageHT = @{
   #  ResourceGroupName = $ResourceGroup
    # StorageAccountName2 = $StorageAccountName2
    # SkuName           = $SkuName
    # Location          =  $Location
    #} 
    #Crete storage account for Non-Production env
    #$StorageAccount = New-AzStorageAccount @StorageHT
    #$Context = $StorageAccount.Context
    #Assemble Access key  to access container
    ##Enter Access Key to access container
    $ContainerName2= 'nonprodbuhler4container' ##create container
    $StorageAccountKey2 = Read-Host "Enter Access key of NonProd-storage account:" 
    Write-Host "Succesfully Access Storage Account Name: $StorageAccountName2"
     
    ##Add data in container
    $context2 = New-AzStorageContext -StorageAccountName $StorageAccountName2 -StorageAccountKey $StorageAccountKey2
    New-AzStorageContainer -Name $ContainerName2 -Context $context2
  $Blob10HT = @{
      File             = 'C:\Users\pc\Desktop\project\Prague1.jpg'
      Container        = $ContainerName2
      Blob             = " Prague1.jpg "
      Context          = $Context2
      StandardBlobTier = 'Hot'
    }
    Set-AzStorageBlobContent @Blob10HT #upload 1st file    
     ## upload another file to the Container
       # ##upload a file to a container
    
    $Blob20HT = @{
      File             = 'C:\Users\pc\Desktop\project\prague3.jpg'
      Container        = $ContainerName2
      Blob             = 'Prague3.jpg'
      Context          = $Context2
      StandardBlobTier = 'Cool'
    }
    Set-AzStorageBlobContent @Blob20HT
    $Blob40HT = @{
      File             = 'C:\Users\pc\Desktop\project\prague2.jpg'
      Container        = $ContainerName2
      Blob             = 'Prague2.jpg'
      Context          = $Context2
      StandardBlobTier = 'Cool'
    }
    Set-AzStorageBlobContent @Blob40HT
     ##Enable blob Versioning
    Update-AzStorageBlobServiceProperty -ResourceGroupName $ResourceGroup -StorageAccountName $StorageAccountName2 -IsVersioningEnabled $true 
    ##Enable Soft Delete of bolb
    Enable-AzStorageBlobDeleteRetentionPolicy -ResourceGroupName $ResourceGroup -StorageAccountName $StorageAccountName2 -RetentionDays 7
    #while creating backup,there is issue related to cross tanet policy disable
    Set-AzStorageAccount -ResourceGroupName $ResourceGroup -StorageAccountName $StorageAccountName2 -AllowCrossTenantReplication $true 


   
  
  
  
