
Select *
from [Portfolio project]..Nashvillehousing;

 
 --CONVERTING DATE TO STANDARD FORMAT


Select SaleDateConverted, CONVERT(Date, SaleDate)
from [Portfolio project]..Nashvillehousing;

 ALTER TABLE Nashvillehousing 
 ADD SaleDateConverted Date

UPDATE Nashvillehousing
 SET Nashvillehousing.SaleDateConverted = CONVERT(Date, SaleDate )



 --populating Empty property addresses
 
 Select PropertyAddress
from [Portfolio project]..Nashvillehousing
where  PropertyAddress is null

 Select *
from [Portfolio project]..Nashvillehousing
order by ParcelID


 Select s.ParcelID, s.PropertyAddress, o.ParcelID, o.PropertyAddress, ISNULL(s.PropertyAddress,o.PropertyAddress)
from [Portfolio project]..Nashvillehousing s
JOIN [Portfolio project]..Nashvillehousing o
   on s.ParcelID = o.ParcelID
   AND s.[UniqueID ] <> o.[UniqueID ]
where s.PropertyAddress is null


UPDATE s
SET PropertyAddress = ISNULL(s.PropertyAddress,o.PropertyAddress)
from [Portfolio project]..Nashvillehousing s
JOIN [Portfolio project]..Nashvillehousing o
   on s.ParcelID = o.ParcelID
   AND s.[UniqueID ] <> o.[UniqueID ]
 where s.PropertyAddress is null


 --Separating Address into individual columns

 Select PropertyAddress
from [Portfolio project]..Nashvillehousing
--order by ParcelID


Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress ) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)  +1, LEN(PropertyAddress)) as Address
from [Portfolio project]..Nashvillehousing


ALTER TABLE Nashvillehousing 
 ADD PropertySplitAddress Nvarchar(255)

UPDATE Nashvillehousing
 SET Nashvillehousing.PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress ) -1) 


 ALTER TABLE Nashvillehousing 
 ADD PropertySplitCity Nvarchar(255)

UPDATE Nashvillehousing
 SET Nashvillehousing.PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)  +1, LEN(PropertyAddress))
 


  Select OwnerAddress
 from [Portfolio project]..Nashvillehousing

 Select 
 PARSENAME(REPLACE(OwnerAddress,',', '.'),3),
 PARSENAME(REPLACE(OwnerAddress,',', '.'), 2),
 PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)
 from [Portfolio project]..Nashvillehousing


 ALTER TABLE Nashvillehousing 
 ADD OwnerSplitAddress Nvarchar(255)

UPDATE Nashvillehousing
 SET Nashvillehousing.OwnerSplitAddress =  PARSENAME(REPLACE(OwnerAddress,',', '.'),3)


 ALTER TABLE Nashvillehousing 
 ADD OwnerSplitCity Nvarchar(255)

UPDATE Nashvillehousing
 SET Nashvillehousing.OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.'), 2)


 ALTER TABLE Nashvillehousing 
 ADD OwnerSplitState Nvarchar(255)

UPDATE Nashvillehousing
 SET Nashvillehousing.OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)

Select *
from [Portfolio project]..Nashvillehousing



-- Changing N and Y to YES and NO SoldAsVacant Column

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
from [Portfolio project]..Nashvillehousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
from [Portfolio project]..Nashvillehousing



UPDATE Nashvillehousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END


--Removing Duplicate In the Dataset

WITH RowNumCTE as 
(
SElect *, 
    ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalREference
				 ORDER BY 
				 UniqueID)
				 row_num
from [Portfolio project]..Nashvillehousing
)
DELETE 
from RowNumCTE
Where row_num > 1


--DElETING UNUSED COLUMNS

ALTER TABLE [Portfolio project]..Nashvillehousing
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict 

ALTER TABLE [Portfolio project]..Nashvillehousing
DROP COLUMN SaleDate 

Select *
from [Portfolio project]..Nashvillehousing