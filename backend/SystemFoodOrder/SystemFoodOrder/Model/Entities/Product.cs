using System;
using System.Collections.Generic;

namespace SystemFoodOrder.Model.Entities;

public partial class Product
{
    public int ProductId { get; set; }

    public int? UserId { get; set; }

    public string Name { get; set; } = null!;

    public string? AvatarProducts { get; set; }

    public string? Category { get; set; }

    public decimal Price { get; set; }

    public string? Description { get; set; }

    public bool? IsAvailable { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual ICollection<OrderDetail> OrderDetails { get; set; } = new List<OrderDetail>();

    public virtual ICollection<CartItem> CartItems { get; set; } = new List<CartItem>();

    public virtual User? User { get; set; }
}
