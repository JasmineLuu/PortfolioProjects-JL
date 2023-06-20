--Cleaning Data in SQL Queries
 
select saledateconverted 
from [Nashville Housing Data] 


update [Nashville Housing Data]
set SaleDate = convert (date, SaleDate)


Alter table [Nashville Housing Data]
Add SaledateConverted Date

update [Nashville Housing Data]
set SaledateConverted = convert (date, SaleDate)

Alter table [Nashville Housing Data]
drop Convertdate

-- Populate Property Address data

select PropertyAddress
from [Nashville Housing Data] 
where PropertyAddress is null

select a.[UniqueID ], a.ParcelID, a.PropertyAddress, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from [Nashville Housing Data] a
join [Nashville Housing Data] b
on a.[UniqueID ]<>b.[UniqueID ] and a.ParcelID=b.ParcelID
where a.PropertyAddress is null

update a
set propertyaddress = isnull(a.PropertyAddress,b.PropertyAddress)
from [Nashville Housing Data] a
join [Nashville Housing Data] b
on a.[UniqueID ]<>b.[UniqueID ] and a.ParcelID=b.ParcelID
where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)

select substring(propertyaddress, 1, charindex(',',PropertyAddress) -1) as Address,
substring(propertyaddress, charindex(',',PropertyAddress) +1, len(propertyaddress)) as City
from [Nashville Housing Data]

alter table [Nashville Housing Data]
add PrppertySplitAddress nvarchar(255)

Update [Nashville Housing Data]
Set PrppertySplitAddress = substring(propertyaddress, 1, charindex(',',PropertyAddress) -1)

alter table [Nashville Housing Data]
add ProppertySplitCity nvarchar(255)

Update [Nashville Housing Data]
Set ProppertySplitCity = substring(propertyaddress, charindex(',',PropertyAddress) +1, len(propertyaddress))

select *
from [Nashville Housing Data]


select OwnerAddress
from [Nashville Housing Data]

select
parsename(Replace(owneraddress,',','.'), 3),
parsename(Replace(owneraddress,',','.'), 2),
parsename(Replace(owneraddress,',','.'), 1)
from [Nashville Housing Data]

alter table [Nashville Housing Data]
add OwnerSplitAddress nvarchar(255)

Update [Nashville Housing Data]
set OwnerSplitAddress = parsename(Replace(owneraddress,',','.'), 3)

alter table [Nashville Housing Data]
add OwnerSplitCity nvarchar(255)

Update [Nashville Housing Data]
set OwnerSplitCity = parsename(Replace(owneraddress,',','.'), 2)

alter table [Nashville Housing Data]
add OwnerSplitState nvarchar(255)

Update [Nashville Housing Data]
set OwnerSplitState = parsename(Replace(owneraddress,',','.'), 1)


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select distinct(SoldAsVacant), count(SoldAsVacant)
from [Nashville Housing Data]
group by SoldAsVacant
order by 2

Select SoldAsVacant
, case when SoldAsVacant='Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
from [Nashville Housing Data]

Update [Nashville Housing Data]
set SoldAsVacant = case when SoldAsVacant='Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end


-- Remove Duplicates

Select *,
row_number() 
over (partition by parcelID, Propertyaddress, saledate, salePrice, legalreference
order by parcelid)
from [Nashville Housing Data]




with Duplicateditems as
(
Select *,
row_number() 
over (partition by parcelID, Propertyaddress, saledate, salePrice, legalreference
order by Uniqueid) Rownum
from [Nashville Housing Data]
) 

Select *
from Duplicateditems
where Rownum>1



with Duplicateditems as
(
Select *,
row_number() 
over (partition by parcelID, Propertyaddress, saledate, salePrice, legalreference
order by Uniqueid) Rownum
from [Nashville Housing Data]
) 

Delete
from Duplicateditems
where Rownum>1

-- Delete Unused Columns


Alter table [Nashville Housing Data]
drop column SaleDate, OwnerAddress, TaxDistrict

Alter table [Nashville Housing Data]
drop column propertyaddress

select *
from [Nashville Housing Data]