using System;
using System.Collections.Generic;

namespace SystemFoodOrder.Model.Entities;

public partial class Product
{
    public int ProductId { get; set; }

    public int UserId { get; set; }

    public string Name { get; set; } = null!;

    public string? AvatarProducts { get; set; }

    public string? Category { get; set; }

    public decimal Price { get; set; }

    public string? Description { get; set; }

    public bool IsAvailable { get; set; } = true;

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    public virtual ICollection<OrderDetail> OrderDetails { get; set; } = new List<OrderDetail>();

    public virtual User? User { get; set; }
}
