using System;
using System.Collections.Generic;

namespace SystemFoodOrder.Model.Entities;

public partial class Discount
{
    public int DiscountId { get; set; }

    public int? UserId { get; set; }

    public string DiscountCode { get; set; } = null!;

    public DateTime? StartDate { get; set; }

    public int? PercentDiscount { get; set; }

    public DateTime? EndDate { get; set; }

    public bool? IsActived { get; set; }

    public int? OrderId { get; set; }
}
