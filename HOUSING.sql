-------------------------------------------------------
-------------------------------------------------------
/* CLEANING DATA IN SQL SERVER */
select*  
from dbo.housing

-- Standardize Date Format
select SaleDateConverted, convert(Date,SaleDate)
from dbo.housing

update housing 
set SaleDate = convert(Date,SaleDate)

alter table housing 
add SaleDateConverted Date;

update housing 
set SaleDateConverted = convert(Date, SaleDate)

--Populate Property Address 
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from dbo.housing a 
join dbo.housing b on a.ParcelID=b.ParcelID
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

update a 
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from dbo.housing a 
join dbo.housing b on a.ParcelID=b.ParcelID
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null


-- Breaking out PROPERTY_ADDRESS into Individual Conlumns (Address, City, State)

select*
from dbo.housing

select 
	SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
	SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress)) as CITY
from dbo.housing 

alter table housing 
add PAddress NVARCHAR(255);

update housing 
set PAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table housing 
add PCity nvarchar(255)

update housing 
set PCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress))

-----------------------------------------------------
---------------Breaking out OWNER_ADDRESS------------
select 
PARSENAME(replace(OwnerAddress, ',','.'),3),
PARSENAME(replace(OwnerAddress, ',','.'),2),
PARSENAME(replace(OwnerAddress, ',','.'),1)
from dbo.housing

alter table housing 
add OAddress NVARCHAR(255);

update housing 
set OAddress = PARSENAME(replace(OwnerAddress, ',','.'),3)

alter table housing 
add OCity nvarchar(255)

update housing 
set OCity = PARSENAME(replace(OwnerAddress, ',','.'),2)

alter table housing
add OState nvarchar(255)

update housing
set OState = PARSENAME(replace(OwnerAddress,',','.'),1)

select* 
from dbo.housing


-- Change Y and N to Yes and No in |SoldAsVacant| field
select distinct(SoldAsVacant)
from dbo.housing


select SoldAsVacant,
case 
	when SoldAsVacant = 'N' then 'No'
	when SoldAsVacant = 'Y' then 'Yes'
	else SoldAsVacant
end 
from dbo.housing

update housing 
	set SoldAsVacant = case 
		when SoldAsVacant = 'N' then 'No'
		when SoldAsVacant = 'Y' then 'Yes'
		else SoldAsVacant
	end 


----- Remove Duplicates
with CTE AS (
select *,
	ROW_NUMBER() over 
	(PARTITION BY ParcelID,
					PropertyAddress,
					SaleDate,
					SalePrice
					Order by
						UniqueID) ROW_NUM
FROM dbo.housing)
select* 
FROM CTE
WHERE ROW_NUM >1

-- DELETE UNUSED COLUMNS

select* 
from dbo.housing

alter table housing
drop column OwnerAddress, TaxDistrict
