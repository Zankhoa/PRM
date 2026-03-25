using Microsoft.AspNetCore.Mvc;
using SystemFoodOrder.Model.DTOs;
using SystemFoodOrder.Service;

namespace SystemFoodOrder.Controllers;

[ApiController]
[Route("api/shop/orders")]
public class ShopOrdersController : ControllerBase
{
    private readonly ShopOrderService _shopOrderService;

    public ShopOrdersController(ShopOrderService shopOrderService)
    {
        _shopOrderService = shopOrderService;
    }

    [HttpGet("pending")]
    public async Task<IActionResult> GetPending(CancellationToken ct)
    {
        var list = await _shopOrderService.GetPendingOrdersAsync(ct);
        return Ok(list);
    }

    [HttpGet]
    public async Task<IActionResult> GetAll([FromQuery] int take = 100, CancellationToken ct = default)
    {
        var list = await _shopOrderService.GetAllOrdersAsync(ct, take);
        return Ok(list);
    }

    [HttpPost("{orderId:int}/status")]
    public async Task<IActionResult> UpdateStatus(int orderId, [FromBody] ShopUpdateOrderStatusRequest body, CancellationToken ct)
    {
        try
        {
            var dto = await _shopOrderService.UpdateOrderStatusAsync(orderId, body.Status, ct);
            if (dto == null) return NotFound(new { message = "Order not found." });
            return Ok(dto);
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

    //public async Task<IActionResult> UpdateStatus(int orderId, [FromBody] ShopUpdateOrderStatusRequest body)
    //{
    //    var dto = await _shopOrderService.Up(orderId, body.Status);
    //    return Ok();
    //}
}
