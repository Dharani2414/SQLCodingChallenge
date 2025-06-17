
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'sqlcoding')
BEGIN
    CREATE DATABASE sqlcoding;
    PRINT 'Database "sqlcoding" created.';
END
ELSE
BEGIN
    PRINT 'Database "sqlcoding" already exists.';
END
GO


USE sqlcoding;
GO

IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME = 'Vehicle' AND TABLE_TYPE = 'BASE TABLE'
)
BEGIN
    CREATE TABLE Vehicle (
        vehicleID INT PRIMARY KEY,
        make VARCHAR(50),
        model VARCHAR(50),
        [year] INT,
        dailyRate DECIMAL(10,2),
        available TINYINT CHECK (available IN (0, 1)), -- 1 = available, 0 = not available
        passengerCapacity INT,
        engineCapacity INT
    );
    PRINT 'Table "Vehicle" created.';
END
GO


IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME = 'Customer' AND TABLE_TYPE = 'BASE TABLE'
)
BEGIN
    CREATE TABLE Customer (
        customerID INT PRIMARY KEY,
        firstName VARCHAR(100),
        lastName VARCHAR(100),
        email VARCHAR(100),
        phoneNumber VARCHAR(20)
    );
    PRINT 'Table "Customer" created.';
END
GO


IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME = 'Lease' AND TABLE_TYPE = 'BASE TABLE'
)
BEGIN
    CREATE TABLE Lease (
        leaseID INT PRIMARY KEY,
        carID INT,
        customerID INT,
        startDate DATE,
        endDate DATE,
        leaseType VARCHAR(20) CHECK (leaseType IN ('Daily', 'Monthly')),
        FOREIGN KEY (carID) REFERENCES Vehicle(vehicleID),
        FOREIGN KEY (customerID) REFERENCES Customer(customerID)
    );
    PRINT 'Table "Lease" created.';
END
GO


IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME = 'Payment' AND TABLE_TYPE = 'BASE TABLE'
)
BEGIN
    CREATE TABLE Payment (
        paymentID INT PRIMARY KEY,
        leaseID INT,
        paymentDate DATE,
        amount DECIMAL(10,2),
        FOREIGN KEY (leaseID) REFERENCES Lease(leaseID)
    );
    PRINT 'Table "Payment" created.';
END
GO

INSERT INTO Vehicle (vehicleID, make, model, year, dailyRate, available, passengerCapacity, engineCapacity) VALUES
(1, 'Toyota', 'Camry', 2022, 50.00, 1, 4, 1450),
(2, 'Honda', 'Civic', 2023, 45.00, 1, 7, 1500),
(3, 'Ford', 'Focus', 2022, 48.00, 0, 4, 1400),
(4, 'Nissan', 'Altima', 2023, 52.00, 1, 7, 1200),
(5, 'Chevrolet', 'Malibu', 2022, 47.00, 1, 4, 1800),
(6, 'Hyundai', 'Sonata', 2023, 49.00, 0, 7, 1400),
(7, 'BMW', '3 Series', 2023, 60.00, 1, 7, 2499),
(8, 'Mercedes', 'C-Class', 2022, 58.00, 1, 8, 2599),
(9, 'Audi', 'A4', 2022, 55.00, 0, 4, 2500),
(10, 'Lexus', 'ES', 2023, 54.00, 1, 4, 2500);

INSERT INTO Customer (customerID, firstName, lastName, email, phoneNumber) VALUES
(1, 'John', 'Doe', 'johndoe@example.com', '555-555-5555'),
(2, 'Jane', 'Smith', 'janesmith@example.com', '555-123-4567'),
(3, 'Robert', 'Johnson', 'robert@example.com', '555-789-1234'),
(4, 'Sarah', 'Brown', 'sarah@example.com', '555-456-7890'),
(5, 'David', 'Lee', 'david@example.com', '555-987-6543'),
(6, 'Laura', 'Hall', 'laura@example.com', '555-234-5678'),
(7, 'Michael', 'Davis', 'michael@example.com', '555-876-5432'),
(8, 'Emma', 'Wilson', 'emma@example.com', '555-432-1098'),
(9, 'William', 'Taylor', 'william@example.com', '555-321-6547'),
(10, 'Olivia', 'Adams', 'olivia@example.com', '555-765-4321');

INSERT INTO Lease (leaseID, carID, customerID, startDate, endDate, leaseType) VALUES
(1, 1, 1, '2023-01-01', '2023-01-05', 'Daily'),
(2, 2, 2, '2023-02-15', '2023-02-28', 'Monthly'),
(3, 3, 3, '2023-03-10', '2023-03-15', 'Daily'),
(4, 4, 4, '2023-04-20', '2023-04-30', 'Monthly'),
(5, 5, 5, '2023-05-05', '2023-05-10', 'Daily'),
(6, 4, 3, '2023-06-15', '2023-06-30', 'Monthly'),
(7, 7, 7, '2023-07-01', '2023-07-10', 'Daily'),
(8, 6, 8, '2023-08-12', '2023-08-15', 'Monthly'),
(9, 3, 3, '2023-09-07', '2023-09-10', 'Daily'),
(10, 5, 10, '2023-10-10', '2023-10-31', 'Monthly');

INSERT INTO Payment (paymentID, leaseID, paymentDate, amount) VALUES
(1, 1, '2023-01-03', 200.00),
(2, 2, '2023-02-20', 1000.00),
(3, 3, '2023-03-12', 75.00),
(4, 4, '2023-04-25', 900.00),
(5, 5, '2023-05-07', 60.00),
(6, 6, '2023-06-18', 1200.00),
(7, 7, '2023-07-03', 40.00),
(8, 8, '2023-08-14', 1100.00),
(9, 9, '2023-09-09', 80.00),
(10, 10, '2023-10-25', 80.00);

--1 Update the daily rate for a Mercedes car to 68. 
UPDATE Vehicle
SET dailyRate = 68.00
WHERE make = 'Mercedes';

--Delete a specific customer and all associated leases and payments. 
DELETE FROM Payment 
WHERE leaseID IN (
    SELECT leaseID FROM Lease WHERE customerID = 3
);

DELETE FROM Lease 
WHERE customerID = 3;

DELETE FROM Customer 
WHERE customerID = 3;

--3. Rename the "paymentDate" column in the Payment table to "transactionDate"
EXEC sp_rename 'Payment.PaymentDate', 'transactionDate', 'COLUMN';

--4. Find a specific customer by email. 
SELECT CustomerID, firstName, lastName, phoneNumber 
FROM Customer 
WHERE email = 'olivia@example.com';

-- updated the date from the year 2023 to 2025 to find records of active leases
UPDATE Lease 
SET 
    startDate = DATEADD(YEAR, 2, startDate),
    endDate = DATEADD(YEAR, 2, endDate);

UPDATE Payment 
SET transactionDate = DATEADD(YEAR, 2, transactionDate);

-- 5. Get active leases for a specific customer.

SELECT 
    Lease.LeaseID,
    Lease.carID,
    Lease.startDate,
    Lease.endDate,
    Lease.leaseType,
    Vehicle.make,
    Vehicle.model
FROM Lease
JOIN Vehicle ON Lease.carID = Vehicle.vehicleID
WHERE Lease.customerID = 7
  AND Lease.endDate >= GETDATE();



--6. Find all payments made by a customer with a specific phone number.
SELECT * 
FROM Payment 
JOIN Lease ON Payment.LeaseID = Lease.LeaseID 
JOIN Customer ON Customer.CustomerID = Lease.CustomerID 
WHERE Customer.phoneNumber = '555-123-4567';

--7. Calculate the average daily rate of all available cars.
CREATE PROCEDURE GetAvgDailyRateAvailable
AS
BEGIN
    SELECT AVG(dailyRate) AS avgDailyRate 
    FROM Vehicle 
    WHERE available = 1;
END;
GO
EXEC GetAvgDailyRateAvailable;

--8. Find the car with the highest daily rate. 
SELECT VehicleID, make, model 
FROM Vehicle 
WHERE dailyRate = (
    SELECT MAX(dailyRate) FROM Vehicle
);

--9. Retrieve all cars leased by a specific customer. 
SELECT 
    v.make, v.model, l.startDate, l.endDate, l.leaseID
FROM 
    Vehicle v 
JOIN 
    Lease l ON v.vehicleID = l.carID 
WHERE 
    l.customerID = 5;

--10. Find the details of the most recent lease. 
SELECT  
    l.LeaseID,
    l.CustomerID,
    v.model,
    v.make,
    c.firstName,
    c.lastName
FROM 
    Lease l
JOIN 
    Customer c ON c.CustomerID = l.CustomerID
JOIN 
    Vehicle v ON v.vehicleID = l.carID
WHERE 
    l.startDate = (SELECT MAX(startDate) FROM Lease);


--updated the year to 2025 for easy record access
--11. List all payments made in the year 2025. 
SELECT paymentID, transactionDate, amount 
FROM Payment 
WHERE YEAR(transactionDate) = 2025;

--12. Retrieve customers who have not made any payments. 
SELECT * 
FROM Customer 
WHERE CustomerID NOT IN (
    SELECT Lease.CustomerID 
    FROM Lease 
    JOIN Payment ON Lease.LeaseID = Payment.LeaseID
);

--13. Retrieve Car Details and Their Total Payments. 
SELECT 
    Vehicle.VehicleID,
    Vehicle.model,
    Vehicle.make,
    sum(Payment.amount) AS totalPayments
FROM 
    Vehicle
JOIN 
    Lease ON Vehicle.VehicleID = Lease.carID 
JOIN 
    Payment ON Lease.LeaseID = Payment.LeaseID GROUP BY  Vehicle.VehicleID,
    Vehicle.model,
    Vehicle.make;

--14. Calculate Total Payments for Each Customer. 
SELECT 
    Customer.CustomerID,
    Customer.firstName,
    Customer.lastName,
    SUM(Payment.amount) AS totalPayments
FROM 
    Customer 
JOIN 
    Lease ON Lease.CustomerID = Customer.CustomerID 
JOIN 
    Payment ON Payment.leaseId = Lease.leaseID
GROUP BY 
    Customer.CustomerID, Customer.firstName, Customer.lastName;


    --15. List Car Details for Each Lease. 
SELECT 
    Vehicle.*,
    Lease.LeaseID
    FROM  Vehicle JOIN Lease on Vehicle.VehicleID= Lease.carId;


--16. Retrieve Details of Active Leases with Customer and Car Information.
 SELECT 
    Lease.LeaseID,
    Lease.startDate,
    Lease.endDate,
    Lease.leaseType,
    Customer.*,
    Vehicle.*
FROM Lease
JOIN Customer ON Lease.CustomerID = Customer.CustomerID
JOIN Vehicle ON Lease.carID = Vehicle.VehicleID
WHERE Lease.endDate >= GETDATE();


--17. Find the Customer Who Has Spent the Most on Leases. 
SELECT Customer.CustomerId,Customer.firstName,Customer.lastName ,MAX(Payment.amount)AS Paymentamount FROM Customer 
JOIN Lease ON Customer.CustomerId=Lease.CustomerID 
JOIN Payment ON Lease.leaseID=Payment.leaseID
GROUP BY Customer.CustomerId,Customer.firstName,Customer.lastName;


--18. List All Cars with Their Current Lease Information. 
SELECT Vehicle.model,Vehicle.make,Lease.* FROM Vehicle 
JOIN Lease ON Lease.carID=Vehicle.vehicleID;