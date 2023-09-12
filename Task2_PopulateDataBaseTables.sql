BULK INSERT DriverTruck
FROM 'C:\Olga_folder\!Mentoring_2023\Course_application\Data\DataCSV\DriverTruck.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';', 
    ROWTERMINATOR = '\r'
)

BULK INSERT Driver
FROM 'C:\Olga_folder\!Mentoring_2023\Course_application\Data\DataCSV\Drivers.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';', 
    ROWTERMINATOR = '\r'
)

BULK INSERT Route
FROM 'C:\Olga_folder\!Mentoring_2023\Course_application\Data\DataCSV\Route.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';', 
    ROWTERMINATOR = '\r'
)

BULK INSERT Truck
FROM 'C:\Olga_folder\!Mentoring_2023\Course_application\Data\DataCSV\Trucks.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';', 
    ROWTERMINATOR = '\r'
)

-- Populating 'Place' and 'State' table using temporary table
CREATE TABLE #PlaceState (
    StateId INT,
	StateName VARCHAR(255),
	PlaceCode INT,
	PlaceName VARCHAR(255)
);

-- Use BULK INSERT to insert data from the CSV file into the temporary table
BULK INSERT #PlaceState
FROM 'C:\Olga_folder\!Mentoring_2023\Course_application\Data\DataCSV\PlaceState.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\r'
);

-- Insert data from the temporary table into Place table
INSERT INTO Place (PlaceName, StateId, PlaceCode)
SELECT PlaceName, StateId, PlaceCode
FROM #PlaceState;

-- Insert data from the temporary table into State table
INSERT INTO State (StateName)
SELECT StateName
FROM #PlaceState;

-- Clean up the temporary table
DROP TABLE #PlaceState;

BULK INSERT Warehouse
FROM 'C:\Olga_folder\!Mentoring_2023\Course_application\Data\DataCSV\Warehouses.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';', 
    ROWTERMINATOR = '\r'
)

-- refill Contact table before insert values in Cargo
INSERT INTO Contact (FirstName, LastName, CellPhone)
VALUES ('JaneContact', 'Doe', '123-888-7890');

-- Insert 10000 random values into Cargo table
SET IDENTITY_INSERT Cargo OFF;

INSERT INTO Cargo (Volume, Weight, RouteId, SenderContactId, RecipientContactId)
SELECT TOP 10000
    CAST(RAND() * 1000 AS NUMERIC(10, 2)),
    CAST(RAND() * 1000 AS NUMERIC(10, 2)),
    CAST(RAND() * 1000 AS INT),
    1,
    1
FROM sys.objects AS o1
CROSS JOIN sys.objects AS o2;

USE Shipment;

--	Populate Shipment table with 1000 records
INSERT INTO [dbo].[Shipment] (StartDate, CompletionDate, RouteId, DriverTruckId, CargoId)
SELECT 
    DATEADD(DAY, -RAND()*365, GETDATE()),
    DATEADD(DAY, RAND()*365, GETDATE()),
    (SELECT TOP 1 Id FROM [dbo].[Route] ORDER BY NEWID()),
    (SELECT TOP 1 D.Id FROM [dbo].[DriverTruck] AS D
     INNER JOIN [dbo].[Truck] AS T ON D.TruckId = T.Id
     ORDER BY NEWID()),
    (SELECT TOP 1 Id FROM [dbo].[Cargo] ORDER BY NEWID())
FROM sys.objects AS o1
CROSS JOIN sys.objects AS o2
WHERE o1.object_id % 100 = 0; 

-- Set Distance for each route as a random value between 100 and 3000
-- Create a temporary table to store the random values
CREATE TABLE #RandomValues (RandomValue DECIMAL(10, 2));

-- Generate and insert different random values into #RandomValues
DECLARE @RowCount INT = 0;

WHILE @RowCount < 297
BEGIN
    INSERT INTO #RandomValues (RandomValue)
    SELECT ROUND(RAND() * (3000 - 100) + 100, 2);

    SET @RowCount = @RowCount + 1;
END;

-- Update Route with the different random values
WITH CTE AS (
    SELECT TOP 297 RandomValue
    FROM #RandomValues
)
UPDATE Route
SET Distance = CTE.RandomValue
FROM CTE;

-- Clean up the temporary table
DROP TABLE #RandomValues;


-- Populate Route table with all possible pairs of warehouses
CREATE TABLE #AllPairs (
    OriginWaterhouseId DECIMAL(17, 14),
    DestinationWaterhouseId DECIMAL(17, 14)
);

MERGE INTO Route AS target
USING (
    SELECT
        ap.OriginWaterhouseId,
        ap.DestinationWaterhouseId,
        ROUND(RAND() * (3000 - 100) + 100, 2) AS NewDistance
    FROM
        #AllPairs ap
) AS source
ON
    target.OriginWaterhouseId = source.OriginWaterhouseId
    AND target.DestinationWaterhouseId = source.DestinationWaterhouseId
WHEN MATCHED THEN
    UPDATE SET
        target.Distance = source.NewDistance
WHEN NOT MATCHED THEN
    INSERT (OriginWaterhouseId, DestinationWaterhouseId, Distance)
    VALUES (source.OriginWaterhouseId, source.DestinationWaterhouseId, source.NewDistance);

-- Clean up the temporary table
DROP TABLE #AllPairs;