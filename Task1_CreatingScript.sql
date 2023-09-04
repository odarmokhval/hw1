IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Shipment')
BEGIN
    CREATE DATABASE Shipment;
END
GO

USE Shipment;
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'State')
BEGIN
	  CREATE TABLE State (
	  Id INT IDENTITY(1,1) NOT NULL,
	  StateName VARCHAR(255) NOT NULL,
	  PRIMARY KEY (Id)	  
      );
END;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Place')
BEGIN
	  CREATE TABLE Place (
	  Id INT IDENTITY(1,1) NOT NULL,
	  PersonID INT, 
	  StateId INT NOT NULL,
	  PlaceCode  CHAR(2) NOT NULL,
	  PRIMARY KEY (Id),
	  FOREIGN KEY (StateId) REFERENCES State(Id)	
      );
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Warehouse')
BEGIN
	  CREATE TABLE Warehouse (
	  Id DECIMAL(17, 14) NOT NULL,
	  PlaceId INT,
	  PRIMARY KEY (Id),
	  FOREIGN KEY (PlaceId) REFERENCES Place(Id)
      );
END;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Route')
BEGIN	  
	  CREATE TABLE Route (
	  Id INT IDENTITY(1,1) NOT NULL,
	  Distance DECIMAL(10, 2),
	  OriginWaterhouseId DECIMAL(17, 14),
	  DestinationWaterhouseId DECIMAL(17, 14),
	  PRIMARY KEY (Id),
	  FOREIGN KEY (OriginWaterhouseId) REFERENCES Warehouse(Id),
	  FOREIGN KEY (DestinationWaterhouseId) REFERENCES Warehouse(Id)
	  );
END;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Contact')
BEGIN
	  CREATE TABLE Contact (
	  Id INT IDENTITY(1,1) NOT NULL,
	  FirstName VARCHAR(255) NOT NULL,
	  LastName VARCHAR(255) NOT NULL,
	  CellPhone CHAR(15) NOT NULL,
	  PRIMARY KEY (Id),	  
      );
END;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Driver')
BEGIN
	  CREATE TABLE Driver (
	  Id INT IDENTITY(1,1) NOT NULL,
	  LastName VARCHAR(255) NOT NULL,
	  FirstName VARCHAR(255) NOT NULL,
	  Birthdate DATETIME NOT NULL,
	  PRIMARY KEY (Id)
      );
END;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Truck')
BEGIN
	  CREATE TABLE Truck (
	  Id int IDENTITY(1,1) NOT NULL,
	  Brand VARCHAR(255) NOT NULL,
	  RegistrationNumber CHAR(15) NOT NULL,
	  Year DATETIME NOT NULL,
	  Payload FLOAT NOT NULL,
	  FuelConsumption FLOAT NOT NULL,
	  VolumeCargo FLOAT NOT NULL,
	  PRIMARY KEY (Id)
      );
END;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DriverTruck')
BEGIN
	  CREATE TABLE DriverTruck (
	  Id INT IDENTITY(1,1) NOT NULL,
	  DriverId  INT NOT NULL,
	  TruckId  INT NOT NULL,
	  PRIMARY KEY (Id),
	  FOREIGN KEY (DriverId) REFERENCES Driver(Id),
	  FOREIGN KEY (TruckId) REFERENCES Truck(Id)
      );
END;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Cargo')
BEGIN
	  CREATE TABLE Cargo (
	  Id INT IDENTITY(1,1) ,
	  Volume DECIMAL(10, 2),
	  Weight DECIMAL(10, 2),
	  RouteId INT,
	  SenderContactId INT,
	  RecipientContactId INT,
	  PRIMARY KEY (Id),
	  FOREIGN KEY (SenderContactId) REFERENCES Contact(id),
	  FOREIGN KEY (RouteId) REFERENCES Route(id),
	  FOREIGN KEY (RecipientContactId) REFERENCES Contact(id)
	  );
END;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Shipment')
BEGIN
	  CREATE TABLE Shipment (
	  Id INT IDENTITY(1,1) NOT NULL,
	  StartDate DATE,
	  CompletionDate DATE,
	  RouteId INT,
	  DriverTruckId INT,
	  CargoId INT,
	  PRIMARY KEY (Id),
	  FOREIGN KEY (RouteId) REFERENCES Route(Id),
	  FOREIGN KEY (DriverTruckId) REFERENCES DriverTruck(Id),
	  FOREIGN KEY (CargoId) REFERENCES Cargo(Id)
	  );
END;