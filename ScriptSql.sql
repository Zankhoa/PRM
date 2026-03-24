
create database FoodOrderSystem
---------------------------------
USE FoodOrderSystem
-- 1. Bảng Vai trò (ROLE)
CREATE TABLE [ROLE] (
    roleId INT IDENTITY(1,1) PRIMARY KEY,
    roleName NVARCHAR(50) NOT NULL UNIQUE
);
-- 2. Bảng Người dùng (USER)
CREATE TABLE [USER] (
    userId INT IDENTITY(1,1) PRIMARY KEY,
    avatarUser NVARCHAR(MAX),
    username VARCHAR(50) NOT NULL UNIQUE,
    fullName NVARCHAR(100) NOT NULL,
    [password] VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100) UNIQUE,
    [address] NVARCHAR(MAX),
    createdAt DATETIME DEFAULT GETDATE(),
    isActive BIT DEFAULT 1,
    roleId INT,
    CONSTRAINT FK_User_Role FOREIGN KEY (roleId) REFERENCES [ROLE](roleId)
);

-- 3. Bảng Sản phẩm (PRODUCT) - Trong Food Order nên hiểu là Món Ăn
CREATE TABLE PRODUCT (
    productId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT, -- Người tạo (thường là chủ quán/Merchant)
    [name] NVARCHAR(255) NOT NULL,
    avatarProducts NVARCHAR(MAX),
    category NVARCHAR(100), -- Sau này nên tách thành bảng Category riêng
    price DECIMAL(18, 2) NOT NULL,
    [description] NVARCHAR(MAX),
    isAvailable BIT DEFAULT 1,
    createdAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Product_User FOREIGN KEY (userId) REFERENCES [USER](userId)
);

-- 4. Bảng Đơn hàng (ORDER)
CREATE TABLE [ORDER] (
    orderId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT, -- Khách hàng đặt
    totalPrice DECIMAL(18, 2) NOT NULL,
    deliveryFee DECIMAL(18, 2) DEFAULT 0,
    [status] NVARCHAR(50) DEFAULT N'Pending',
    createdAt DATETIME DEFAULT GETDATE(),
    deliveryAddress NVARCHAR(MAX),
    CONSTRAINT FK_Order_User FOREIGN KEY (userId) REFERENCES [USER](userId)
);

-- 5. Bảng Chi tiết đơn hàng (ORDER_DETAIL)
CREATE TABLE ORDER_DETAIL (
    orderDetailId INT IDENTITY(1,1) PRIMARY KEY,
    orderId INT,
    productId INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(18, 2) NOT NULL, -- Lưu giá tại thời điểm mua
    note NVARCHAR(MAX),
    CONSTRAINT FK_Detail_Order FOREIGN KEY (orderId) REFERENCES [ORDER](orderId) ON DELETE CASCADE,
    CONSTRAINT FK_Detail_Product FOREIGN KEY (productId) REFERENCES PRODUCT(productId)
);

-- 6. Bảng Thanh toán (PAYMENT)
CREATE TABLE PAYMENT (
    paymentId INT IDENTITY(1,1) PRIMARY KEY,
    orderId INT UNIQUE, 
    paymentMethod NVARCHAR(50),
    amount DECIMAL(18, 2) NOT NULL,
    [status] NVARCHAR(50),
    createdAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Payment_Order FOREIGN KEY (orderId) REFERENCES [ORDER](orderId)
);
--7 bảng discount 
CREATE TABLE DISCOUNT (
    discountId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT, -- Người dùng sở hữu/được áp dụng mã giảm giá
    discountCode VARCHAR(50) NOT NULL UNIQUE,
    startDate DATETIME,
    percentDiscount int, 
    endDate DATETIME,
    isActived BIT DEFAULT 1,
    orderId INT, 
    CONSTRAINT FK_Discount_User FOREIGN KEY (userId) REFERENCES [USER](userId),
    CONSTRAINT FK_Discount_Order FOREIGN KEY (orderId) REFERENCES [ORDER](orderId)
);