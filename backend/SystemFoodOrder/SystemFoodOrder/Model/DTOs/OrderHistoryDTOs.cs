namespace SystemFoodOrder.Model.DTOs
{
    public class OrderHistoryDTOs
    {
        public int OrderId { get; set; }
        public string NameProducts { get; set; } = string.Empty;
        public decimal? TotalPrice { get; set; }
        public int Quantity { get; set; }
        public DateTime? CreatedAt { get; set; }
        public string? Status { get; set; }

    }
}
