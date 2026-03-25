using Microsoft.EntityFrameworkCore;
using SystemFoodOrder.Data;
using SystemFoodOrder.Model.DTOs;

namespace SystemFoodOrder.Service;

public class OrderQueryService
{
    private readonly AppDbContext _context;

    public OrderQueryService(AppDbContext context)
    {
        _context = context;
    }

    private IQueryable<Model.Entities.Order> BaseQuery()
        => _context.Orders.AsNoTracking()
            .Include(o => o.OrderDetails)
            .ThenInclude(d => d.Product);

    public async Task<List<OrderStatusDto>> GetOrdersForUserAsync(int userId, CancellationToken ct = default)
    {
        var rows = await BaseQuery()
            .Where(o => o.UserId == userId)
            .OrderByDescending(o => o.CreatedAt)
            .ToListAsync(ct);
        return rows.Select(OrderStatusMapper.ToDto).ToList();
    }

    public async Task<OrderStatusDto?> GetOrderByIdForUserAsync(int userId, int orderId, CancellationToken ct = default)
    {
        var o = await BaseQuery()
            .Where(x => x.OrderId == orderId && x.UserId == userId)
            .FirstOrDefaultAsync(ct);
        return o == null ? null : OrderStatusMapper.ToDto(o);
    }
}
