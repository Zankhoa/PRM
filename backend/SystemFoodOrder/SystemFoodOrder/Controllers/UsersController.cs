using Microsoft.AspNetCore.Mvc;
using SystemFoodOrder.Model.DTOs;
using SystemFoodOrder.Service;

namespace SystemFoodOrder.Controllers;

[Route("api/[controller]")]
[ApiController]
public class UsersController : ControllerBase
{
    private readonly UserService _userService;
    private readonly OrderQueryService _orderQuery;

    public UsersController(UserService userService, OrderQueryService orderQuery)
    {
        _userService = userService;
        _orderQuery = orderQuery;
    }

    [HttpGet("{userId:int}/history")]
    public async Task<IActionResult> HistoryOrders(int userId, [FromQuery] DateTime? startDate, [FromQuery] DateTime? endDate)
    {
        var history = await _userService.GetOrderHistoryByUserId(userId, startDate, endDate);
        return Ok(history);
    }

    /// <summary>Danh sách đơn hàng (có dòng món + avatar).</summary>
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
