/*
Analysis of Poor Practices:

Lack of Transaction Management:
The procedure does not use transactions (BEGIN TRANSACTION and COMMIT TRANSACTION), risking partial data updates if an error occurs mid-execution.​

Absence of Error Handling:
There are no BEGIN TRY...END TRY and BEGIN CATCH...END CATCH blocks, making it difficult to handle and debug errors effectively.​

Inadequate Input Validation:
The procedure assumes all input parameters are valid and convertible to the required data types without verification, leading to potential runtime errors.​

Use of Inappropriate Data Types:
All parameters are defined as NVARCHAR(50), necessitating conversions (CONVERT) during operations, which can degrade performance and cause errors if conversions fail.​

Direct Data Manipulation Without Verification:
Operations like inserting sales records, updating vehicle status, and adding maintenance records are performed without checking the current state of the data, potentially leading to inconsistencies.​

No Concurrency Control:
The procedure updates salesperson statistics without mechanisms to handle concurrent updates, risking data anomalies such as lost updates.​

Omission of Audit Logging:
There is no logging of actions performed, making it challenging to track changes and diagnose issues after execution.
*/

CREATE PROCEDURE BadPracticeTransaction
    @CustomerID NVARCHAR(50),
    @VehicleID NVARCHAR(50),
    @SalespersonID NVARCHAR(50),
    @SalePrice NVARCHAR(50),
    @SaleDate NVARCHAR(50),
    @MaintenanceDate NVARCHAR(50),
    @MaintenanceDescription NVARCHAR(255),
    @MaintenanceCost NVARCHAR(50)
AS
BEGIN
    -- No error handling or transaction management
    DECLARE @SaleID INT;

    -- No validation of input parameters
    -- Direct insertion without checking existing records
    INSERT INTO Sales (CustomerID, VehicleID, SalespersonID, SaleDate, SalePrice)
    VALUES (CONVERT(INT, @CustomerID), CONVERT(INT, @VehicleID), CONVERT(INT, @SalespersonID), CONVERT(DATE, @SaleDate), CONVERT(DECIMAL(18, 2), @SalePrice));

    SET @SaleID = SCOPE_IDENTITY();

    -- Updating vehicle status without checking current status
    UPDATE Vehicles
    SET Status = 'Sold'
    WHERE VehicleID = CONVERT(INT, @VehicleID);

    -- Inserting maintenance record without verifying vehicle existence
    INSERT INTO Maintenance (VehicleID, MaintenanceDate, Description, Cost)
    VALUES (CONVERT(INT, @VehicleID), CONVERT(DATE, @MaintenanceDate), @MaintenanceDescription, CONVERT(DECIMAL(18, 2), @MaintenanceCost));

    -- Updating salesperson statistics without concurrency control
    UPDATE Salespersons
    SET TotalSales = TotalSales + 1,
        TotalRevenue = TotalRevenue + CONVERT(DECIMAL(18, 2), @SalePrice)
    WHERE SalespersonID = CONVERT(INT, @SalespersonID);

    -- No audit logging
END;


/*
Procedure Explanation:

Beginning the Transaction:
BEGIN TRANSACTION is used to ensure that all operations complete successfully before committing changes to the database.

Pre-Validations:
The existence of the customer, vehicle, and salesperson is verified using IF NOT EXISTS queries. If any of them does not exist, a RAISERROR error is generated.

Sale Registration:
A new row is inserted into the Sales table with the details of the sale. The generated SaleID is captured using SCOPE_IDENTITY().

Vehicle Status Update:
The vehicle status is updated to 'Sold' in the Vehicles table.

Maintenance Scheduling:
A new maintenance appointment is inserted in the Maintenance table for the sold vehicle.

Salesperson Statistics Update:
The TotalSales and TotalRevenue columns in the Salespersons table are updated to reflect the new sale.

Audit Log Record:
A record is inserted in the AuditLog table with transaction details, including IDs and sales price.

Transaction Confirmation:
If all operations execute without errors, the transaction is committed with COMMIT TRANSACTION.

Error Handling:
If an error occurs at any point, the transaction is rolled back with ROLLBACK TRANSACTION and a detailed error is raised using RAISERROR.

Good Implemented Practices:
Transactions: Ensure the consistency and atomicity of operations.
Pre-Validations: Ensure that the referenced data exists before proceeding, avoiding errors and maintaining referential integrity.
Error Handling: Provides detailed information in the event of errors and reverts changes to maintain data consistency.
Updates and Logs: Keeps statistics and audit tables up-to-date, facilitating transaction tracking and analysis.
*/

CREATE PROCEDURE ManageCustomerTransaction
    @CustomerID INT,
    @VehicleID INT,
    @SalespersonID INT,
    @SalePrice DECIMAL(18, 2),
    @SaleDate DATE,
    @MaintenanceDate DATE,
    @MaintenanceDescription NVARCHAR(255),
    @MaintenanceCost DECIMAL(18, 2)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Check if the customer exists
        IF NOT EXISTS (SELECT 1 FROM Customers WHERE CustomerID = @CustomerID)
        BEGIN
            RAISERROR('The specified customer does not exist.', 16, 1);
        END

        -- Check if the vehicle exists and is available for sale
        IF NOT EXISTS (SELECT 1 FROM Vehicles WHERE VehicleID = @VehicleID AND Status = 'Available')
        BEGIN
            RAISERROR('The specified vehicle does not exist or is not available.', 16, 1);
        END

        -- Check if the salesperson exists
        IF NOT EXISTS (SELECT 1 FROM Salespersons WHERE SalespersonID = @SalespersonID)
        BEGIN
            RAISERROR('The specified salesperson does not exist.', 16, 1);
        END

        -- Record the sale
        DECLARE @SaleID INT;
        INSERT INTO Sales (CustomerID, VehicleID, SalespersonID, SaleDate, SalePrice)
        VALUES (@CustomerID, @VehicleID, @SalespersonID, @SaleDate, @SalePrice);
        SET @SaleID = SCOPE_IDENTITY();

        -- Update the vehicle status to 'Sold'
        UPDATE Vehicles
        SET Status = 'Sold'
        WHERE VehicleID = @VehicleID;

        -- Schedule future maintenance for the sold vehicle
        INSERT INTO Maintenance (VehicleID, MaintenanceDate, Description, Cost)
        VALUES (@VehicleID, @MaintenanceDate, @MaintenanceDescription, @MaintenanceCost);

        -- Update salesperson's sales statistics
        UPDATE Salespersons
        SET TotalSales = TotalSales + 1,
            TotalRevenue = TotalRevenue + @SalePrice
        WHERE SalespersonID = @SalespersonID;

        -- Log the transaction in the audit table
        INSERT INTO AuditLog (ActionType, ActionDate, Details)
        VALUES ('Sale Recorded', GETDATE(), 
                CONCAT('Sale ID: ', @SaleID, ', Customer ID: ', @CustomerID, 
                       ', Vehicle ID: ', @VehicleID, ', Salesperson ID: ', @SalespersonID, 
                       ', Sale Price: ', @SalePrice));

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Error handling
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;

