using Microsoft.AspNetCore.Mvc;

namespace SystemFoodOrder.Model.DTOs
{
    public class ProductManageRequest 
    {
        public int? ProductId { get; set; }

        public int? UserId { get; set; }

        public string Name { get; set; } 

        public string? AvatarProducts { get; set; }

        public string? Category { get; set; }

        public decimal Price { get; set; }

        public string? Description { get; set; }

        public bool? IsAvailable { get; set; }

        public DateTime? CreatedAt { get; set; }
    }
}
