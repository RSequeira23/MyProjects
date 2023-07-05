-- Cleaning data in SQL 

Select *
From PortfolioProject2..NashvilleHousing

-- Standardize date format

Select SaleDateConverted, Convert(Date, Saledate)
From PortfolioProject2..NashvilleHousing

--Setting on table
Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = Convert(Date, Saledate)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Populate property address Data

Select one.ParcelID, one.PropertyAddress, two.ParcelID, two.PropertyAddress, IsNull(one.PropertyAddress,two.PropertyAddress)
From PortfolioProject2..NashvilleHousing as one
Join PortfolioProject2..NashvilleHousing as two
    on one.ParcelID = two.ParcelID
	And one.[UniqueID ] <> two.[UniqueID ]
Where one.PropertyAddress is Null

Update one
Set PropertyAddress = IsNull(one.PropertyAddress,two.PropertyAddress)
From PortfolioProject2..NashvilleHousing as one
Join PortfolioProject2..NashvilleHousing as two
    on one.ParcelID = two.ParcelID
	And one.[UniqueID ] <> two.[UniqueID ]
Where one.PropertyAddress is Null
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Breaking out  property address into individual columns (Address, city, state)
Select PropertyAddress
From PortfolioProject2..NashvilleHousing

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) As Address
From PortfolioProject2..NashvilleHousing

-- Setting on tables now

Alter Table NashvilleHousing
Add PropertyDivideAddress Nvarchar(255);

Update NashvilleHousing
SET PropertyDivideAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter Table NashvilleHousing
Add PropertyDivideCity Nvarchar(255);

Update NashvilleHousing
SET PropertyDivideCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

-- Checking if worked
Select * 
From PortfolioProject2..NashvilleHousing

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Breaking out  Owner address into individual columns (Address, city, state)

Select Owneraddress
From PortfolioProject2..NashvilleHousing

Select PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
From PortfolioProject2..NashvilleHousing

-- Setting on tables now

Alter Table NashvilleHousing
Add OwnerDivideAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerDivideAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)

Alter Table NashvilleHousing
Add OwnerDivideCity Nvarchar(255);

Update NashvilleHousing
SET OwnerDivideCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter Table NashvilleHousing
Add OwnerDivideState Nvarchar(255);

Update NashvilleHousing
SET OwnerDivideState = PARSENAME(Replace(OwnerAddress,',','.'),1)

-- Checking if worked
Select *
From PortfolioProject2..NashvilleHousing

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Change Y & N to Yes or No from "Sold as Vacant"

Select SoldAsVacant,
Case when soldAsVacant = 'Y' THEN 'Yes'
WHEN SoldASVacant = 'N' THEN 'No'
ELSE SoldAsVacant
End
From PortfolioProject2..NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = 
Case when soldAsVacant = 'Y' THEN 'Yes'
WHEN SoldASVacant = 'N' THEN 'No'
ELSE SoldAsVacant
End

-- Checking if worked
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject2..NashvilleHousing
Group by SoldAsVacant