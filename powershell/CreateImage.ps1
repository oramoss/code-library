******************************************
Create Image of Jump Box...

Sysprep /generalize /shutdown
Set-AzVm -ResourceGroupName "ssv-rg-uks-cg-01" -Name "swpddapjump001" -Generalized

#Set context to dv-sub-01
Set-AzContext -Subscription "fb2c9998-fa9d-4fc8-84cf-128a76b981be"

$sourceVM = Get-AzVM -Name "swpddapjump001" -ResourceGroupName "ssv-rg-uks-cg-01"
$sourceVM

$resourceGroup = Get-AzResourceGroup -Name 'ssv-rg-uks-cg-01' -Location 'UkSouth'
$resourceGroup

$gallery = Get-AzGallery -GalleryName 'ssvacguks01' -ResourceGroupName $resourceGroup.ResourceGroupName
$gallery

$tags = @{"Data-classification"="TBC"; "Environment-type"="Prod"; "Application-name"="TBC"; "Cost-centre"="TBC"; "Business-unit-sponsor"="TBC"; "Business-unit"="TBC"; "Application-criticality"="TBC"; "Application-owner"="TBC"}
$tags

$galleryImage=Get-AzGalleryImageDefinition -GalleryName $gallery.Name -ResourceGroupName $resourceGroup.ResourceGroupName -Name 'dap-sha-windows2022'
$galleryImage

$region1 = @{Name='UK South';ReplicaCount=1}
$region2 = @{Name='UK West';ReplicaCount=1}
$targetRegions = @($region1,$region2)
$targetRegions

$galleryImageVersion = New-AzGalleryImageVersion -GalleryImageDefinitionName $galleryImage.Name -GalleryImageVersionName '2.0.0' -GalleryName $gallery.Name -ResourceGroupName $resourceGroup.ResourceGroupName -Location $resourceGroup.Location -TargetRegion $targetRegions -SourceImageVMId $sourceVM.Id.ToString() -PublishingProfileEndOfLifeDate '2030-12-01' -Tag $tags
$galleryImageVersion

******************************************


#Set context to dv-sub-01
Set-AzContext -Subscription "03dfbd19-6ef5-48a1-83bc-3cd1bde2dfeb"

$sourceVM = Get-AzVM -Name "swdvdapadowin001" -ResourceGroupName "SSV-RG-UKS-CG-01"
$sourceVM

Get-VMSecurity -VMName "swdvdapadowin001"
Get-AzVMSecurityProfile -VMName "swdvdapadowin001"


#Set context to ssv-sub-01
Set-AzContext -Subscription "fb2c9998-fa9d-4fc8-84cf-128a76b981be"

$resourceGroup = Get-AzResourceGroup -Name 'ssv-rg-uks-cg-01' -Location 'UkSouth'
$resourceGroup

$gallery = Get-AzGallery -GalleryName 'ssvacguks01' -ResourceGroupName $resourceGroup.ResourceGroupName
$gallery

$tags = @{"Data-classification"="TBC"; "Environment-type"="Prod"; "Application-name"="TBC"; "Cost-centre"="TBC"; "Business-unit-sponsor"="TBC"; "Business-unit"="TBC"; "Application-criticality"="TBC"; "Application-owner"="TBC"}
$tags

$Feature1 = @{Name='SecurityType';Value='None'}
$Features = @($Feature1)

$galleryImage = New-AzGalleryImageDefinition -GalleryName $gallery.Name -ResourceGroupName $resourceGroup.ResourceGroupName -Location $gallery.Location -Name 'dap-adowin-windows2022' -OsState generalized -OsType Windows -Publisher 'Southern-Water' -Offer 'DAP-ADO-Windows-Self-Hosted' -Sku 'Windows2022' -Tag $tags -Feature $Features
$galleryImage=Get-AzGalleryImageDefinition -GalleryName $gallery.Name -ResourceGroupName $resourceGroup.ResourceGroupName -Name 'dap-adowin-windows2022'
$galleryImage

$region1 = @{Name='UK South';ReplicaCount=1}
$region2 = @{Name='UK West';ReplicaCount=2}
$targetRegions = @($region1,$region2)

$galleryImageVersion = New-AzGalleryImageVersion -GalleryImageDefinitionName $galleryImage.Name -GalleryImageVersionName '1.0.0' -GalleryName $gallery.Name -ResourceGroupName $resourceGroup.ResourceGroupName -Location $resourceGroup.Location -TargetRegion $targetRegions -SourceImageVMId $sourceVM.Id.ToString() -PublishingProfileEndOfLifeDate '2030-12-01' -Tag $tags
$galleryImageVersion



#Set context to ssv-sub-01
Set-AzContext -Subscription "fb2c9998-fa9d-4fc8-84cf-128a76b981be"

Set-AzVm -ResourceGroupName "ssv-rg-uks-cg-01" -Name "jeffmosstemp" -Generalized
