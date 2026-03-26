using Microsoft.AspNetCore.Mvc;
using SystemFoodOrder.Service;
using SystemFoodOrder.Model.DTOs;

namespace SystemFoodOrder.Controllers;

[ApiController]
[Route("api/admin/users")]
public class AdminUsersController : ControllerBase
{
    private readonly AdminUserService _admin;
    public AdminUsersController(AdminUserService admin)
    {
        _admin = admin;
    }

    [HttpGet]
    public async Task<IActionResult> List([FromQuery] int page = 1, [FromQuery] int pageSize = 50)
    {
        var list = await _admin.ListUsersAsync(page, pageSize);
        return Ok(list);
    }

    [HttpGet("{id:int}")]
    public async Task<IActionResult> Get(int id)
    {
        var u = await _admin.GetByIdAsync(id);
        if (u == null) return NotFound();
        return Ok(u);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateUserDto req)
    {
        var created = await _admin.CreateAsync(req);
        if (created == null) return BadRequest(new { message = "Username already exists" });
        return CreatedAtAction(nameof(Get), new { id = created.UserId }, created);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(int id, [FromBody] UpdateUserDto req)
    {
        var ok = await _admin.UpdateAsync(id, req);
        if (!ok) return NotFound();
        return NoContent();
    }
}
