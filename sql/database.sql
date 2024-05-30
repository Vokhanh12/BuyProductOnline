CREATE DATABASE BuyProductOnline;
GO

USE BuyProductOnline;
GO

-- Tạo bảng HistoricalCatalogs 
CREATE TABLE HistoricalCatalogs(
    id INT PRIMARY KEY IDENTITY(1,1)
);
GO

-- Tạo bảng Histories
CREATE TABLE Histories(
    id INT PRIMARY KEY IDENTITY(1,1),
    history_catalog_id INT NOT NULL,
    [type] VARCHAR(3) NOT NULL,
    CONSTRAINT CHK_HistoryType CHECK ([type] IN ('HB')),
    FOREIGN KEY (history_catalog_id) REFERENCES HistoricalCatalogs(id)
);
GO

-- Tạo bảng CartCatalogs
CREATE TABLE CartCatalogs(
    id INT PRIMARY KEY IDENTITY(1,1)
);
GO

-- Tạo bảng Carts
CREATE TABLE Carts(
    id INT PRIMARY KEY IDENTITY(1,1),
    cart_catalog_id INT NOT NULL,
    FOREIGN KEY (cart_catalog_id) REFERENCES CartCatalogs(id)
);
GO

-- Tạo bảng Users
CREATE TABLE Users (
    id UNIQUEIDENTIFIER PRIMARY KEY,
    cart_catalog_id INT ,
    history_catalog_id INT,
    [name] NVARCHAR(25) NOT NULL,
    FOREIGN KEY (history_catalog_id) REFERENCES HistoricalCatalogs(id),
    FOREIGN KEY (cart_catalog_id) REFERENCES CartCatalogs(id)
);
GO

-- Tạo bảng Images
CREATE TABLE Images(
    id INT PRIMARY KEY IDENTITY(1,1),
    [url] VARCHAR(255) NOT NULL,
    [type] VARCHAR(5) NOT NULL,
    own_type VARCHAR(3) NOT NULL,
    CONSTRAINT CHK_ImageOwnType CHECK (own_type IN ('OS', 'OI')),
    CONSTRAINT CHK_ImageType CHECK ([type] IN ('IMAV', 'IMAL'))
);
GO

-- Tạo bảng ItemCatalogs
CREATE TABLE ItemCatalogs(
    id INT PRIMARY KEY IDENTITY(1,1),
    store_id INT NOT NULL,
    item_type VARCHAR(10) NOT NULL,
    CONSTRAINT CHK_ItemCatalog_ItemType CHECK (item_type IN ('D', 'F'))
);
GO

-- Tạo bảng EmployeeCatalog
CREATE TABLE EmployeeCatalog(
    id INT PRIMARY KEY IDENTITY(1,1)
);
GO

-- Tạo bảng Accounts
CREATE TABLE Accounts(
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id UNIQUEIDENTIFIER NOT NULL,
    [type] VARCHAR(1) NOT NULL,
    CONSTRAINT CHK_AccountType CHECK ([type] IN ('B', 'M', 'E')),
    CONSTRAINT UC_User_AccountType UNIQUE (user_id, [type]),
    FOREIGN KEY (user_id) REFERENCES Users(id)
);
GO

-- Tạo bảng Stores
CREATE TABLE Stores (
    id INT PRIMARY KEY IDENTITY(1,1),
    account_id INT NOT NULL,
    image_id INT NOT NULL,
    item_catalog_id INT NOT NULL,
    employee_catalog_id INT NOT NULL,
    [name] NVARCHAR(50) UNIQUE NOT NULL,
    FOREIGN KEY (account_id) REFERENCES Accounts(id),
    FOREIGN KEY (image_id) REFERENCES Images(id),
    FOREIGN KEY (item_catalog_id) REFERENCES ItemCatalogs(id),
    FOREIGN KEY (employee_catalog_id) REFERENCES EmployeeCatalog(id)
);
GO

-- Tạo bảng Bills
CREATE TABLE Bills(
    id INT PRIMARY KEY IDENTITY(1,1),
    store_id INT NOT NULL,
    cart_id INT NOT NULL,
    payment_by UNIQUEIDENTIFIER NOT NULL,
    confirmed_by UNIQUEIDENTIFIER NULL,
    payment_type VARCHAR(2) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    tax FLOAT NOT NULL,
    tax_total_amount DECIMAL(10, 2) NOT NULL,
    delivery_status INT NOT NULL, -- 0, 1
    order_date DATETIME NOT NULL,
    CONSTRAINT CHK_PaymentType CHECK (payment_type IN ('P', 'A')),
    FOREIGN KEY (store_id) REFERENCES Stores(id),
    FOREIGN KEY (cart_id) REFERENCES Carts(id),
    FOREIGN KEY (payment_by) REFERENCES Users(id),
    FOREIGN KEY (confirmed_by) REFERENCES Users(id)
);
GO

-- Tạo bảng PurchaseHistories
CREATE TABLE PurchaseHistories(
    id INT PRIMARY KEY IDENTITY(1,1),
    bill_id INT NOT NULL,
    history_id INT NOT NULL,
    FOREIGN KEY (bill_id) REFERENCES Bills(id),
    FOREIGN KEY (history_id) REFERENCES Histories(id)
);
GO

-- Tạo bảng Items
CREATE TABLE Items(
    id INT PRIMARY KEY IDENTITY(1,1),
    item_catalog_id INT NOT NULL,
    image_id INT NOT NULL,
    [name] NVARCHAR(25) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (item_catalog_id) REFERENCES ItemCatalogs(id),
    FOREIGN KEY (image_id) REFERENCES Images(id)
);
GO

-- Tạo bảng JobCatalog
CREATE TABLE JobCatalog(
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id UNIQUEIDENTIFIER NOT NULL,  
    store_id INT NOT NULL,
    total_hour_worked FLOAT NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (store_id) REFERENCES Stores(id)
);
GO

-- Tạo bảng ItemCarts
CREATE TABLE ItemCarts(
    id INT PRIMARY KEY IDENTITY(1,1),
    item_id INT NOT NULL,
    cart_id INT NOT NULL,
    quantity INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (item_id) REFERENCES Items(id),
    FOREIGN KEY (cart_id) REFERENCES Carts(id)
);
GO

-- Tạo trigger trên bảng Stores kiểm tra loại người dùng
CREATE OR ALTER TRIGGER trg_insert_Store_CheckUserType
ON Stores
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN AccountUsers a ON i.user_id = a.user_id
        WHERE a.UserType <> 'M'
    )
    BEGIN
        RAISERROR ('Chỉ người dùng thuộc loại "M" mới được phép tạo cửa hàng.', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END
GO

-- Tạo trigger trên bảng Images
CREATE OR ALTER TRIGGER trg_images
ON Images 
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.[type] NOT IN ('IMAV', 'IMAL')
    )
    BEGIN
        RAISERROR ('Chỉ có hình ảnh thuộc loại "IMAV", "IMAL" mới có thể được gán vào bảng Images', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.[own_type] NOT IN ('OS', 'OI')
    )
    BEGIN
        RAISERROR ('Chỉ có hình ảnh sở hữu "OI", "OI" mới có thể được gán vào bảng Images', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
    

    UPDATE Images
    SET [url] = 
        CASE 
            WHEN [type] = 'IMAV' AND [own_type] = 'OS' THEN '/images/stores/avarta/' + CAST(id AS VARCHAR(10)) + '.' + CAST(url AS VARCHAR(255))
            WHEN [type] = 'IMAV' AND [own_type] = 'OI' THEN '/images/items/avarta/' + CAST(id AS VARCHAR(10)) + '.' + CAST(url AS VARCHAR(255))
            WHEN [type] = 'IMAL' AND [own_type] = 'OS' THEN '/images/stores/album/' + CAST(id AS VARCHAR(10)) + '.' + CAST(url AS VARCHAR(255))
            WHEN [type] = 'IMAL' AND [own_type] = 'OI' THEN '/images/items/album/' + CAST(id AS VARCHAR(10)) + '.' + CAST(url AS VARCHAR(255))
        END
    WHERE id IN (SELECT id FROM inserted);

END
GO

-- Tạo trigger trên bảng Users Khi user được tạo thì 
CREATE OR ALTER TRIGGER trg_users
ON Users 
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Declare a variable to hold the new CartCatalogs id
    DECLARE @NewCartCatalogID INT;

    -- Insert a new record into CartCatalogs and get the new id
    INSERT INTO CartCatalogs DEFAULT VALUES;
    SET @NewCartCatalogID = SCOPE_IDENTITY();

    -- Insert into Carts using the new CartCatalogs id
    INSERT INTO Carts (cart_catalog_id)
    VALUES (@NewCartCatalogID);

    -- Insert Account
    INSERT INTO Accounts(user_id, [type])
    SELECT id, 'B'
    FROM INSERTED

    -- Update Users
    UPDATE Users
    SET cart_catalog_id = @NewCartCatalogID
    WHERE id IN(SELECT id FROM INSERTED)
END


GO

CREATE OR ALTER TRIGGER trg_Account
ON Accounts
AFTER INSERT
AS
BEGIN


    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.[type] IN ('E')
    )
    BEGIN
        INSERT INTO Employees

        RAISERROR ('Chỉ người dùng thuộc loại "M","E" mới được nâng cấp tài khoản', 16, 1);
        ROLLBACK TRANSACTION;
    END;

END











GO


SELECT MAX(id) AS MaxId FROM Images

SELECT * FROM CartCatalogs
SELECT * FROM Carts
SELECT * FROM Accounts



DELETE FROM CartCatalogs
WHERE id = 1


DROP TRIGGER trg_users

INSERT INTO 

INSERT INTO Images ([url], [type], own_type)
VALUES ('jpg','IMAV','OI');

DROP TRIGGER trg_images
DROP TABLE Images

SELECT * FROM Images

DELETE FROM Images
WHERE id = 8; 



--- INSERT Users

INSERT INTO Users (id, name)
VALUES (NEWID(), 'Nguyen Vo Khanh');

INSERT INTO Users (id, name)
VALUES (NEWID(), 'Nguyen Quoc Khanh');

INSERT INTO Users (id, name)
VALUES (NEWID(), 'Do Quoc Trung');

INSERT INTO Users (id, name)
VALUES (NEWID(), 'Nguyen Quoc Trung');

INSERT INTO Users (id, name)
VALUES (NEWID(), 'Nguyen Quoc Thanh');


--- Insert AccountUsers

INSERT INTO AccountUsers (user_id, UserType)
VALUES ('12fbd500-6dc1-4f08-a99e-3a2aecbfcc15', 'M') --- Manager


INSERT INTO AccountUsers (user_id, UserType)
VALUES ('c596c621-705a-4d61-b85c-3bfd98501701', 'B') --- Buyer


INSERT INTO AccountUsers (user_id, UserType)
VALUES ('30b0fd93-7861-4c2e-b6d5-46bfa0114f65', 'M') --- Employee


--- Insert Stores
INSERT INTO Stores(user_id, [name])
VALUES ('12fbd500-6dc1-4f08-a99e-3a2aecbfcc15','The Coffee Shop')

INSERT INTO Stores(user_id, [name])
VALUES ('12fbd500-6dc1-4f08-a99e-3a2aecbfcc15','Milano Coffee')

INSERT INTO Stores(user_id, [name])
VALUES ('30b0fd93-7861-4c2e-b6d5-46bfa0114f65','Bun Vit Nga tu')




SELECT * FROM Stores
SELECT * FROM Users
SELECT * FROM AccountUsers