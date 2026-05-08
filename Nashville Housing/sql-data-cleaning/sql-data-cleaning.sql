/*
	CLEANING DATA IN SQL QUERIES
*/

SELECT *
FROM [nashville-housing].[dbo].NashvilleHousing;

--- Standardlize Date Format
SELECT SaleDate, CONVERT(Date, SaleDate) AS FormatSaleDate
FROM [nashville-housing].[dbo].NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate);

SELECT SaleDate, SaleDateConverted, CONVERT(Date, SaleDate) AS FormatSaleDate
FROM [nashville-housing].[dbo].NashvilleHousing;


--- Populate Property Address data
SELECT *
FROM [nashville-housing].[dbo].NashvilleHousing
ORDER BY ParcelID;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [nashville-housing].[dbo].NashvilleHousing a
JOIN [nashville-housing].[dbo].NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL;

UPDATE a
SET PropertyAddress  = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [nashville-housing].[dbo].NashvilleHousing a
JOIN [nashville-housing].[dbo].NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL;


--- Breaking out Address into individual columns (Address, City, State)
SELECT PropertyAddress
FROM [nashville-housing].[dbo].NashvilleHousing;

SELECT PropertyAddress,
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS City
FROM [nashville-housing].[dbo].NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1);

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));

SELECT OwnerAddress
FROM [nashville-housing].[dbo].NashvilleHousing;

SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.'),3) AS Address,
	PARSENAME(REPLACE(OwnerAddress, ',', '.'),2) AS City,
	PARSENAME(REPLACE(OwnerAddress, ',', '.'),3) AS State
FROM [nashville-housing].[dbo].NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD OwwnerSplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET OwwnerSplitAddress =  PARSENAME(REPLACE(OwnerAddress, ',', '.'),3);

ALTER TABLE NashvilleHousing
ADD OwwnerSplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET OwwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2);

ALTER TABLE NashvilleHousing
ADD OwwnerSplitState NVARCHAR(255);

UPDATE NashvilleHousing
SET OwwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1);

SELECT * 
FROM [nashville-housing].[dbo].NashvilleHousing;

--- Change Y and N to Yes and No in "SoldAsVacant"
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [nashville-housing].[dbo].NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	     WHEN SoldAsVacant = 'N' THEN 'No' 
		 ELSE SoldAsVacant
		 END
FROM [nashville-housing].[dbo].NashvilleHousing;

UPDATE NashvilleHousing
SET SoldAsVacant = (CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
						 WHEN SoldAsVacant = 'N' THEN 'No' 
						 ELSE SoldAsVacant
						 END);

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [nashville-housing].[dbo].NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2; 


--- Remove Duplicates
WITH RowNumCTE AS(
	SELECT *,
		ROW_NUMBER() OVER (
			PARTITION BY ParcelID,
						 PropertyAddress,
	       				 SalePrice,
			   			 SaleDate,
			     	     LegalReference
					ORDER BY UniqueID
			) AS row_num
	FROM [nashville-housing].[dbo].NashvilleHousing
)
DELETE
FROM RowNumCTE
WHERE row_num > 1;

--- Delete Unused Columns
SELECT * 
FROM [nashville-housing].[dbo].NashvilleHousing;

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict, SaleDate;
