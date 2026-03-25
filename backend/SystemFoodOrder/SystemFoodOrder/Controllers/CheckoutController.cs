using Microsoft.AspNetCore.Mvc;
using SystemFoodOrder.Model.DTOs;
using SystemFoodOrder.Service;

namespace SystemFoodOrder.Controllers;

[ApiController]
[Route("api/[controller]")]
public class CheckoutController : ControllerBase
{
    private readonly CheckoutService _checkoutService;

    public CheckoutController(CheckoutService checkoutService)
    {
        _checkoutService = checkoutService;
    }

    [HttpPost]
    public async Task<IActionResult> Post([FromBody] CheckoutRequest req, CancellationToken ct)
    {
        try
        {
            var result = await _checkoutService.CheckoutAsync(req, ct);
            return Ok(result);
        }
        catch (ArgumentException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }
}
