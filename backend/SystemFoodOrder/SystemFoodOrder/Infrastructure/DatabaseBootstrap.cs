using Microsoft.EntityFrameworkCore;
using SystemFoodOrder.Data;
using SystemFoodOrder.Model.Entities;

namespace SystemFoodOrder.Infrastructure;

/// <summary>Tạo bảng CART_ITEM nếu thiếu; seed demo khi DB trống sản phẩm.</summary>
public static class DatabaseBootstrap
{
    private static class DemoImages
    {
        internal const string Pho = "https://images.unsplash.com/photo-1559329489-8ef2d1a15da5?w=640&h=640&fit=crop&q=80";
        internal const string Coffee = "https://images.unsplash.com/photo-1511920170033-f8396924c348?w=640&h=640&fit=crop&q=80";
        internal const string MilkTea = "https://images.unsplash.com/photo-1558856526-2507e798709c?w=640&h=640&fit=crop&q=80";
        internal const string BanhMi = "https://images.unsplash.com/photo-1601050690597-df0568f70950?w=640&h=640&fit=crop&q=80";
        internal const string BunCha = "https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=640&h=640&fit=crop&q=80";
        internal const string GoiCuon = "https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=640&h=640&fit=crop&q=80";
        internal const string ComTam = "https://images.unsplash.com/photo-1604908177093-5865de0125fa?w=640&h=640&fit=crop&q=80";
        internal const string Che = "https://images.unsplash.com/photo-1488477181946-6428a0291777?w=640&h=640&fit=crop&q=80";
        internal const string NuocMia = "https://images.unsplash.com/photo-1546173159-315724a31696?w=640&h=640&fit=crop&q=80";
    }

    public static async Task RunAsync(AppDbContext db, CancellationToken ct = default)
    {
        await EnsureCartItemTableAsync(db, ct);
        await EnsureBlogAndNotificationTablesAsync(db, ct);
        await EnsureDemoCatalogAsync(db, ct);
    }

    private static async Task EnsureCartItemTableAsync(AppDbContext db, CancellationToken ct)
    {
        const string sql = @"
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'CART_ITEM')
BEGIN
    CREATE TABLE CART_ITEM (
        cartItemId INT IDENTITY(1,1) PRIMARY KEY,
        userId INT NOT NULL,
        productId INT NOT NULL,
        quantity INT NOT NULL CHECK (quantity > 0),
        updatedAt DATETIME NULL DEFAULT GETDATE(),
        CONSTRAINT FK_CartItem_User FOREIGN KEY (userId) REFERENCES [USER](userId) ON DELETE CASCADE,
        CONSTRAINT FK_CartItem_Product FOREIGN KEY (productId) REFERENCES PRODUCT(productId),
        CONSTRAINT UQ_CartItem_User_Product UNIQUE (userId, productId)
    );
END";
        await db.Database.ExecuteSqlRawAsync(sql, cancellationToken: ct);
    }

    // Ensure Blog and Notification tables exist
    private static async Task EnsureBlogAndNotificationTablesAsync(AppDbContext db, CancellationToken ct)
    {
        const string sql = @"
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BLOG')
BEGIN
    CREATE TABLE BLOG (
        blogId INT IDENTITY(1,1) PRIMARY KEY,
        userId INT NULL,
        title NVARCHAR(500) NOT NULL,
        content NVARCHAR(MAX) NOT NULL,
        createdAt DATETIME NULL,
        CONSTRAINT FK_Blog_User FOREIGN KEY (userId) REFERENCES [USER](userId)
    );
END;
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'NOTIFICATION')
BEGIN
    CREATE TABLE NOTIFICATION (
        notificationId INT IDENTITY(1,1) PRIMARY KEY,
        userId INT NULL,
        title NVARCHAR(500) NULL,
        message NVARCHAR(MAX) NULL,
        isRead BIT NOT NULL DEFAULT 0,
        createdAt DATETIME NULL,
        CONSTRAINT FK_Notification_User FOREIGN KEY (userId) REFERENCES [USER](userId)
    );
END";
        await db.Database.ExecuteSqlRawAsync(sql, cancellationToken: ct);
    }

    private static async Task EnsureDemoCatalogAsync(AppDbContext db, CancellationToken ct)
    {
        if (await db.Products.AsNoTracking().AnyAsync(ct))
            return;

        if (!await db.Roles.AsNoTracking().AnyAsync(ct))
        {
            db.Roles.AddRange(
                new Role { RoleName = "Customer" },
                new Role { RoleName = "ShopOwner" });
            await db.SaveChangesAsync(ct);
        }

        var customerRoleId = await db.Roles.AsNoTracking()
            .Where(r => r.RoleName == "Customer")
            .Select(r => r.RoleId)
            .FirstAsync(ct);
        var shopRoleId = await db.Roles.AsNoTracking()
            .Where(r => r.RoleName == "ShopOwner")
            .Select(r => r.RoleId)
            .FirstAsync(ct);

        if (!await db.Users.AsNoTracking().AnyAsync(u => u.Username == "customer1", ct))
        {
            db.Users.Add(new User
            {
                Username = "customer1",
                FullName = "Khách demo",
                Password = "123456",
                Email = "customer@test.com",
                RoleId = customerRoleId,
                IsActive = true
            });
            await db.SaveChangesAsync(ct);
        }

        User shopUser;
        var existingShop = await db.Users.AsNoTracking()
            .FirstOrDefaultAsync(u => u.Username == "shopowner1", ct);
        if (existingShop == null)
        {
            db.Users.Add(new User
            {
                Username = "shopowner1",
                FullName = "Chủ quán demo",
                Password = "123456",
                Email = "shop@test.com",
                RoleId = shopRoleId,
                IsActive = true
            });
            await db.SaveChangesAsync(ct);
            shopUser = await db.Users.AsNoTracking().FirstAsync(u => u.Username == "shopowner1", ct);
        }
        else
            shopUser = existingShop;

        var uid = shopUser.UserId;
        db.Products.AddRange(
            new Product { UserId = uid, Name = "Phở bò đặc biệt", Category = "Món chính", Price = 65000, Description = "Thịt bò + gân", IsAvailable = true, AvatarProducts = DemoImages.Pho },
            new Product { UserId = uid, Name = "Bún chả Hà Nội", Category = "Món chính", Price = 55000, Description = "Thịt nướng than hoa", IsAvailable = true, AvatarProducts = DemoImages.BunCha },
            new Product { UserId = uid, Name = "Cơm tấm sườn bì", Category = "Món chính", Price = 48000, Description = "Sườn nướng + bì chả", IsAvailable = true, AvatarProducts = DemoImages.ComTam },
            new Product { UserId = uid, Name = "Bánh mì thịt nướng", Category = "Món chính", Price = 25000, Description = "Patê + dưa chua", IsAvailable = true, AvatarProducts = DemoImages.BanhMi },
            new Product { UserId = uid, Name = "Gỏi cuốn tôm thịt", Category = "Khai vị", Price = 35000, Description = "10 cuốn", IsAvailable = true, AvatarProducts = DemoImages.GoiCuon },
            new Product { UserId = uid, Name = "Cà phê sữa đá", Category = "Đồ uống", Price = 28000, Description = "Đậm vị phin", IsAvailable = true, AvatarProducts = DemoImages.Coffee },
            new Product { UserId = uid, Name = "Trà sữa trân châu", Category = "Đồ uống", Price = 45000, Description = "Ít đường", IsAvailable = true, AvatarProducts = DemoImages.MilkTea },
            new Product { UserId = uid, Name = "Nước mía đá", Category = "Đồ uống", Price = 15000, Description = "Mía tươi", IsAvailable = true, AvatarProducts = DemoImages.NuocMia },
            new Product { UserId = uid, Name = "Chè thập cẩm", Category = "Tráng miệng", Price = 22000, Description = "Bánh lọt", IsAvailable = true, AvatarProducts = DemoImages.Che });
        await db.SaveChangesAsync(ct);

        if (!await db.Discounts.AsNoTracking().AnyAsync(d => d.DiscountCode == "WELCOME10", ct))
        {
            db.Discounts.Add(new Discount
            {
                UserId = shopUser.UserId,
                DiscountCode = "WELCOME10",
                StartDate = DateTime.UtcNow.AddDays(-1),
                EndDate = DateTime.UtcNow.AddYears(1),
                PercentDiscount = 10,
                IsActived = true
            });
            await db.SaveChangesAsync(ct);
        }
    }
}
