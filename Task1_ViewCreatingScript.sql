CREATE VIEW CityWithTruck AS
SELECT
    Route.OriginWaterhouseId,
    Route.DestinationWaterhouseId,
	Truck.Brand
FROM
    Route
INNER JOIN
    Truck ON Truck.Id = Route.Id;