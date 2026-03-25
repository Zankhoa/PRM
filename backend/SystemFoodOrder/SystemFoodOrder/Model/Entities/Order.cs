using System;
using System.Collections.Generic;

namespace SystemFoodOrder.Model.Entities;

public partial class Order
{
    public int OrderId { get; set; }

    public int UserId { get; set; }

    public decimal TotalPrice { get; set; }

    public decimal DeliveryFee { get; set; } = 0;

    public string Status { get; set; } = "Pending";

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    public string? DeliveryAddress { get; set; }

    public virtual ICollection<OrderDetail> OrderDetails { get; set; } = new List<OrderDetail>();

    public virtual Payment? Payment { get; set; }

    public virtual User? User { get; set; }
}
