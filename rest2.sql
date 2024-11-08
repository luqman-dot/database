-- Creating the Database
CREATE DATABASE rest2;
USE rest2;

--  Customers Table
CREATE TABLE Customers (
    Cust_Id INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15),
    Address VARCHAR(255),
    Loyalty_Points INT DEFAULT 0,
    Preferences VARCHAR(255)
);

--  Menu Table
CREATE TABLE Menu (
    Menu_Id INT PRIMARY KEY,
    Description VARCHAR(255) NOT NULL,
    Category VARCHAR(50),
    Price DECIMAL(10, 3) NOT NULL,
    Availability BOOLEAN DEFAULT TRUE,
    Prep_Time INT CHECK (Prep_Time >= 0)
);

--  Employees Table (moved before Reservations and Orders for FK references)
CREATE TABLE Employees (
    Emp_Id INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Position VARCHAR(50),
    Shift_Timing VARCHAR(20),
    Salary DECIMAL(10, 3),
    Performance_Score DECIMAL(3, 2) CHECK (Performance_Score >= 0 AND Performance_Score <= 5)
);

--  Payment Table
CREATE TABLE Payment (
    Pay_Id INT PRIMARY KEY,
    Date DATE NOT NULL,
    Method VARCHAR(50) NOT NULL,
    Amount DECIMAL(10, 3) NOT NULL,
    Discount DECIMAL(10, 3) DEFAULT 0,
    Tip DECIMAL(10, 3) DEFAULT 0,
    Cust_Id INT,
    FOREIGN KEY (Cust_Id) REFERENCES Customers(Cust_Id)
);

--  Orders Table (moved after Payment for FK references)
CREATE TABLE Orders (
    Ord_Id INT PRIMARY KEY,
    Date DATE NOT NULL,
    Total_Amount DECIMAL(10, 3) NOT NULL,
    Status VARCHAR(50) DEFAULT 'Pending',
    Cust_Id INT,
    Payment_Id INT,
    FOREIGN KEY (Cust_Id) REFERENCES Customers(Cust_Id),
    FOREIGN KEY (Payment_Id) REFERENCES Payment(Pay_Id)
);

--  Reservations Table
CREATE TABLE Reservations (
    Reserv_Id INT PRIMARY KEY,
    Date DATE NOT NULL,
    Table_Number INT NOT NULL,
    No_Guests INT NOT NULL CHECK (No_Guests > 0),
    Status VARCHAR(50) DEFAULT 'Confirmed',
    Special_Requests VARCHAR(255),
    Cust_Id INT,
    Emp_Id INT,
    FOREIGN KEY (Cust_Id) REFERENCES Customers(Cust_Id),
    FOREIGN KEY (Emp_Id) REFERENCES Employees(Emp_Id)
);

--  Delivery & Takeaway Table
CREATE TABLE Delivery_Takeaway (
    Delivery_Id INT PRIMARY KEY,
    Destination VARCHAR(255) NOT NULL,
    Order_Id INT UNIQUE,
    Pickup_Time TIME,
    Duration INT CHECK (Duration >= 0),
    Emp_Id INT,
    FOREIGN KEY (Order_Id) REFERENCES Orders(Ord_Id),
    FOREIGN KEY (Emp_Id) REFERENCES Employees(Emp_Id)
);

--  Suppliers Table
CREATE TABLE Suppliers (
    Sup_Id INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Contact VARCHAR(100),
    Phone VARCHAR(15),
    Email VARCHAR(100) UNIQUE,
    Rating DECIMAL(3, 2) CHECK (Rating >= 0 AND Rating <= 5)
);


--  Products Table
CREATE TABLE Products (
    Product_Id INT PRIMARY KEY,
    Product_Name VARCHAR(50) NOT NULL UNIQUE
);

--  Supplied_Items Table
CREATE TABLE Supplied_Items (
    Sup_Id INT,
    Product_Id INT,
    PRIMARY KEY (Sup_Id, Product_Id),
    FOREIGN KEY (Sup_Id) REFERENCES Suppliers(Sup_Id),
    FOREIGN KEY (Product_Id) REFERENCES Products(Product_Id)
);

--  Order_Items Table
CREATE TABLE Order_Items (
    Order_Item_Id INT PRIMARY KEY,
    Order_Id INT,
    Menu_Id INT,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    Price DECIMAL(10, 3) NOT NULL,
    FOREIGN KEY (Order_Id) REFERENCES Orders(Ord_Id),
    FOREIGN KEY (Menu_Id) REFERENCES Menu(Menu_Id)
);

--  Sales_Report Table
CREATE TABLE Sales_Report (
    Report_Id INT PRIMARY KEY,
    Date DATE NOT NULL,
    Total_Sales DECIMAL(15, 2) NOT NULL,
    Total_Orders INT NOT NULL CHECK (Total_Orders >= 0),
    Top_Selling_Item INT,
    FOREIGN KEY (Top_Selling_Item) REFERENCES Menu(Menu_Id)
);

-- Insert data into Customers table
INSERT INTO Customers (Cust_Id, Name, Email, Phone, Address, Loyalty_Points, Preferences)
VALUES 
(1, 'Luqman Shadow', 'shadow@gmail.com', '0757-214365', '20 Tupe', 100, 'All'),
(2, 'George Jungle', 'jungle@gmail.com', '0787-567891', '456 SOSO', 50, 'Vegan'),
(3, 'Liz Brown', 'liz@gmail.com', '0777-876555', '789 Premium ST', 150, 'Gluten-Free'),
(4, 'Aaron Igt', 'Igt@gmail.com', '0771-876895', '1 International ST', 450, 'Carnivore');

-- Insert data into Menu table
INSERT INTO Menu (Menu_Id, Description, Category, Price, Availability, Prep_Time)
VALUES 
(1, 'Margherita Pizza', 'Main Course', 12.000, TRUE, 15),
(2, 'Soup', 'Appetizer', 6.000, TRUE, 10),
(3, 'Chocolate Cake', 'Dessert', 15.000, TRUE, 5),
(4, 'BBQ Chicken', 'Main Course', 12.000, TRUE, 15),
(5, 'Bread & Beans', 'Appetizer', 6.000, TRUE, 10),
(6, 'Pudding', 'Dessert', 15.000, TRUE, 5);

-- Insert data into Orders table
INSERT INTO Orders (Ord_Id, Date, Total_Amount, Status, Cust_Id, Payment_Id)
VALUES 
(1, '2024-11-01', 34.000, 'Completed', 1, 1),
(2, '2024-11-02', 6.000, 'Pending', 2, 2),
(3, '2024-11-02', 12.000, 'Completed', 3, 3);

-- Insert data into Payment table
INSERT INTO Payment (Pay_Id, Date, Method, Amount, Discount, Tip, Cust_Id)
VALUES 
(1, '2024-11-01', 'Credit Card', 34.000, 0.00, 2.500, 1),
(2, '2024-11-02', 'Cash', 6.000, 0.50, 0.00, 2),
(3, '2024-11-02', 'Credit Card', 12.000, 1.00, 1.00, 3);

-- Insert data into Reservations table
INSERT INTO Reservations (Reserv_Id, Date, Table_Number, No_Guests, Status, Special_Requests, Cust_Id, Emp_Id)
VALUES 
(1, '2024-11-03', 5, 4, 'Confirmed', 'Near window', 1, 101),
(2, '2024-11-04', 10, 2, 'Confirmed', 'Birthday decorations', 2, 102),
(3, '2024-11-05', 3, 6, 'Pending', '', 3, 103);

-- Insert data into Employees table
INSERT INTO Employees (Emp_Id, Name, Position, Shift_Timing, Salary, Performance_Score)
VALUES 
(101, 'Imelda', 'Waiter', 'Morning', 2500.00, 4.5),
(102, 'Joseph T-Rex', 'Manager', 'Full Day', 4000.00, 4.8),
(103, 'Propeller DJ', 'Chef', 'Evening', 3500.00, 4.6),
(104, 'Sophia Green', 'Host', 'Morning', 2800.00, 4.7),
(105, 'Dave', 'Sous Chef', 'Afternoon', 3300.00, 4.3),
(106, 'Atomix Tom', 'Cashier', 'Evening', 2600.00, 4.2),
(107, 'Roni Khau', 'Waiter', 'Night', 2500.00, 4.4),
(108, 'Joshua Babes', 'Bartender', 'Full Day', 3000.00, 4.5),
(109, 'Roland Opio', 'Dishwasher', 'Full Time', 2000.00, 3.8),
(110, 'Ronald Land', 'Waiter', 'Night', 2500.00, 4.2),
(111, 'Green Sport', 'Delivery', 'Evening', 2900.00, 4.1),
(112, 'Red Cardinal', 'Delivery', 'Full Day', 3000.00, 4.3);

-- Insert data into Supplied_Items table
INSERT INTO Supplied_Items (Sup_Id, Product_Id)
VALUES 
(1, 1), 
(2, 2), 
(3, 3),  
(1, 4);  


-- Insert data into Sales_Report table
INSERT INTO Sales_Report (Report_Id, Date, Total_Sales, Total_Orders, Top_Selling_Item)
VALUES 
(1, '2024-11-01', 1200.50, 30, 1),
(2, '2024-11-02', 1450.75, 40, 3),
(3, '2024-11-03', 980.00, 25, 2),
(4, '2024-11-04', 1600.00, 45, 4),
(5, '2024-11-05', 1325.25, 35, 1);
-- Insert data into Order_Items table
INSERT INTO Order_Items (Order_Item_Id, Order_Id, Menu_Id, Quantity, Price)
VALUES 
(1, 1, 1, 2, 24.000),
(2, 1, 2, 1, 6.000), 
(3, 2, 2, 2, 12.000),
(4, 3, 3, 1, 15.000), 
(5, 3, 4, 1, 12.000); 

-- Stock Table
CREATE TABLE Stock (
    Stock_Id INT PRIMARY KEY,
    Food_Stuffs INT DEFAULT 0,
    Beverages INT DEFAULT 0,
    Cutlery INT DEFAULT 0,
    Packaging_Items INT DEFAULT 0,
    Last_Updated DATE,  
    Threshold INT DEFAULT 0 CHECK (Threshold >= 0),
    Sup_Id INT,
    Emp_Id INT,
    FOREIGN KEY (Sup_Id) REFERENCES Suppliers(Sup_Id),
    FOREIGN KEY (Emp_Id) REFERENCES Employees(Emp_Id)
);

-- Inserting data into the Stock table
INSERT INTO Stock (Stock_Id, Food_Stuffs, Beverages, Cutlery, Packaging_Items, Last_Updated, Threshold, Sup_Id, Emp_Id)
VALUES 
(1, 200, 20, 00, 00, '2024-11-07', 10, 1, 102),  
(2, 10, 500, 00, 200, '2024-11-07', 15, 2, 102),  
(3, 00, 00, 200, 100, NULL, 5, 3, 103);              

SELECT * FROM customers;


-- stored procedures
drop PROCEDURE AddCustomer;
-- AddLoyaltyPoints
DELIMITER //

CREATE PROCEDURE AddLoyaltyPoints(IN CustId INT, IN Points INT)
BEGIN
    UPDATE Customers
    SET Loyalty_Points = Loyalty_Points + Points
    WHERE Cust_Id = CustId;
END //

DELIMITER ;

CALL AddLoyaltyPoints(1, 50);

--updateStock
DELIMITER //

CREATE PROCEDURE UpdateStock(IN ProductId INT, IN NewQuantity INT, IN SupplierId INT)
BEGIN
    UPDATE Stock
    SET Quantity = Quantity + NewQuantity, Last_Updated = CURRENT_DATE
    WHERE Product_Id = ProductId AND Sup_Id = SupplierId;
END //

DELIMITER ;
CALL UpdateStock(1, 100, 1);
DROP PROCEDURE `UpdateStock`;


--GetCustomerOrders
DELIMITER //

CREATE PROCEDURE GetCustomerOrders(IN CustId INT)
BEGIN
    SELECT Orders.Ord_Id, Orders.Date, Orders.Total_Amount, Orders.Status
    FROM Orders
    WHERE Orders.Cust_Id = CustId;
END //

DELIMITER ;
CALL GetCustomerOrders(1);

drop PROCEDURE `DailySalesReport`;

-- listProductsBySupplier
DELIMITER //

CREATE PROCEDURE ListProductsBySupplier(IN SupplierId INT)
BEGIN
    SELECT Products.Product_Name
    FROM Products
    JOIN Supplied_Items ON Products.Product_Id = Supplied_Items.Product_Id
    WHERE Supplied_Items.Sup_Id = SupplierId;
END //

DELIMITER ;
CALL ListProductsBySupplier(1);


--triggers
















