using Microsoft.AspNetCore.Mvc;
using SystemFoodOrder.Service;

namespace SystemFoodOrder.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    private readonly ProductService _productService;

    public ProductsController(ProductService productService)
    {
        _productService = productService;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll([FromQuery] string? category, [FromQuery] string? search, CancellationToken ct)
    {
        var list = await _productService.GetProductsAsync(category, search, ct);
        return Ok(list);
    }

    [HttpGet("categories")]
    public async Task<IActionResult> GetCategories(CancellationToken ct)
    {
        var list = await _productService.GetCategoriesAsync(ct);
        return Ok(list);
    }

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id, CancellationToken ct)
    {
        var p = await _productService.GetProductByIdAsync(id, ct);
        if (p == null) return NotFound(new { message = "Product not found." });
        return Ok(p);
    }
}
