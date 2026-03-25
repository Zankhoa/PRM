using System;
using System.Collections.Generic;

namespace SystemFoodOrder.Model.Entities;

public partial class Blog
{
    public int BlogId { get; set; }
    public int? UserId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
    public DateTime? CreatedAt { get; set; }

    public virtual User? User { get; set; }
}
