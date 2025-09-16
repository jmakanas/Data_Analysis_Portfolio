 -- View data
SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

 -- Change Date formatting

SELECT SaleDate, CONVERT(Date,SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add SaleDateNew Date;

UPDATE NashvilleHousing
SET SaleDateNew= CONVERT(Date, SaleDate)

 -- Fill null PropertyAddress data

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
	WHERE PropertyAddress is null
	ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
 FROM PortfolioProject.dbo.NashvilleHousing a 
 JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null

 -- Separate PropertyAddress into individual columns of PropertyAddressStreet and PropertyAddressCity

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address , 
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertyAddressStreet Nvarchar(255);

ALTER TABLE NashvilleHousing
Add PropertyAddressCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertyAddressStreet = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

UPDATE NashvilleHousing
SET PropertyAddressCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

 -- Separate OwnerAddress into individual columns of OwnerAddressStreet, OwnerAdressCity, and OwnerAddressState
ALTER TABLE NashvilleHousing
Add OwnerAddressStreet Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerAddressStreet = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

ALTER TABLE NashvilleHousing
Add OwnerAddressCity Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerAddressCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

ALTER TABLE NashvilleHousing
Add OwnerAddressState Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerAddressState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

-- Change SoldAsVacant column into only two distinct values of Yes and No

SELECT DISTINCT(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = 
CASE WHEN SoldAsVacant= 'Y' THEN 'Yes'
	WHEN SoldAsVacant= 'N' THEN 'No'
	ELSE SoldAsVacant
	END

-- Delete columns that are unnecessary because of the columns we created

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate, PropertyAddress, OwnerAddress, TaxDistrict

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing