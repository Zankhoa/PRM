using System.Text.Json.Serialization;

namespace SystemFoodOrder.Model.DTOs;

public class ProductResponseDto
{
    public int ProductId { get; set; }
    public string Name { get; set; } = string.Empty;
    [JsonPropertyName("avatarProducts")]
    public string? AvatarProducts { get; set; }
    public string? Category { get; set; }
    public decimal Price { get; set; }
    public string? Description { get; set; }
    public bool? IsAvailable { get; set; }
    public DateTime? CreatedAt { get; set; }
}

public class DiscountResponseDto
{
    public int DiscountId { get; set; }
    public string DiscountCode { get; set; } = string.Empty;
    public int? PercentDiscount { get; set; }
    public DateTime? StartDate { get; set; }
    public DateTime? EndDate { get; set; }
    public bool? IsActived { get; set; }
}

public class CartItemResponseDto
{
    public int CartItemId { get; set; }
    public int ProductId { get; set; }
    public string ProductName { get; set; } = string.Empty;
    public string? AvatarProducts { get; set; }
    public decimal UnitPrice { get; set; }
    public int Quantity { get; set; }
    public decimal LineTotal { get; set; }
}

public class CartSummaryDto
{
    public List<CartItemResponseDto> Items { get; set; } = new();
    public decimal Subtotal { get; set; }
}

public class AddOrUpdateCartItemRequest
{
    public int ProductId { get; set; }
    public int Quantity { get; set; }
}

public class CheckoutItemRequest
{
    public int ProductId { get; set; }
    public int Quantity { get; set; }
}

public class CheckoutRequest
{
    public int UserId { get; set; }
    public string DeliveryAddress { get; set; } = string.Empty;
    public string PaymentMethod { get; set; } = "COD";
    public string? DiscountCode { get; set; }
    public decimal DeliveryFee { get; set; }
    public bool UseCartFromDatabase { get; set; } = true;
    public List<CheckoutItemRequest>? Items { get; set; }
}

public class CheckoutResponseDto
{
    public int OrderId { get; set; }
    public decimal TotalPrice { get; set; }
    public decimal DiscountAmount { get; set; }
    public string? Status { get; set; }
    public int? PaymentId { get; set; }
    public string? PaymentStatus { get; set; }
}

public class OrderLineSummaryDto
{
    public int ProductId { get; set; }
    public string ProductName { get; set; } = string.Empty;
    [JsonPropertyName("avatarProducts")]
    public string? AvatarProducts { get; set; }
    public int Quantity { get; set; }
    public decimal UnitPrice { get; set; }
}

public class OrderStatusDto
{
    public int OrderId { get; set; }
    public decimal? TotalPrice { get; set; }
    public string? Status { get; set; }
    public DateTime? CreatedAt { get; set; }
    public string? DeliveryAddress { get; set; }
    public int ItemCount { get; set; }
    public List<OrderLineSummaryDto> Items { get; set; } = new();
}

public class ShopUpdateOrderStatusRequest
{
    public string Status { get; set; } = string.Empty;
}
