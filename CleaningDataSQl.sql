/*   
		cleaning data in SQL Queries  */

SELECT *
FROM Sheet1$

SELECT SaleDateConverted, CONVERT(DATE,SaleDate)
FROM Sheet1$

UPDATE Sheet1$
SET SaleDate = CONVERT(DATE,SaleDate)


ALTER TABLE Sheet1$ 
ADD SaleDateConverted Date;

UPDATE Sheet1$
SET SaleDateConverted = CONVERT(DATE,SaleDate)


--Populate Property Address data

SELECT *
FROM Sheet1$
--Where PropertyAddress is null
order by ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Sheet1$ a join Sheet1$ b 
on a.ParcelID = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
--Where a.PropertyAddress is null

UPDATE a 
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Sheet1$ a join Sheet1$ b on a.ParcelID = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--Breaking out Address  into individual columns ( address,  city, state)

SELECT PropertyAddress
FROM Sheet1$
--Where PropertyAddress is null
--order by ParcelID


SELECT
SUBSTRING (PropertyAddress,  1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1 ,LEN(PropertyAddress)) as Address
from Sheet1$




ALTER TABLE Sheet1$ 
ADD PropertySplitAddress NVARCHAR(255);

UPDATE Sheet1$
SET PropertySplitAddress = SUBSTRING (PropertyAddress,  1, CHARINDEX(',', PropertyAddress)-1) 


ALTER TABLE Sheet1$ 
ADD PropertySplitCity NVARCHAR(255);

UPDATE Sheet1$
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1 ,LEN(PropertyAddress)) 


SELECT *
FROM Sheet1$

SELECT Owneraddress from Sheet1$

SELECT
PARSENAME(REPLACE(Owneraddress, ',','.'), 3),
PARSENAME(REPLACE(Owneraddress, ',','.'), 2),
PARSENAME(REPLACE(Owneraddress, ',','.'), 1)
from Sheet1$



ALTER TABLE Sheet1$ 
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE Sheet1$
SET OwnerSplitAddress = PARSENAME(REPLACE(Owneraddress, ',','.'), 3)




ALTER TABLE Sheet1$ 
ADD OwnerSplitCity NVARCHAR(255);

UPDATE Sheet1$
SET OwnerSplitCity = PARSENAME(REPLACE(Owneraddress, ',','.'), 2)


ALTER TABLE Sheet1$ 
ADD OwnerSplitState NVARCHAR(255);

UPDATE Sheet1$
SET OwnerSplitState = PARSENAME(REPLACE(Owneraddress, ',','.'), 1)

SELECT * FROM Sheet1$

-- CHANGE Y AND N TO YES AND NO IN SOLD AS VACANT FIELD

SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM Sheet1$ 
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant ,
	CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
		WHEN SoldAsVacant = 'N' THEN 'NO'
		ELSE SoldAsVacant
		END
FROM Sheet1$ 


UPDATE Sheet1$
SET  SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
		           WHEN SoldAsVacant = 'N' THEN 'NO'
		           ELSE SoldAsVacant
	           END

--REMOVE DUPLICATES 

SELECT * FROM Sheet1$


with RowNumCTE AS(
SELECT * ,
ROW_NUMBER() OVER(

	PARTITION BY ParcelID, PropertyAddress, SalePrice,SaleDate ,LegalReference
	ORDER BY UniqueID
	)row_num
FROM Sheet1$
)
--delete  from RowNumCTE
select *
from RowNumCTE
where row_num > 1
--order by PropertyAddress


--Delete unused Columns

SELECT * FROM Sheet1$

ALTER TABLE Sheet1$
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Sheet1$
DROP COLUMN SaleDAte
