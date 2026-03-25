using Microsoft.AspNetCore.Mvc;

namespace SystemFoodOrder.Model.DTOs
{
    public class ProductManageDTOs 
    {
        public int ProductId { get; set; }
        public string avatarImage { get; set; }
        public string NameProduct { get; set; }
        public decimal Price { get; set; }
        public bool? Status { get; set; }
        public string Category { get; set; }
        public string Description { get; set; }

    }
}
