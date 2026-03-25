namespace SystemFoodOrder.Model.DTOs
{
    // DTO cho màn hình Manage Discount (List)
    public class DiscountListDTO
    {
        public int DiscountId { get; set; }
        public string DiscountCode { get; set; } = string.Empty;
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public int? PercentDiscount { get; set; }
        public bool? IsActived { get; set; }

        // Computed properties
        public bool IsExpired => EndDate.HasValue && EndDate.Value < DateTime.Now;
        public bool IsActive => (IsActived ?? false) && !IsExpired;
    }

    // DTO cho màn hình Add Discount
    public class CreateDiscountDTO
    {
        public string DiscountCode { get; set; } = string.Empty;
        public int PercentDiscount { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
    }

    // DTO cho màn hình Detail/Update Discount
    public class UpdateDiscountDTO
    {
        public string? DiscountCode { get; set; }
        public int? PercentDiscount { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public bool? IsActived { get; set; }
    }

    // DTO cho Dashboard Statistics
    public class ShopDashboardDTO
    {
        public decimal TotalRevenue { get; set; }
        public int TotalOrders { get; set; }
        public int TotalProducts { get; set; }
        public int ActiveDiscounts { get; set; }
        public List<ProductSalesDTO> TopProducts { get; set; } = new();
    }

    public class ProductSalesDTO
    {
        public int ProductId { get; set; }
        public string ProductName { get; set; } = string.Empty;
        public string? Category { get; set; }
        public decimal Price { get; set; }
        public int SoldCount { get; set; }
        public decimal Revenue { get; set; }
    }

    // DTO cho Shop Owner Profile
    public class ShopProfileDTO
    {
        public int UserId { get; set; }
        public string Username { get; set; } = string.Empty;
        public string FullName { get; set; } = string.Empty;
        public string? Phone { get; set; }
        public string? Email { get; set; }
        public string? Address { get; set; }
        public string? AvatarUser { get; set; }
        public DateTime? CreatedAt { get; set; }
    }

    // DTO cho Update Profile
    public class UpdateProfileDTO
    {
        public string? FullName { get; set; }
        public string? Phone { get; set; }
        public string? Email { get; set; }
        public string? Address { get; set; }
        public string? AvatarUser { get; set; }
    }
}