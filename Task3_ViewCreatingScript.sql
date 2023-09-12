IF NOT EXISTS (SELECT * FROM sys.views WHERE name = 'CityWithTruck')
BEGIN
    EXEC('
			CREATE VIEW CityWithTruck AS
			SELECT
				p.PlaceName,
				st.StateName,
				tr.Brand
			FROM
				State st
			JOIN Place p ON st.Id = p.StateId
			JOIN Warehouse w ON p.Id = w.PlaceId
			JOIN Route r ON w.Id = r.OriginWaterhouseId
			JOIN Shipment s ON r.Id = s.RouteId
			JOIN DriverTruck dt ON s.DriverTruckId = dt.DriverId
			JOIN Truck tr ON dt.TruckId = tr.Id;
    ');
END