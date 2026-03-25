using SystemFoodOrder.Model.DTOs;
using SystemFoodOrder.Model.Entities;

namespace SystemFoodOrder.Service;

public static class OrderStatusMapper
{
    public static OrderStatusDto ToDto(Order o)
    {
        var details = o.OrderDetails
            .OrderBy(d => d.OrderDetailId)
            .Select(d => new OrderLineSummaryDto
            {
                ProductId = d.ProductId ?? 0,
                ProductName = d.Product?.Name ?? string.Empty,
                AvatarProducts = d.Product?.AvatarProducts,
                Quantity = d.Quantity,
                UnitPrice = d.Price
            })
            .ToList();

        return new OrderStatusDto
        {
            OrderId = o.OrderId,
            TotalPrice = o.TotalPrice,
            Status = o.Status,
            CreatedAt = o.CreatedAt,
            DeliveryAddress = o.DeliveryAddress,
            ItemCount = details.Sum(x => x.Quantity),
            Items = details
        };
    }
}
