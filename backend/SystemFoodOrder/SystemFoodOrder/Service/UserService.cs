using Microsoft.EntityFrameworkCore;
using SystemFoodOrder.Data;
using SystemFoodOrder.Model.DTOs;

namespace SystemFoodOrder.Service
{
    public class UserService
    {
        private readonly AppDbContext _context;
        private readonly OrderService _orderService;
        public UserService(AppDbContext context, OrderService orderService)
        {
            _context = context;
            _orderService = orderService;
        }
        public async Task<List<OrderHistoryDTOs>> GetOrderHistoryByUserId(int userId, DateTime? startDate, DateTime? endDate, int page = 1, int pageSize = 20)
        {
            var query = _context.Orders.AsNoTracking()
                .Include(o => o.OrderDetails)
                .ThenInclude(d => d.Product)
                .Where(x => x.UserId == userId);
            if (startDate.HasValue)
            {
                query = query.Where(x => x.CreatedAt >= startDate.Value);
            }

            if (endDate.HasValue)
            {
                var nextDay = endDate.Value.Date.AddDays(1);
                query = query.Where(x => x.CreatedAt < nextDay);
            }
            query = query.OrderByDescending(x => x.CreatedAt);
            var data = await query
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .SelectMany(order => order.OrderDetails, (order, detailt) => new OrderHistoryDTOs
                {
                    OrderId = order.OrderId,
                    NameProducts = detailt.Product != null ? detailt.Product.Name : "",
                    TotalPrice = order.TotalPrice,
                    Status = order.Status,
                    CreatedAt = order.CreatedAt,
                    Quantity = order.OrderDetails.Count()
                })
                .ToListAsync();

            return data;
        }
    }
}

