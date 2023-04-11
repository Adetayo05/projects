/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
  FROM [PortfolioProject].[dbo].[NashileHousing]

  -----------------------------------------------------------------------------

  --Standardize Date Format
  Select saledate,convert(date,saledate) as Sale_Date
  FROM [PortfolioProject].[dbo].[NashileHousing]

  Select saledate,cast(saledate as date) as Sale_Date
  FROM [PortfolioProject].[dbo].[NashileHousing]

  Alter Table [NashileHousing]
  Add SaleDateConverted Date;
  update [NashileHousing]
  set SaleDateConverted = cast(saledate as date)

  Select saledate,SaleDateConverted
  FROM [PortfolioProject].[dbo].[NashileHousing]

-----------------------------------------------------------------------------------------

--Populate property address data
Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,
isnull(a.PropertyAddress,b.PropertyAddress)
  FROM [PortfolioProject].[dbo].[NashileHousing] a
   join [PortfolioProject].[dbo].[NashileHousing] b
   on a.ParcelID = b.ParcelID
   and a.[UniqueID ] <> b.[UniqueID ]
   where a.PropertyAddress is null

update a
set propertyaddress = isnull(a.PropertyAddress,b.PropertyAddress)
FROM [PortfolioProject].[dbo].[NashileHousing] a
   join [PortfolioProject].[dbo].[NashileHousing] b
   on a.ParcelID = b.ParcelID
   and a.[UniqueID ] <> b.[UniqueID ]
   where a.PropertyAddress is null

Select PropertyAddress
  FROM [PortfolioProject].[dbo].[NashileHousing]
  where PropertyAddress is null

----------------------------------------------------------------------------------------------
-- Breaking out Property Address into individual columns (Address, City)
Select substring(PropertyAddress,1,CHARINDEX(',',propertyaddress)-1) as Address,
substring(PropertyAddress,CHARINDEX(',',propertyaddress)+1,LEN(propertyaddress)) as Address
  FROM [PortfolioProject].[dbo].[NashileHousing]

Alter Table [NashileHousing]
Add PptSplitAddress nvarchar(255);

Alter Table [NashileHousing]
Add PptSplitCity nvarchar(255);

update [NashileHousing]
set PptSplitAddress = substring(PropertyAddress,1,CHARINDEX(',',propertyaddress)-1),
PptSplitCity = substring(PropertyAddress,CHARINDEX(',',propertyaddress)+1,LEN(propertyaddress))

-- Breaking out OwnerAddress into individual columns (Address, City, State)
select*
from [NashileHousing]

Alter Table [NashileHousing]
Add OwnerSplitAddress nvarchar(255);

Alter Table [NashileHousing]
Add OwnerSplitCity nvarchar(255);

Alter Table [NashileHousing]
Add OwnerSplitState nvarchar(255);

Update [NashileHousing]
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3),
OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2),
OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

select*
from [NashileHousing]

---------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "SoldAsVacant" field.
select distinct(SoldAsVacant),count(*)
from [NashileHousing]
group by SoldAsVacant

Update [NashileHousing]
 Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
When SoldAsVacant = 'N' Then 'No'
Else SoldAsVacant 
 End

 ------------------------------------------------------------------------------------------------------------------

 -- Remove Duplicates:
With RowNumCTE AS(
 select*,
 ROW_NUMBER() over (
 partition by ParcelId,
 PropertyAddress,
 SalePrice,LegalReference
 order by UniqueId) as row_num
from [NashileHousing]
)
select*
from RowNumCTE
where row_num >1

---Delete
--from RowNumCTE
--where row_num >1

-------------------------------------------------------------------------------------------------------------------

--Delete Unused Columns
Alter Table[NashileHousing]
Drop Column PropertyAddress,OwnerAddress,TaxDistrict,SaleDate

select*
from [NashileHousing]











































