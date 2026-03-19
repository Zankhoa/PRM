using Microsoft.EntityFrameworkCore;
using SystemFoodOrder.Data;
using SystemFoodOrder.Model.Entities;

namespace SystemFoodOrder.Service
{
    public class OrderService
    {
        private readonly AppDbContext _context;
        public OrderService(AppDbContext context)
        {
            _context = context;
        }

        public async Task<List<Order>> GetUserOrderByUser(int userId)
        {
            var order = await _context.Orders.Where(x => x.UserId == userId).ToListAsync();
            return order;
        }

        public async Task<List<OrderDetail>> GetOrderDetailtByOrder(int orderId)
        {
            var orderDetailt = await _context.OrderDetails.Where(x => x.OrderId == orderId).ToListAsync();
            return orderDetailt;
        }
    }
}
