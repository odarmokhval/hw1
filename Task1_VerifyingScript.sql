SELECT 
    constraint_name
FROM 
    information_schema.table_constraints
WHERE 
    table_name = 'Place' AND constraint_type = 'FOREIGN KEY';

ALTER TABLE Place
DROP CONSTRAINT FK__Place__StateId__3F466844;

DROP TABLE Place;


/*
ALTER TABLE Warehouse
ALTER COLUMN PlaceId DECIMAL(17, 14);

ALTER TABLE Route
ALTER COLUMN OriginWaterhouseId DECIMAL(17, 14);

ALTER TABLE Route
ALTER COLUMN DestinationWaterhouseId DECIMAL(17, 14);
*/

ALTER TABLE Place
ALTER COLUMN Id DECIMAL(17, 14);

ALTER TABLE Place
ALTER COLUMN PlaceCode Char(128) NOT NULL;