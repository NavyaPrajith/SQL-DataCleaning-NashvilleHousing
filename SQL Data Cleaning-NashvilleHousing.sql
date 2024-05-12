/*

Cleaning Data in SQL Queries

*/

SELECT *
FROM project02.dbo.NashvilleHousing

----------------------------------------------------------------------------------------------------------------------

--Standardize Date Format

ALTER TABLE NashvilleHousing
ALTER COLUMN saledate DATE;

SELECT saledate
FROM project02.dbo.NashvilleHousing

----------------------------------------------------------------------------------------------------------------------
--Populate Property Address

SELECT propertyaddress
FROM project02.dbo.NashvilleHousing
WHERE propertyaddress is null;

SELECT *
FROM project02.dbo.NashvilleHousing
ORDER BY parcelID   --same parcelIDs have the same propertyaddress. So, we can populate null values

SELECT a.parcelID,a.propertyaddress,b.parcelID,b.propertyaddress,ISNULL(a.propertyaddress,b.propertyaddress)
FROM project02.dbo.NashvilleHousing a
JOIN project02.dbo.NashvilleHousing b
    ON a.parcelID=b.parcelID
	AND a.uniqueID<>b.uniqueID
WHERE a.propertyaddress is null;

UPDATE a
SET propertyaddress=ISNULL(a.propertyaddress,b.propertyaddress)
FROM project02.dbo.NashvilleHousing a
JOIN project02.dbo.NashvilleHousing b
    ON a.parcelID=b.parcelID
	AND a.uniqueID<>b.uniqueID
WHERE a.propertyaddress is null;

----------------------------------------------------------------------------------------------------------------

--Breaking out propertyaddress into individual columns (address,city,state)

SELECT propertyaddress
FROM project02.dbo.NashvilleHousing

SELECT propertyaddress,
SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)) AS address,
CHARINDEX(',',propertyaddress)
FROM project02.dbo.NashvilleHousing

SELECT 
SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) AS address
FROM project02.dbo.NashvilleHousing

SELECT 
SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) AS address,
SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1, LEN(propertyaddress)) AS address
FROM project02.dbo.NashvilleHousing;

ALTER TABLE Nashvillehousing
ADD propertysplitaddress NVARCHAR(255);
UPDATE Nashvillehousing
SET propertysplitaddress=SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1)

ALTER TABLE Nashvillehousing
ADD propertysplitcity NVARCHAR(255);
UPDATE Nashvillehousing
SET propertysplitaddress=SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1, LEN(propertyaddress))


--Breaking out propertyaddress into individual columns (address,city,state)

SELECT owneraddress FROM project02.dbo.NashvilleHousing

SELECT owneraddress,
PARSENAME(REPLACE(owneraddress,',','.'),3),
PARSENAME(REPLACE(owneraddress,',','.'),2),
PARSENAME(REPLACE(owneraddress,',','.'),1)
FROM project02.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);
UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(owneraddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);
UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(owneraddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);
UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(owneraddress, ',', '.') , 1)

SELECT *
FROM project02.dbo.NashvilleHousing


--------------------------------------------------------------------------------------------------------------

--Change Y and N to Yes &  No in 'soldasvacant' field

SELECT DISTINCT (soldasvacant),COUNT(soldasvacant)
FROM project02.dbo.NashvilleHousing
GROUP BY soldasvacant
ORDER BY soldasvacant

UPDATE NashvilleHousing
SET soldasvacant = CASE
                        WHEN soldasvacant = 'Y' THEN 'Yes'
                        WHEN soldasvacant = 'N' THEN 'No'
                        ELSE soldasvacant
                    END;

------------------------------------------------------------------------------------------------------------------

--Remove duplicates

SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'NashvilleHousing';


WITH RowNumCTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY parcelID,landuse,propertyaddress,saledate,saleprice,legalreference,soldasvacant,ownername,
           owneraddress,acreage,taxdistrict,landvalue,buildingvalue,totalvalue,yearbuilt,bedrooms,fullbath,halfbath,propertysplitaddress,
           propertysplitcity,OwnerSplitAddress,OwnerSplitCity,OwnerSplitState ORDER BY uniqueID) as RowNumber
    FROM NashvilleHousing
)
DELETE FROM RowNumCTE WHERE RowNumber > 1;

------------------------------------------------------------------------------------------------------------------

--Delete unwanted columns

SELECT *
FROM project02.dbo.NashvilleHousing

ALTER TABLE project02.dbo.NashvilleHousing
DROP COLUMN owneraddress,taxdistrict,propertyaddress










