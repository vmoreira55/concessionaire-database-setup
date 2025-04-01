-- Create the database
CREATE DATABASE CarDealership;
GO

-- Use the newly created database
USE CarDealership;
GO

-- Table: Customers
CREATE TABLE Customers ( 
CustomerID INT PRIMARY KEY, 
FirstName NVARCHAR(50), 
LastName NVARCHAR(50), 
Email NVARCHAR(100), 
Phone NVARCHAR(15), 
Address NVARCHAR(255), 
City NVARCHAR(50), 
State NVARCHAR(50), 
ZipCode NVARCHAR(10)
);
GO

-- Insert data into the Customers table
INSERT INTO Customers (CustomerID, FirstName, LastName, Email, Phone, Address, City, State, ZipCode) VALUES
(1, 'John', 'Perez', 'juan.perez@example.com', '555-1234', '123 Falsa Street', 'City A', 'State A', '12345'),
(2, 'Maria', 'Gonzalez', 'maria.gonzalez@example.com', '555-5678', '456 Siempre Viva Avenue', 'City B', 'State B', '67890'),
(3, 'Carlos', 'Rodriguez', 'carlos.rodriguez@example.com', '555-8765', 'Boulevard de los Sueños 789', 'City C', 'State C', '13579'),
(4, 'Ana', 'Martinez', 'ana.martinez@example.com', '555-4321', 'Plaza Mayor 101', 'City D', 'State D', '24680'),
(5, 'Luis', 'Fernández', 'luis.fernandez@example.com', '555-6789', 'Camino Real 202', 'City E', 'State E', '11223');
GO

-- Table: Vehicles
CREATE TABLE Vehicles ( 
VehicleID INT PRIMARY KEY, 
Make NVARCHAR(50), 
Model NVARCHAR(50), 
Year INT, 
Type NVARCHAR(50), 
Price DECIMAL(18, 2)
);
GO

-- Insert data into the Vehicles table
INSERT INTO Vehicles (VehicleID, Make, Model, Year, Type, Price) VALUES
(1, 'Toyota', 'Corolla', 2022, 'Sedan', 20000.00),
(2, 'Honda', 'Civic', 2021, 'Sedan', 22000.00),
(3, 'Ford', 'F-150', 2023, 'Pickup', 35000.00),
(4, 'Chevrolet', 'Malibu', 2020, 'Sedan', 21000.00),
(5, 'Nissan', 'Altima', 2022, 'Sedan', 23000.00);
GO

-- Table: Salespersons
CREATE TABLE Salespersons ( 
SalespersonID INT PRIMARY KEY, 
FirstName NVARCHAR(50), 
LastName NVARCHAR(50), 
Email NVARCHAR(100), 
Phone NVARCHAR(15)
);
GO

-- Insert data into the Salespersons table
INSERT INTO Salespersons (SalespersonID, FirstName, LastName, Email, Phone) VALUES
(1, 'Pedro', 'Lopez', 'pedro.lopez@example.com', '555-1111'),
(2, 'Lucia', 'Hernandez', 'lucia.hernandez@example.com', '555-2222'),
(3, 'Miguel', 'Torres', 'miguel.torres@example.com', '555-3333'),
(4, 'Sofia', 'Ramirez', 'sofia.ramirez@example.com', '555-4444'),
(5, 'Diego', 'Sanchez', 'diego.sanchez@example.com', '555-5555');
GO

-- Table: Sales
CREATE TABLE Sales ( 
SaleID INT PRIMARY KEY, 
CustomerID INT, 
VehicleID INT, 
SalespersonID INT, 
SaleDate DATE, 
SalePrice DECIMAL(18, 2), 
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID), 
FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID), 
FOREIGN KEY (SalespersonID) REFERENCES Salespersons(SalespersonID)
);
GO

-- Insert data into the Sales table
INSERT INTO Sales (SaleID, CustomerID, VehicleID, SalespersonID, SaleDate, SalePrice) VALUES
(1, 1, 1, 1, '2025-01-15', 19500.00),
(2, 2, 3, 2, '2025-02-20', 34000.00),
(3, 3, 2, 3, '2025-03-10', 21500.00),
(4, 4, 5, 4, '2025-04-05', 22500.00),
(5, 5, 4, 5, '2025-05-12', 20500.00);
GO

-- Table: Maintenance
CREATE TABLE Maintenance ( 
MaintenanceID INT PRIMARY KEY, 
VehicleID INT, 
MaintenanceDate DATE, 
Description NVARCHAR(255), 
DECIMAL Cost(18, 2), 
FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID)
);
GO

-- Insert data into the Maintenance table
INSERT INTO Maintenance (MaintenanceID, VehicleID, MaintenanceDate, Description, Cost) VALUES
(1, 1, '2025-06-01', 'Oil and Filter Change', 100.00),
(2, 2, '2025-06-15', 'Brake Service', 150.00),
(3, 3, '2025-07-10', 'Alignment and Balancing', 120.00),
(4, 4, '2025-07-20', 'Battery Change', 200.00),
(5, 5, '2025-08-05', 'Overhaul', 180.00);
GO