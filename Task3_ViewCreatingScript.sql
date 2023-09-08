CREATE VIEW CityWithTruck AS
SELECT
    r.OriginWaterhouseId,
    r.DestinationWaterhouseId,
	tr.Brand
FROM
    Route r
JOIN Shipment s ON r.Id = s.RouteId
JOIN DriverTruck dt ON s.DriverTruckId = dt.DriverId
JOIN Truck tr ON dt.TruckId = tr.Id;