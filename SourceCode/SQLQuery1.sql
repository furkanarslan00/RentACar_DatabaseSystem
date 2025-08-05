CREATE TABLE EMPLOYEE (
    EmployeeID int PRIMARY KEY,
    Name nvarchar(100),
    Position nvarchar(50)
);

CREATE TABLE BRANCH (
    BranchID int PRIMARY KEY,
    BranchManager nvarchar(100),
    PhoneNum nvarchar(20),
    Address nvarchar(255),
    BName nvarchar(100)
);

CREATE TABLE CUSTOMER (
    CustomerID int PRIMARY KEY,
    Name nvarchar(100),
    TC_ID nvarchar(20),
    PhoneNumber nvarchar(20),
    EMail nvarchar(100),
    Address nvarchar(255)
);

CREATE TABLE RENTAL (
    RentalID int PRIMARY KEY,
    TotalFee decimal(10, 2),
    ReturnDate date,
    RentalDate date,
    CustomerID int,
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
);

CREATE TABLE VEHICLE (
    VehicleID int PRIMARY KEY,
    Model nvarchar(100),
    Brand nvarchar(100),
    LastInspectionDate date,
    DailyRentalFee decimal(10, 2),
    Status nvarchar(50),
    PlateNumber nvarchar(20),
    Year int,
    BranchID int,
    RentalID int,
    FOREIGN KEY (BranchID) REFERENCES BRANCH(BranchID),
    FOREIGN KEY (RentalID) REFERENCES RENTAL(RentalID)
);

CREATE TABLE WORKS (
    EmployeeID int,
    BranchID int,
    FOREIGN KEY (EmployeeID) REFERENCES EMPLOYEE(EmployeeID),
    FOREIGN KEY (BranchID) REFERENCES BRANCH(BranchID)
);

CREATE TABLE DAMAGE (
    DamageDate date,
    DamageStatus nvarchar(50),
    DamageDescript nvarchar(255),
    VehicleID int,
    FOREIGN KEY (VehicleID) REFERENCES VEHICLE(VehicleID)
);
CREATE TABLE CONDITION_REPORT (
    ReportID int PRIMARY KEY,
    PreviousCondition nvarchar(255),
    CurrentCondition nvarchar(255),
    ReportDate date,
    RentalID int,
    FOREIGN KEY (RentalID) REFERENCES RENTAL(RentalID)
);


-- EMPLOYEE tablosuna veri ekleme
INSERT INTO EMPLOYEE (EmployeeID, Name, Position)
VALUES 
(1, 'Ahmet Yýlmaz', 'Manager'),
(2, 'Mehmet Kaya', 'Salesman'),
(3, 'Ayþe Demir', 'Clerk');

-- BRANCH tablosuna veri ekleme
INSERT INTO BRANCH (BranchID, BranchManager, PhoneNum, Address, BName)
VALUES 
(1, 'Ali Veli', '555-1234', '123 Main St', 'Central'),
(2, 'Fatma Yýldýz', '555-5678', '456 Elm St', 'North'),
(3, 'Hasan Hüseyin', '555-8765', '789 Pine St', 'South');

-- CUSTOMER tablosuna veri ekleme
INSERT INTO CUSTOMER (CustomerID, Name, TC_ID, PhoneNumber, EMail, Address)
VALUES 
(1, 'Zeynep Çelik', '12345678901', '555-0000', 'zeynep@example.com', '1 Oak St'),
(2, 'Murat Ak', '10987654321', '555-1111', 'murat@example.com', '2 Maple St'),
(3, 'Elif Güney', '11223344556', '555-2222', 'elif@example.com', '3 Cedar St');

-- RENTAL tablosuna veri ekleme
INSERT INTO RENTAL (RentalID, TotalFee, ReturnDate, RentalDate, CustomerID)
VALUES 
(1, 180.00, '2023-05-10', '2023-05-07', 1),
(2, 200.00, '2023-05-15', '2023-05-10', 2);

-- VEHICLE tablosuna veri ekleme
INSERT INTO VEHICLE (VehicleID, Model, Brand, LastInspectionDate, DailyRentalFee, Status, PlateNumber, Year, BranchID, RentalID)
VALUES 
(1, 'Model S', 'Tesla', '2023-01-10', 100.00, 'Available', '34ABC123', 2021, 1, NULL),
(2, 'Civic', 'Honda', '2023-02-15', 50.00, 'Available', '35DEF456', 2019, 2, NULL),
(3, 'Corolla', 'Toyota', '2023-03-20', 60.00, 'Rented', '36GHI789', 2020, 3, 1);

-- WORKS tablosuna veri ekleme
INSERT INTO WORKS (EmployeeID, BranchID)
VALUES 
(1, 1),
(2, 2),
(3, 3);

-- DAMAGE tablosuna veri ekleme
INSERT INTO DAMAGE (DamageDate, DamageStatus, DamageDescript, VehicleID)
VALUES 
('2023-04-01', 'Repaired', 'Minor scratch', 1),
('2023-04-05', 'Pending', 'Broken headlight', 2);

-- CONDITION_REPORT tablosuna veri ekleme
INSERT INTO CONDITION_REPORT (ReportID, PreviousCondition, CurrentCondition, ReportDate, RentalID)
VALUES 
(1, 'Good', 'Excellent', '2023-05-10', 1),
(2, 'Fair', 'Good', '2023-05-15', 2);



--UPDATE
-- EMPLOYEE tablosunda veri güncelleme
UPDATE EMPLOYEE
SET Position = 'Senior Salesman'
WHERE EmployeeID = 2;

-- BRANCH tablosunda veri güncelleme
UPDATE BRANCH
SET PhoneNum = '555-7890'
WHERE BranchID = 2;

-- CUSTOMER tablosunda veri güncelleme
UPDATE CUSTOMER
SET PhoneNumber = '555-4444'
WHERE CustomerID = 1;

-- VEHICLE tablosunda veri güncelleme
UPDATE VEHICLE
SET Status = 'In Maintenance'
WHERE VehicleID = 1;

-- RENTAL tablosunda veri güncelleme
UPDATE RENTAL
SET ReturnDate = '2023-06-18'
WHERE RentalID = 2;

-- WORKS tablosunda veri güncelleme
UPDATE WORKS
SET BranchID = 3
WHERE EmployeeID = 1;

-- DAMAGE tablosunda veri güncelleme
UPDATE DAMAGE
SET DamageStatus = 'In Progress'
WHERE VehicleID = 1;

-- CONDITION_REPORT tablosunda veri güncelleme
UPDATE CONDITION_REPORT
SET CurrentCondition = 'Excellent'
WHERE ReportID = 1;


--INNER JOÝN 
SELECT EMPLOYEE.Name, EMPLOYEE.Position, BRANCH.BName
FROM EMPLOYEE
INNER JOIN WORKS ON EMPLOYEE.EmployeeID = WORKS.EmployeeID
INNER JOIN BRANCH ON WORKS.BranchID = BRANCH.BranchID;
