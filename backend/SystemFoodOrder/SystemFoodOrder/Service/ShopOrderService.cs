using Microsoft.EntityFrameworkCore;
using SystemFoodOrder.Data;
using SystemFoodOrder.Model.DTOs;
using SystemFoodOrder.Model.Entities;

namespace SystemFoodOrder.Service;

public class ShopOrderService
{
    private readonly AppDbContext _context;

    public ShopOrderService(AppDbContext context)
    {
        _context = context;
    }

    private IQueryable<Order> OrdersFully() =>
        _context.Orders.AsNoTracking()
            .Include(o => o.OrderDetails)
            .ThenInclude(d => d.Product);

    public async Task<List<OrderStatusDto>> GetPendingOrdersAsync(CancellationToken ct = default)
    {
        var rows = await OrdersFully()
            .Where(o => o.Status != null && o.Status.ToLower() == "pending")
            .OrderBy(o => o.CreatedAt)
            .ToListAsync(ct);
        return rows.Select(OrderStatusMapper.ToDto).ToList();
    }

    public async Task<List<OrderStatusDto>> GetAllOrdersAsync(CancellationToken ct = default, int take = 100)
    {
        var rows = await OrdersFully()
            .OrderByDescending(o => o.CreatedAt)
            .Take(take)
            .ToListAsync(ct);
        return rows.Select(OrderStatusMapper.ToDto).ToList();
    }

    public async Task<OrderStatusDto?> UpdateOrderStatusAsync(int orderId, string newStatus, CancellationToken ct = default)
    {
        if (!AllowedStatuses.Contains(newStatus))
            throw new ArgumentException("Status chỉ được: Confirmed hoặc Cancelled.");

        var order = await _context.Orders.FirstOrDefaultAsync(o => o.OrderId == orderId, ct);
        if (order == null)
            return null;

        if (!string.Equals(order.Status, "Pending", StringComparison.OrdinalIgnoreCase))
            throw new InvalidOperationException("Chỉ cập nhật được đơn đang Pending.");

        order.Status = newStatus switch
        {
            var s when string.Equals(s, "Confirmed", StringComparison.OrdinalIgnoreCase) => "Confirmed",
            var s when string.Equals(s, "Cancelled", StringComparison.OrdinalIgnoreCase) => "Cancelled",
            _ => order.Status
        };

        var pay = await _context.Payments.FirstOrDefaultAsync(p => p.OrderId == orderId, ct);
        if (pay != null && string.Equals(order.Status, "Confirmed", StringComparison.OrdinalIgnoreCase))
            pay.Status = "Completed";
        if (pay != null && string.Equals(order.Status, "Cancelled", StringComparison.OrdinalIgnoreCase))
            pay.Status = "Cancelled";

        await _context.SaveChangesAsync(ct);

        var o = await OrdersFully()
            .Where(x => x.OrderId == orderId)
            .FirstOrDefaultAsync(ct);
        return o == null ? null : OrderStatusMapper.ToDto(o);
    }

    private static readonly HashSet<string> AllowedStatuses =
        new(StringComparer.OrdinalIgnoreCase) { "Confirmed", "Cancelled" };
}
