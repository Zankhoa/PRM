using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using SystemFoodOrder.Model.Entities;

namespace SystemFoodOrder.Data;

public partial class AppDbContext : DbContext
{
    public AppDbContext()
    {
    }

    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Order> Orders { get; set; }

    public virtual DbSet<OrderDetail> OrderDetails { get; set; }

    public virtual DbSet<Payment> Payments { get; set; }

    public virtual DbSet<Product> Products { get; set; }
    public virtual DbSet<CartItem> CartItems { get; set; }
    public virtual DbSet<Discount> Discounts { get; set; }
    public virtual DbSet<Role> Roles { get; set; }

    public virtual DbSet<User> Users { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        if (!optionsBuilder.IsConfigured)
        {
            var config = new ConfigurationBuilder()
                .AddJsonFile("appsettings.json").Build();
            optionsBuilder.UseSqlServer(config.GetConnectionString("DefaultConnection"));
        }
    }
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Order>(entity =>
        {
            entity.HasKey(e => e.OrderId).HasName("PK__ORDER__0809335DA7D2EC77");

            entity.ToTable("ORDER");

            entity.Property(e => e.OrderId).HasColumnName("orderId");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("createdAt");
            entity.Property(e => e.DeliveryAddress).HasColumnName("deliveryAddress");
            entity.Property(e => e.DeliveryFee)
                .HasDefaultValue(0m)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("deliveryFee");
            entity.Property(e => e.Status)
                .HasMaxLength(50)
                .HasDefaultValue("Pending")
                .HasColumnName("status");
            entity.Property(e => e.TotalPrice)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("totalPrice");
            entity.Property(e => e.UserId).HasColumnName("userId");

            entity.HasOne(d => d.User).WithMany(p => p.Orders)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK_Order_User");
        });

        modelBuilder.Entity<OrderDetail>(entity =>
        {
            entity.HasKey(e => e.OrderDetailId).HasName("PK__ORDER_DE__E4FEDE4AC6F4726C");

            entity.ToTable("ORDER_DETAIL");

            entity.Property(e => e.OrderDetailId).HasColumnName("orderDetailId");
            entity.Property(e => e.Note).HasColumnName("note");
            entity.Property(e => e.OrderId).HasColumnName("orderId");
            entity.Property(e => e.Price)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("price");
            entity.Property(e => e.ProductId).HasColumnName("productId");
            entity.Property(e => e.Quantity).HasColumnName("quantity");

            entity.HasOne(d => d.Order).WithMany(p => p.OrderDetails)
                .HasForeignKey(d => d.OrderId)
                .OnDelete(DeleteBehavior.Cascade)
                .HasConstraintName("FK_Detail_Order");

            entity.HasOne(d => d.Product).WithMany(p => p.OrderDetails)
                .HasForeignKey(d => d.ProductId)
                .HasConstraintName("FK_Detail_Product");
        });

        modelBuilder.Entity<Payment>(entity =>
        {
            entity.HasKey(e => e.PaymentId).HasName("PK__PAYMENT__A0D9EFC6FFEC5968");

            entity.ToTable("PAYMENT");

            entity.HasIndex(e => e.OrderId, "UQ__PAYMENT__0809335C4D1C7EB0").IsUnique();

            entity.Property(e => e.PaymentId).HasColumnName("paymentId");
            entity.Property(e => e.Amount)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("amount");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("createdAt");
            entity.Property(e => e.OrderId).HasColumnName("orderId");
            entity.Property(e => e.PaymentMethod)
                .HasMaxLength(50)
                .HasColumnName("paymentMethod");
            entity.Property(e => e.Status)
                .HasMaxLength(50)
                .HasColumnName("status");

            entity.HasOne(d => d.Order).WithOne(p => p.Payment)
                .HasForeignKey<Payment>(d => d.OrderId)
                .HasConstraintName("FK_Payment_Order");
        });

        modelBuilder.Entity<Product>(entity =>
        {
            entity.HasKey(e => e.ProductId).HasName("PK__PRODUCT__2D10D16AF5818436");

            entity.ToTable("PRODUCT");

            entity.Property(e => e.ProductId).HasColumnName("productId");
            entity.Property(e => e.AvatarProducts).HasColumnName("avatarProducts");
            entity.Property(e => e.Category)
                .HasMaxLength(100)
                .HasColumnName("category");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("createdAt");
            entity.Property(e => e.Description).HasColumnName("description");
            entity.Property(e => e.IsAvailable)
                .HasDefaultValue(true)
                .HasColumnName("isAvailable");
            entity.Property(e => e.Name)
                .HasMaxLength(255)
                .HasColumnName("name");
            entity.Property(e => e.Price)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("price");
            entity.Property(e => e.UserId).HasColumnName("userId");

            entity.HasOne(d => d.User).WithMany(p => p.Products)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK_Product_User");
        });
        modelBuilder.Entity<CartItem>(entity =>
        {
            entity.HasKey(e => e.CartItemId).HasName("PK_CART_ITEM");

            entity.ToTable("CART_ITEM");

            entity.Property(e => e.CartItemId).HasColumnName("cartItemId");
            entity.Property(e => e.UserId).HasColumnName("userId");
            entity.Property(e => e.ProductId).HasColumnName("productId");
            entity.Property(e => e.Quantity).HasColumnName("quantity");
            entity.Property(e => e.UpdatedAt).HasColumnName("updatedAt");

            //entity.HasOne(d => d.User).WithMany(p => p.CartItems)
            //    .HasForeignKey(d => d.UserId)
            //    .OnDelete(DeleteBehavior.Cascade);

            //entity.HasOne(d => d.Product).WithMany(p => p.CartItems)
            //    .HasForeignKey(d => d.ProductId)
            //    .OnDelete(DeleteBehavior.Cascade);

            entity.HasIndex(e => new { e.UserId, e.ProductId }).IsUnique();
        });

        modelBuilder.Entity<Role>(entity =>
        {
            entity.HasKey(e => e.RoleId).HasName("PK__ROLE__CD98462AF67A99C6");

            entity.ToTable("ROLE");

            entity.HasIndex(e => e.RoleName, "UQ__ROLE__B1947861A3D51D15").IsUnique();

            entity.Property(e => e.RoleId).HasColumnName("roleId");
            entity.Property(e => e.RoleName)
                .HasMaxLength(50)
                .HasColumnName("roleName");
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("PK__USER__CB9A1CFF888C4452");

            entity.ToTable("USER");

            entity.HasIndex(e => e.Email, "UQ__USER__AB6E61646380C276").IsUnique();

            entity.HasIndex(e => e.Username, "UQ__USER__F3DBC572CF706127").IsUnique();

            entity.Property(e => e.UserId).HasColumnName("userId");
            entity.Property(e => e.Address).HasColumnName("address");
            entity.Property(e => e.AvatarUser).HasColumnName("avatarUser");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("createdAt");
            entity.Property(e => e.Email)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("email");
            entity.Property(e => e.FullName)
                .HasMaxLength(100)
                .HasColumnName("fullName");
            entity.Property(e => e.IsActive)
                .HasDefaultValue(true)
                .HasColumnName("isActive");
            entity.Property(e => e.Password)
                .HasMaxLength(255)
                .IsUnicode(false)
                .HasColumnName("password");
            entity.Property(e => e.Phone)
                .HasMaxLength(15)
                .IsUnicode(false)
                .HasColumnName("phone");
            entity.Property(e => e.RoleId).HasColumnName("roleId");
            entity.Property(e => e.Username)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("username");

            entity.HasOne(d => d.Role).WithMany(p => p.Users)
                .HasForeignKey(d => d.RoleId)
                .HasConstraintName("FK_User_Role");
        });
        modelBuilder.Entity<Discount>(entity =>
        {
            entity.HasKey(e => e.DiscountId).HasName("PK__DISCOUNT__D2130A6617BF372C");

            entity.ToTable("DISCOUNT");

            entity.HasIndex(e => e.DiscountCode, "UQ__DISCOUNT__3D87979A0BC5A96C").IsUnique();

            entity.Property(e => e.DiscountId).HasColumnName("discountId");
            entity.Property(e => e.DiscountCode)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("discountCode");
            entity.Property(e => e.EndDate)
                .HasColumnType("datetime")
                .HasColumnName("endDate");
            entity.Property(e => e.IsActived)
                .HasDefaultValue(true)
                .HasColumnName("isActived");
            entity.Property(e => e.OrderId).HasColumnName("orderId");
            entity.Property(e => e.PercentDiscount).HasColumnName("percentDiscount");
            entity.Property(e => e.StartDate)
                .HasColumnType("datetime")
                .HasColumnName("startDate");
            entity.Property(e => e.UserId).HasColumnName("userId");
        });

        OnModelCreatingPartial(modelBuilder);
    }



    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
