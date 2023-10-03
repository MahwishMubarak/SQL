--Data Cleaning Portfolio Project by SQL Queries
-- Standarise Date Format
Select SalesDateConverted
from [DataCleaning Project]..[NashVilleHousing]
--UPDATE [NashVille Housing]
 --set Saledate = CONVERT(DATE,saledate)
 ALTER TABLE NashVilleHousing
 Add SalesDateConverted Date;

 Update NashVilleHousing
 Set SalesDateConverted = CONVERT(DATE,saledate)


--Populating Property Address
Select a.ParcelID, a.PropertyAddress, b.PropertyAddress, b.ParcelID, ISNULL(a.PropertyAddress,b.PropertyAddress)
from [DataCleaning Project]..[NashVilleHousing] a
join [DataCleaning Project]..[NashVilleHousing] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from [DataCleaning Project]..[NashVilleHousing] a
join [DataCleaning Project]..[NashVilleHousing] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]

-- Breaking out address into individual columns(Address,City,State)
Select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) Address
, Substring(PropertyAddress,CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) City
From [DataCleaning Project]..NashVilleHousing

ALTER TABLE [DataCleaning Project]..NashVilleHousing
 Add PropertySplitAddress nvarchar(255);

 Update [DataCleaning Project]..NashVilleHousing
 Set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1)

 ALTER TABLE [DataCleaning Project]..NashVilleHousing
 Add PropertySplitCity nvarchar(255);

 Update [DataCleaning Project]..NashVilleHousing
 Set PropertySplitCity = Substring(PropertyAddress,CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

 Select
 parsename (Replace(OwnerAddress,',','.'),3)
  , parsename (Replace(OwnerAddress,',','.'),2)
  , parsename (Replace(OwnerAddress,',','.'),1)
 from [DataCleaning Project]..NashVilleHousing

 ALTER TABLE [DataCleaning Project]..NashVilleHousing
 Add OwnerSplitAddress nvarchar(255);

 Update [DataCleaning Project]..NashVilleHousing
 Set OwnerSplitAddress = parsename (Replace(OwnerAddress,',','.'),3)

 ALTER TABLE [DataCleaning Project]..NashVilleHousing
 Add OwnerSplitCity nvarchar(255);

 Update [DataCleaning Project]..NashVilleHousing
 Set  OwnerSplitCity = parsename (Replace(OwnerAddress,',','.'),2)

 ALTER TABLE [DataCleaning Project]..NashVilleHousing
 Add  OwnerSplitState nvarchar(255);

-- Change Y to Yes and N to No in SoldAsVacant Field
Select distinct(SoldAsVacant), COUNT( SoldAsVacant)
from [DataCleaning Project]..NashVilleHousing
Group by SoldAsVacant
order by 2
 
 Select SoldAsVacant
,Case When SoldAsVacant='Y' Then 'Yes'
  When SoldAsVacant='N' Then 'No'
  Else SoldAsVacant
End
 from [DataCleaning Project]..NashVilleHousing

 Update[DataCleaning Project]..NashVilleHousing
 SET SoldAsVacant = Case When SoldAsVacant='Y' Then 'Yes'
  When SoldAsVacant='N' Then 'No'
  Else SoldAsVacant
End

-- Remove Duplicates
with RowNumCTE AS(
Select *,
ROW_NUMBER() over (
   Partition by ParcelID,
      PropertyAddress,
	  SaleDate,
	  SalePrice,
	  LegalReference
	  Order by UniqueID
	  ) row_num

from [DataCleaning Project]..NashVilleHousing
)
Delete 
from RowNumCTE
where row_num > 1
--Select * 
  --from RowNumCTE
   --where row_num > 1
   
-- Delete unsued columns 
Alter TABLE [DataCleaning Project]..NashVilleHousing
Drop Column Owneraddress,PropertyAddress,saledate
Select * 
From [DataCleaning Project]..NashVilleHousing
Alter TABLE [DataCleaning Project]..NashVilleHousing
drop column TaxDistrict
