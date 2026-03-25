using Microsoft.AspNetCore.Mvc;
using SystemFoodOrder.Service;
using SystemFoodOrder.Model.DTOs;

namespace SystemFoodOrder.Controllers;

[ApiController]
[Route("api/blogs")]
public class BlogsController : ControllerBase
{
    private readonly BlogService _blogs;
    public BlogsController(BlogService blogs)
    {
        _blogs = blogs;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll([FromQuery] int page = 1, [FromQuery] int pageSize = 20)
    {
        var list = await _blogs.GetAllAsync(page, pageSize);
        return Ok(list);
    }

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var b = await _blogs.GetByIdAsync(id);
        if (b == null) return NotFound();
        return Ok(b);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateBlogDto req)
    {
        var b = await _blogs.CreateAsync(req);
        return CreatedAtAction(nameof(GetById), new { id = b.BlogId }, b);
    }
}
