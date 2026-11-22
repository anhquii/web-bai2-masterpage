-- =======================================================================
-- PHASE 3: TẠO BẢNG ĐƠN HÀNG (Orders) & CHI TIẾT ĐƠN HÀNG (OrderDetails)
-- Database: MyStoreTech (Connection String: MyPhoneShopDBConnectionString)
-- =======================================================================
USE [MyStoreTech];
GO

-- 1. Tạo bảng dbo.Orders (Hóa đơn đặt hàng)
IF OBJECT_ID('dbo.Orders', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Orders] (
        [OrderId]       INT            IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [UserId]        INT            NULL, -- Cho phép NULL nếu khách vãng lai (Guest Checkout)
        [CustomerName]  NVARCHAR(100)  NOT NULL,
        [Phone]         VARCHAR(20)    NOT NULL,
        [Address]       NVARCHAR(255)  NOT NULL,
        [Note]          NVARCHAR(500)  NULL,
        [PaymentMethod] NVARCHAR(50)   NOT NULL, -- 'COD' hoặc 'BANK_QR'
        [ShippingFee]   DECIMAL(18, 2) NOT NULL DEFAULT (0),
        [TotalAmount]   DECIMAL(18, 2) NOT NULL,
        [Status]        NVARCHAR(50)   NOT NULL DEFAULT (N'Chờ xác nhận'),
        [OrderDate]     DATETIME       NOT NULL DEFAULT (GETDATE()),
        CONSTRAINT [FK_Orders_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([UserId])
    );
END
GO

-- 2. Tạo bảng dbo.OrderDetails (Chi tiết từng sản phẩm trong đơn hàng)
IF OBJECT_ID('dbo.OrderDetails', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[OrderDetails] (
        [OrderDetailId] INT            IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [OrderId]       INT            NOT NULL,
        [ProductId]     INT            NOT NULL,
        [Quantity]      INT            NOT NULL CHECK ([Quantity] > 0),
        [UnitPrice]     DECIMAL(18, 2) NOT NULL CHECK ([UnitPrice] >= 0),
        CONSTRAINT [FK_OrderDetails_Orders]   FOREIGN KEY ([OrderId])   REFERENCES [dbo].[Orders]([OrderId]) ON DELETE CASCADE,
        CONSTRAINT [FK_OrderDetails_Products] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Products]([ProductId])
    );
END
GO
