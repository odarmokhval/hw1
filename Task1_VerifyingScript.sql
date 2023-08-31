SELECT 
    constraint_name
FROM 
    information_schema.table_constraints
WHERE 
    table_name = 'Place' AND constraint_type = 'FOREIGN KEY';

ALTER TABLE Place
DROP CONSTRAINT FK__Place__StateId__3F466844;

DROP TABLE Place;