using Microsoft.AspNetCore.Mvc;
using SystemFoodOrder.Service;

namespace SystemFoodOrder.Controllers
{
    // 1. Đổi thành tên cố định cho chuẩn RESTful và không bị ảnh hưởng bởi tên Class
    [Route("api/users")]
    [ApiController]
    public class UsersController : ControllerBase // Dùng ControllerBase thay vì Controller
    {
        private readonly OrderService _orderService;
        private readonly UserService _userService;
        private readonly OrderQueryService _orderQuery;

        public UsersController(OrderService orderService, UserService userService, OrderQueryService orderQuery)
        {
            _orderService = orderService;
            _userService = userService;
            _orderQuery = orderQuery;
        }

        // GET: api/users/{userId}/history
        [HttpGet("{userId}/history")]
        public async Task<IActionResult> HistoryOrders(int userId,[FromQuery] int page = 1,[FromQuery] int pageSize = 10, [FromQuery] DateTime? startDate = null,[FromQuery] DateTime? endDate = null)
        {
            var history = await _userService.GetOrderHistoryByUserId(userId, startDate, endDate, page, pageSize);
            if (history == null || !history.Any()) return Ok(new List<object>());
            return Ok(history);
        }

        [HttpGet("{userId:int}/orders")]
        public async Task<IActionResult> GetOrders(int userId, CancellationToken ct)
        {
            var list = await _orderQuery.GetOrdersForUserAsync(userId, ct);
            return Ok(list);
        }

        [HttpGet("{userId:int}/orders/{orderId:int}")]
        public async Task<IActionResult> GetOrder(int userId, int orderId, CancellationToken ct)
        {
            var o = await _orderQuery.GetOrderByIdForUserAsync(userId, orderId, ct);
            if (o == null) return NotFound(new { message = "Order not found." });
            return Ok(o);
        }
    }
}