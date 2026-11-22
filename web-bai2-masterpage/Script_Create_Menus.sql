USE [MyPhoneShopDB]
GO

-- =========================================================================
-- BƯỚC 1: ĐỒNG BỘ BẢNG dbo.Brand (DANH MỤC THƯƠNG HIỆU TOÀN HỆ THỐNG)
-- =========================================================================
IF NOT EXISTS (SELECT 1 FROM dbo.Brand WHERE BrandName = 'Apple')    INSERT INTO dbo.Brand (BrandName) VALUES (N'Apple');    -- BrandId = 1
IF NOT EXISTS (SELECT 1 FROM dbo.Brand WHERE BrandName = 'Samsung')  INSERT INTO dbo.Brand (BrandName) VALUES (N'Samsung');  -- BrandId = 2
IF NOT EXISTS (SELECT 1 FROM dbo.Brand WHERE BrandName = 'Xiaomi')   INSERT INTO dbo.Brand (BrandName) VALUES (N'Xiaomi');   -- BrandId = 3
IF NOT EXISTS (SELECT 1 FROM dbo.Brand WHERE BrandName = 'Dell')     INSERT INTO dbo.Brand (BrandName) VALUES (N'Dell');     -- BrandId = 4
IF NOT EXISTS (SELECT 1 FROM dbo.Brand WHERE BrandName = 'Asus')     INSERT INTO dbo.Brand (BrandName) VALUES (N'Asus');     -- BrandId = 5
IF NOT EXISTS (SELECT 1 FROM dbo.Brand WHERE BrandName = 'Logitech') INSERT INTO dbo.Brand (BrandName) VALUES (N'Logitech'); -- BrandId = 6
IF NOT EXISTS (SELECT 1 FROM dbo.Brand WHERE BrandName = 'Razer')    INSERT INTO dbo.Brand (BrandName) VALUES (N'Razer');    -- BrandId = 7
IF NOT EXISTS (SELECT 1 FROM dbo.Brand WHERE BrandName = 'Ducky')    INSERT INTO dbo.Brand (BrandName) VALUES (N'Ducky');    -- BrandId = 8
GO

-- =========================================================================
-- BƯỚC 2: XÓA VÀ TẠO MỚI BẢNG dbo.Menus (CHUẨN 5 CỘT TỐI GIẢN)
-- =========================================================================
IF OBJECT_ID('dbo.Menus', 'U') IS NOT NULL 
    DROP TABLE dbo.Menus;
GO

CREATE TABLE dbo.Menus (
    [ID_MN]     BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,  -- Khóa chính tự tăng
    [Parent]    BIGINT NOT NULL DEFAULT(0),                 -- 0: Menu Cha | >0: Menu Con (trỏ về ID_MN cha)
    [Lable]     NVARCHAR(200) NOT NULL,                     -- Tên hiển thị trên menu
    [UrlLink]   VARCHAR(200) NOT NULL DEFAULT('#'),         -- Đường dẫn chuyển trang có tham số lọc
    [OrderKey]  BIGINT NOT NULL DEFAULT(1)                  -- Thứ tự sắp xếp từ trái qua phải
);
GO

-- =========================================================================
-- BƯỚC 3: NẠP DỮ LIỆU MENU CHA (Parent = 0 - Các Nhóm Ngành Hàng Lớn)
-- Tự sinh ID_MN: 1 = Điện Thoại, 2 = Laptop, 3 = Bàn Phím
-- =========================================================================
INSERT INTO dbo.Menus ([Parent], [Lable], [UrlLink], [OrderKey])
VALUES 
(0, N'Điện Thoại', 'Default.aspx?cat=phone', 1),    -- ID_MN = 1
(0, N'Laptop',     'Default.aspx?cat=laptop', 2),   -- ID_MN = 2
(0, N'Bàn Phím',   'Default.aspx?cat=keyboard', 3); -- ID_MN = 3
GO

-- =========================================================================
-- BƯỚC 4: NẠP MENU CON ĐIỆN THOẠI (Parent = 1): iPhone, Samsung, Xiaomi
-- =========================================================================
INSERT INTO dbo.Menus ([Parent], [Lable], [UrlLink], [OrderKey])
VALUES 
(1, N'iPhone',  'Default.aspx?cat=phone&brand=1', 1),
(1, N'Samsung', 'Default.aspx?cat=phone&brand=2', 2),
(1, N'Xiaomi',  'Default.aspx?cat=phone&brand=3', 3);
GO

-- =========================================================================
-- BƯỚC 5: NẠP MENU CON LAPTOP (Parent = 2): Dell, Asus, MacBook
-- =========================================================================
INSERT INTO dbo.Menus ([Parent], [Lable], [UrlLink], [OrderKey])
VALUES 
(2, N'Dell',    'Default.aspx?cat=laptop&brand=4', 1),
(2, N'Asus',    'Default.aspx?cat=laptop&brand=5', 2),
(2, N'MacBook', 'Default.aspx?cat=laptop&brand=1', 3);
GO

-- =========================================================================
-- BƯỚC 6: NẠP MENU CON BÀN PHÍM (Parent = 3): Logitech, Razer, Ducky
-- =========================================================================
INSERT INTO dbo.Menus ([Parent], [Lable], [UrlLink], [OrderKey])
VALUES 
(3, N'Logitech', 'Default.aspx?cat=keyboard&brand=6', 1),
(3, N'Razer',    'Default.aspx?cat=keyboard&brand=7', 2),
(3, N'Ducky',    'Default.aspx?cat=keyboard&brand=8', 3);
GO

-- =========================================================================
-- BƯỚC 7: KIỂM TRA TOÀN BỘ CÂY MENU ĐA CẤP VỪA TẠO
-- =========================================================================
SELECT [ID_MN], [Parent], [Lable], [UrlLink], [OrderKey] 
FROM dbo.Menus 
ORDER BY [Parent] ASC, [OrderKey] ASC;
GO
