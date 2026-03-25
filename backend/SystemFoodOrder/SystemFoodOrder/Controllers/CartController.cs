using Microsoft.AspNetCore.Mvc;
using SystemFoodOrder.Model.DTOs;
using SystemFoodOrder.Service;

namespace SystemFoodOrder.Controllers;

[ApiController]
[Route("api/users/{userId:int}/cart")]
public class CartController : ControllerBase
{
    private readonly CartService _cartService;

    public CartController(CartService cartService)
    {
        _cartService = cartService;
    }

    [HttpGet]
    public async Task<IActionResult> Get(int userId, CancellationToken ct)
    {
        var cart = await _cartService.GetCartAsync(userId, ct);
        return Ok(cart);
    }

    [HttpPost]
    public async Task<IActionResult> Post(int userId, [FromBody] AddOrUpdateCartItemRequest req, CancellationToken ct)
    {
        try
        {
            var cart = await _cartService.AddOrUpdateAsync(userId, req, ct);
            return Ok(cart);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }
}
