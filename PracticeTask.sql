create table Items (
    ItemID INT PRIMARY KEY,
    ItemName VARCHAR(255),
    Category VARCHAR(100),
    Cost DECIMAL(10, 2)
);

create table Purchases (
    PurchaseID INT PRIMARY KEY,
    BuyerName VARCHAR(255),
    PurchaseDate DATE
);

create table PurchaseDetails (
    DetailID INT PRIMARY KEY,
    PurchaseID INT,
    ItemID INT,
    Amount INT,
    TotalCost DECIMAL(10, 2),
    FOREIGN KEY (PurchaseID) REFERENCES Purchases(PurchaseID),
    FOREIGN KEY (ItemID) REFERENCES Items(ItemID)
);

INSERT INTO Items VALUES
(1, 'Laptop Pro X', 'Electronics', 1200.00),
(2, 'Office Chair', 'Furniture', 350.00),
(3, 'Smartphone Z', 'Electronics', 950.00),
(4, 'Standing Desk', 'Furniture', 700.00);

INSERT INTO Purchases VALUES
(101, 'Alice Johnson', '2025-06-01'),
(102, 'Bob Smith', '2025-06-03'),
(103, 'Charlie Ray', '2025-06-05');

INSERT INTO PurchaseDetails VALUES
(1001, 101, 1, 1, 1200.00),
(1002, 101, 2, 2, 700.00),
(1003, 102, 3, 1, 950.00),
(1004, 103, 4, 3, 2100.00);

select * from Items
order by Cost desc;

select I.Category,Sum(PD.Amount) as TotalItems
from PurchaseDetails PD
join Items I on PD.ItemID = I.ItemID
GROUP BY I.Category;

select PurchaseID, sum(TotalCost) as TotalSpent
from PurchaseDetails
group by PurchaseID;

select Category, min(Cost) as MinCost, max(Cost) as MaxCost
from Items
group by Category;

select PurchaseID,sum(TotalCost) as TotalSpent
from PurchaseDetails
group by PurchaseID
having sum(TotalCost) > 2000;

select p.BuyerName, i.ItemName, pd.Amount
from PurchaseDetails pd
inner join Purchases p ON pd.PurchaseID = p.PurchaseID
inner join  Items i ON PD.ItemID = i.ItemID;


create table Customers(
    CustomerID int primary key,
    CustomerName VARCHAR(255)
);

create table Payments (
    PaymentID int primary key ,
    CustomerID int,
    PaymentAmount decimal(10, 2)
);

INSERT INTO Customers VALUES
(1, 'Alice Johnson'),
(2, 'Bob Smith'),
(3, 'Derek Miles');

INSERT INTO Payments VALUES
(201, 1, 1500.00),
(202, 2, 800.00),
(203, 99, 500.00);

select c.CustomerName, p.PaymentAmount
from Customers c
full join Payments p ON c.CustomerID = p.CustomerID;

select c.CustomerName, p.PaymentAmount
from Customers c
left join Payments p ON c.CustomerID = p.CustomerID;

select c.CustomerName, p.PaymentAmount
from Customers c
right join Payments p ON c.CustomerID = p.CustomerID;

