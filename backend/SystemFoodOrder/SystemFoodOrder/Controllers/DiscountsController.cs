using Microsoft.AspNetCore.Mvc;
using SystemFoodOrder.Service;

namespace SystemFoodOrder.Controllers;

[ApiController]
[Route("api/[controller]")]
public class DiscountsController : ControllerBase
{
    private readonly DiscountService _discountService;

    public DiscountsController(DiscountService discountService)
    {
        _discountService = discountService;
    }

    [HttpGet]
    public async Task<IActionResult> GetActive(CancellationToken ct)
    {
        var list = await _discountService.GetActiveDiscountsAsync(ct);
        return Ok(list);
    }
}
