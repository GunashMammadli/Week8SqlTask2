CREATE DATABASE AzMB101_Gunash_21Nov;
USE AzMB101_Gunash_21Nov;

CREATE TABLE Positions
(
  Id INT IDENTITY PRIMARY KEY,
  Name NVARCHAR(25) NOT NULL
);

CREATE TABLE Employees
(
  Id INT IDENTITY PRIMARY KEY,
  Name NVARCHAR(25) NOT NULL,
  Surname NVARCHAR(30) NOT NULL DEFAULT 'XXX',
  FathersName NVARCHAR(25) NOT NULL DEFAULT 'XXX',
  Salary MONEY NOT NULL,
  PositionId INT REFERENCES Positions(Id)
);

CREATE TABLE Branches
(
  Id INT IDENTITY PRIMARY KEY,
  Name NVARCHAR(50) NOT NULL
);

CREATE TABLE Products
(
  Id INT IDENTITY PRIMARY KEY,
  Name NVARCHAR(25) NOT NULL,
  PurchasePrice MONEY NOT NULL,
  SalePrice MONEY NOT NULL
);

CREATE TABLE Sales
(
  Id INT IDENTITY PRIMARY KEY,
  ProductId INT REFERENCES Products(Id),
  EmployeeId INT REFERENCES Employees(Id),
  SaleDate DATETIME NOT NULL DEFAULT GETDATE()
);

ALTER TABLE Sales ADD BranchId INT REFERENCES Branches(Id);

INSERT INTO Positions VALUES ('Director');
INSERT INTO Positions VALUES ('Manager');
INSERT INTO Positions VALUES ('Coordinator');
INSERT INTO Positions VALUES ('Back-end developer');

INSERT INTO Employees VALUES ('Gunash', 'Mammadli', 'Valeh', 10000, 1);
INSERT INTO Employees VALUES ('Kanan', 'Ahmadov', 'Kamran', 5000, 2);
INSERT INTO Employees VALUES ('Ali', 'Safarov', 'Chingiz', 4000, 3);
INSERT INTO Employees VALUES ('Isa', 'Abdullazada', 'Orkhan', 9000, 4);

INSERT INTO Branches VALUES ('London');
INSERT INTO Branches VALUES ('Paris');
INSERT INTO Branches VALUES ('Singapore');
INSERT INTO Branches VALUES ('Barcelona');

INSERT INTO Products VALUES ('Apple iPhone 14 Pro Max', 4500, 5000);
INSERT INTO Products VALUES ('PlayStation 5', 1200, 1350);
INSERT INTO Products VALUES ('Sony WH-1000XM4', 800, 920);
INSERT INTO Products VALUES ('Canon EOS R6', 2000, 2200);
INSERT INTO Products VALUES ('LG OLED C1', 1000, 1230);
INSERT INTO Products VALUES ('Apple MacBook Air M2', 2340, 2600);
INSERT INTO Products VALUES ('Apple Watch Ultra', 340, 400);

INSERT INTO Sales VALUES (1, 1, '2023-11-20', 1);
INSERT INTO Sales VALUES (2, 1, '2023-11-21', 2);
INSERT INTO Sales VALUES (6, 3, '2023-11-22', 3);
INSERT INTO Sales VALUES (4, 2, '2023-11-23', 4);
INSERT INTO Sales VALUES (2, 4, '2023-11-20', 1);
INSERT INTO Sales VALUES (5, 2, '2023-11-21', 4);
INSERT INTO Sales VALUES (2, 3, '2023-11-22', 1);
INSERT INTO Sales VALUES (7, 2, '2023-11-23', 4);
INSERT INTO Sales VALUES (3, 2, '2023-8-22', 2);
INSERT INTO Sales VALUES (6, 3, '2023-7-23', 3);

--4
CREATE VIEW vw_CountProductsSoldByEachEmployee AS
(SELECT Employees.Name AS EmployeeName, COUNT(Products.Name) AS SalesCount FROM Sales 
JOIN Employees ON Sales.EmployeeId = Employees.Id
JOIN Products ON Sales.ProductId = Products.Id
GROUP BY Employees.Name)

SELECT * FROM vw_CountProductsSoldByEachEmployee

--5
CREATE VIEW vw_GetBranchesSellsMostProductsToday AS 
(SELECT BranchName, MAX(ProdCount) AS MaxCount FROM 
(SELECT Branches.Name AS BranchName, COUNT(ProductId) AS ProdCount FROM Sales 
JOIN Products ON Sales.ProductId = Products.Id
JOIN Branches ON Sales.BranchId = Branches.Id
WHERE DAY(Sales.SaleDate) = DAY(GETDATE())
GROUP BY Branches.Name) AS ProductCount
GROUP BY BranchName)

SELECT * FROM vw_GetBranchesSellsMostProductsToday

--6
CREATE VIEW vw_GetMostSellsProductsMonthly AS
(SELECT TOP 1 Products.Name AS ProductName, COUNT(Sales.ProductId) AS ProductCount FROM Sales
JOIN Products ON Sales.ProductId = Products.Id
WHERE MONTH(Sales.SaleDate) = MONTH(GETDATE())
GROUP BY Products.Name
ORDER BY ProductCount DESC)

SELECT * FROM vw_GetMostSellsProductsMonthly