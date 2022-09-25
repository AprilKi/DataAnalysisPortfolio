USE BusinessLicences
GO


/* Cleaning strings of date and time  */
SELECT 
	LEFT(IssuedDate,10) AS Cleaned_IssuedDate, 
	RIGHT(IssuedDate, LEN(IssuedDate) - 11) AS Cleaned_IssuedTime,
	LEFT(ExtractDate,10) AS Cleaned_ExtractDate,
	RIGHT(ExtractDate, LEN(ExtractDate) - 11) AS Cleaned_ExtractTime
FROM dbo.BusinessLicences


/* Convert numeric to noney and null value to 0 in feePaid */
SELECT CONVERT(NUMERIC, CAST(ISNULL(FeePaid, 0) AS MONEY), 1) AS New_FeePaid
FROM dbo.BusinessLicences;


/* Count postal code with null */
SELECT COUNT(PostalCode) AS 'Number PostalCode'
FROM dbo.BusinessLicences
WHERE PostalCode NOT LIKE '[A-Z][0-9][A-Z] [A-Z][0-9][A-Z]'


/* Convert invaild format of postal code to vaild format postal code*/
SELECT 
	CASE WHEN LEN(PostalCode) = 6 THEN LEFT(PostalCode,3) + ' ' + RIGHT(PostalCode,3)
  		 WHEN LEN(PostalCode) = 7 THEN LEFT(PostalCode,3) + ' ' + RIGHT(PostalCode,3)
		 WHEN LEN(PostalCode) > 8 THEN NULL
		 WHEN LEN(PostalCode) < 6 THEN NULL
	END
FROM dbo.BusinessLicences
WHERE PostalCode NOT LIKE '[A-Z][0-9][A-Z] [A-Z][0-9][A-Z]'
ORDER BY PostalCode ASC


/* Replace invaild city name */
WITH temporaryTable (averageValue) AS
    (SELECT 
	REPLACE(REPLACE(REPLACE(city, 'vacouver', 'Vancouver'), 'vancouver', 'Vancouver'),'Surey','Surrey')
	FROM dbo.BusinessLicences)
SELECT DISTINCT(averageValue)
FROM temporaryTable
ORDER BY averageValue DESC
