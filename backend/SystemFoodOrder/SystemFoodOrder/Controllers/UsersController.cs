using Microsoft.AspNetCore.Mvc;
using System.Reflection.Metadata.Ecma335;
using SystemFoodOrder.Model.DTOs;
using SystemFoodOrder.Service;

namespace SystemFoodOrder.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : Controller
    {
        private readonly OrderService _orderService;
        private readonly UserService _userService;

        public UsersController(OrderService orderService, UserService userService)
        {
            _orderService = orderService;
            _userService = userService;
        }
        [HttpGet("{userId}/history")]
        public async Task<IActionResult> HistoryOrders(int userId, [FromQuery] DateTime? startDate, [FromQuery] DateTime? endDate)
        {
            var history = _userService.GetOrderHistoryByUserId(userId, startDate, endDate);            
            if(history == null)  return NotFound(new { message = "Not found order"});
            return Ok(history);
        }

        

    }
}
