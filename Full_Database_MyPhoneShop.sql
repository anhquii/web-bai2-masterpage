-- ==============================================================================
-- DỰ ÁN: MYPHONESHOP (ASP.NET WEB FORMS + LINQ TO SQL)
-- TẬP TIN: Full_Database_MyPhoneShop.sql
-- MÔ TẢ: SCRIPT KHỞI TẠO TOÀN DIỆN VÀ MỚI NHẤT DÀNH CHO CSDL MyPhoneShopDB
-- CÁC BẢNG:
--   1. dbo.Brand    : Danh mục thương hiệu (Apple, Samsung, Xiaomi, Dell,...)
--   2. dbo.Products : Danh sách sản phẩm điện thoại (Khóa ngoại -> Brand)
--   3. dbo.Users    : Tài khoản phân quyền (Admin / User, SHA-256 + Salt)
--   4. dbo.Menus    : Danh mục menu đa cấp (Parent-Child) cho Master Page
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- BƯỚC 1: TẠO VÀ SỬ DỤNG CƠ SỞ DỮ LIỆU
-- ------------------------------------------------------------------------------
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'MyPhoneShopDB')
BEGIN
    CREATE DATABASE [MyPhoneShopDB];
    PRINT N'✔ Đã tạo mới cơ sở dữ liệu MyPhoneShopDB thành công.';
END
ELSE
BEGIN
    PRINT N'✔ Cơ sở dữ liệu MyPhoneShopDB đã tồn tại.';
END
GO

USE [MyPhoneShopDB];
GO

-- Tắt bộ nhớ đệm Identity để tránh lỗi nhảy cóc ID (nhảy lên 1000) khi khởi động lại SQL Server
ALTER DATABASE SCOPED CONFIGURATION SET IDENTITY_CACHE = OFF;
GO

-- ------------------------------------------------------------------------------
-- BƯỚC 2: XÓA CÁC BẢNG CŨ THEO ĐÚNG THỨ TỰ RÀNG BUỘC KHÓA NGOẠI (NẾU CÓ)
-- ------------------------------------------------------------------------------
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID('dbo.Brand', 'U')    IS NOT NULL DROP TABLE dbo.Brand;
IF OBJECT_ID('dbo.Users', 'U')    IS NOT NULL DROP TABLE dbo.Users;
IF OBJECT_ID('dbo.Menus', 'U')    IS NOT NULL DROP TABLE dbo.Menus;
GO
PRINT N'✔ Đã dọn dẹp các bảng cũ sạch sẽ.';
GO

-- ------------------------------------------------------------------------------
-- BƯỚC 3: TẠO BẢNG 1 - THƯƠNG HIỆU (dbo.Brand)
-- ------------------------------------------------------------------------------
CREATE TABLE dbo.Brand (
    BrandId   INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    BrandName NVARCHAR(100) NOT NULL UNIQUE
);
GO

-- ------------------------------------------------------------------------------
-- BƯỚC 4: TẠO BẢNG 2 - SẢN PHẨM (dbo.Products)
-- ------------------------------------------------------------------------------
CREATE TABLE dbo.Products (
    ProductId   INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ProductName NVARCHAR(200) NOT NULL,
    Price       DECIMAL(18,2) NOT NULL,
    Image       NVARCHAR(255) NULL,
    BrandId     INT NOT NULL,
    CONSTRAINT FK_Products_Brand FOREIGN KEY (BrandId) 
        REFERENCES dbo.Brand(BrandId) 
        ON DELETE CASCADE
);
GO

-- ------------------------------------------------------------------------------
-- BƯỚC 5: TẠO BẢNG 3 - NGƯỜI DÙNG & BẢO MẬT (dbo.Users)
-- [Bảo mật]: PasswordHash (SHA-256 độ dài 64 hex), Salt (chuỗi muối 32 ký tự)
-- ------------------------------------------------------------------------------
CREATE TABLE dbo.Users (
    UserId       INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Username     NVARCHAR(50) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(64) NOT NULL,
    Salt         NVARCHAR(32) NOT NULL,
    Role         NVARCHAR(20) NOT NULL DEFAULT 'User' -- 'Admin' hoặc 'User'
);
GO

-- ------------------------------------------------------------------------------
-- BƯỚC 6: TẠO BẢNG 4 - MENU ĐA CẤP (dbo.Menus)
-- [Lưu ý]: Cột 'Lable' giữ nguyên theo đúng ánh xạ MyPhoneShop.dbml & user.Master
-- ------------------------------------------------------------------------------
CREATE TABLE dbo.Menus (
    [ID_MN]    BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,  -- Khóa chính tự tăng
    [Parent]   BIGINT NOT NULL DEFAULT(0),                 -- 0: Menu Cha | > 0: Menu Con (trỏ về ID_MN cha)
    [Lable]    NVARCHAR(200) NOT NULL,                     -- Tên hiển thị trên menu
    [UrlLink]  VARCHAR(200) NOT NULL DEFAULT('#'),         -- Liên kết trang kèm tham số lọc
    [OrderKey] BIGINT NOT NULL DEFAULT(1)                  -- Thứ tự sắp xếp từ trái sang phải
);
GO
PRINT N'✔ Đã tạo thành công cấu trúc 4 bảng dữ liệu chuẩn.';
GO

-- ==============================================================================
-- BƯỚC 7: NẠP DỮ LIỆU MẪU ĐẦY ĐỦ CHO TOÀN BỘ HỆ THỐNG
-- ==============================================================================

-- 7.1 Nạp 8 Thương hiệu (Khớp với Menu phân cấp)
INSERT INTO dbo.Brand (BrandName) VALUES 
(N'Apple'),     -- BrandId = 1
(N'Samsung'),   -- BrandId = 2
(N'Xiaomi'),    -- BrandId = 3
(N'Dell'),       -- BrandId = 4
(N'Asus'),       -- BrandId = 5
(N'Logitech'),   -- BrandId = 6
(N'Razer'),      -- BrandId = 7
(N'Ducky');      -- BrandId = 8
GO

-- 7.2 Nạp Danh sách Sản phẩm mẫu (Hình ảnh chuẩn khớp với thư mục Content/Images)
INSERT INTO dbo.Products (ProductName, Price, Image, BrandId) VALUES 
-- Apple (BrandId = 1)
(N'iPhone 15 Pro Max 256GB', 29990000, 'iphone15promax.png', 1),
(N'iPhone 14 128GB Chính Hãng VN/A', 17490000, 'iphone14.png', 1),
(N'iPhone 13 128GB Chính Hãng VN/A', 13990000, 'iphone13.png', 1),

-- Samsung (BrandId = 2)
(N'Samsung Galaxy S24 Ultra 5G 256GB', 27990000, 's24ultra.png', 2),
(N'Samsung Galaxy Z Flip5 256GB', 16990000, 'zflip5.png', 2),
(N'Samsung Galaxy A54 5G 128GB', 7490000, 'a54.png', 2),

-- Xiaomi (BrandId = 3)
(N'Xiaomi 14 5G (12GB/256GB)', 19990000, 'xiaomi14.png', 3),
(N'Xiaomi Redmi Note 13 (6GB/128GB)', 4490000, 'redminote13.png', 3);
GO

-- 7.3 Nạp Tài khoản Mẫu (Chuẩn mã hóa SHA-256 + Salt)
-- 1. Tài khoản Quản trị:
--    Username: admin
--    Password gốc: admin123
--    Salt: a1b2c3d4e5f6
--    PasswordHash: SHA256("admin123" + "a1b2c3d4e5f6") = e96ecdfd3911b4ce1404b1de8286ef41db2836a2f38e86046a3d296a80d66476
-- 2. Tài khoản Người dùng:
--    Username: khachhang
--    Password gốc: 123456
--    Salt: 9f8e7d6c5b4a
--    PasswordHash: SHA256("123456" + "9f8e7d6c5b4a") = a4b1f4db3c7e0c90538a7e6c46a6f0d14b43f9a738740c0fdf783451e065ff4e
INSERT INTO dbo.Users (Username, PasswordHash, Salt, Role) VALUES 
(N'admin', 'e96ecdfd3911b4ce1404b1de8286ef41db2836a2f38e86046a3d296a80d66476', 'a1b2c3d4e5f6', 'Admin'),
(N'khachhang', 'a4b1f4db3c7e0c90538a7e6c46a6f0d14b43f9a738740c0fdf783451e065ff4e', '9f8e7d6c5b4a', 'User');
GO

-- 7.4 Nạp Hệ thống Menu Đa cấp (Theo đúng cấu trúc user.Master)
-- [Menu Cha]: Parent = 0 (Điện Thoại, Laptop, Bàn Phím)
INSERT INTO dbo.Menus ([Parent], [Lable], [UrlLink], [OrderKey]) VALUES 
(0, N'Điện Thoại', 'Default.aspx?cat=phone', 1),    -- ID_MN = 1
(0, N'Laptop',     'Default.aspx?cat=laptop', 2),   -- ID_MN = 2
(0, N'Bàn Phím',   'Default.aspx?cat=keyboard', 3); -- ID_MN = 3
GO

-- [Menu Con]: Parent = 1 (Con của Điện Thoại -> trỏ về Brand 1, 2, 3)
INSERT INTO dbo.Menus ([Parent], [Lable], [UrlLink], [OrderKey]) VALUES 
(1, N'iPhone',  'Default.aspx?brand=1', 1),
(1, N'Samsung', 'Default.aspx?brand=2', 2),
(1, N'Xiaomi',  'Default.aspx?brand=3', 3);
GO

-- [Menu Con]: Parent = 2 (Con của Laptop -> Dell, Asus, MacBook)
INSERT INTO dbo.Menus ([Parent], [Lable], [UrlLink], [OrderKey]) VALUES 
(2, N'Dell',    'Default.aspx?brand=4', 1),
(2, N'Asus',    'Default.aspx?brand=5', 2),
(2, N'MacBook', 'Default.aspx?brand=1', 3);
GO

-- [Menu Con]: Parent = 3 (Con của Bàn Phím -> Logitech, Razer, Ducky)
INSERT INTO dbo.Menus ([Parent], [Lable], [UrlLink], [OrderKey]) VALUES 
(3, N'Logitech', 'Default.aspx?brand=6', 1),
(3, N'Razer',    'Default.aspx?brand=7', 2),
(3, N'Ducky',    'Default.aspx?brand=8', 3);
GO

PRINT N'✔ Đã nạp toàn bộ dữ liệu mẫu thành công!';
GO

-- ==============================================================================
-- BƯỚC 8: TRUY VẤN KIỂM TRA NHANH KẾT QUẢ VỪA TẠO
-- ==============================================================================
PRINT N'---------------------------------------------------';
PRINT N'1. DANH SÁCH THƯƠNG HIỆU (dbo.Brand):';
SELECT * FROM dbo.Brand;

PRINT N'---------------------------------------------------';
PRINT N'2. DANH SÁCH SẢN PHẨM & TÊN HÃNG (JOIN Products & Brand):';
SELECT p.ProductId, p.ProductName, p.Price, p.Image, b.BrandName
FROM dbo.Products p 
INNER JOIN dbo.Brand b ON p.BrandId = b.BrandId;

PRINT N'---------------------------------------------------';
PRINT N'3. DANH SÁCH TÀI KHOẢN (dbo.Users):';
SELECT UserId, Username, Role, Salt FROM dbo.Users;

PRINT N'---------------------------------------------------';
PRINT N'4. CÂY MENU ĐA CẤP (dbo.Menus):';
SELECT ID_MN, Parent, Lable, UrlLink, OrderKey 
FROM dbo.Menus 
ORDER BY Parent ASC, OrderKey ASC;
GO
