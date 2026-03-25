using Microsoft.AspNetCore.Mvc;
using SystemFoodOrder.Service;
using SystemFoodOrder.Model.DTOs;

namespace SystemFoodOrder.Controllers;

[ApiController]
[Route("api/users/{userId:int}/notifications")]
public class NotificationsController : ControllerBase
{
    private readonly NotificationService _notifications;
    public NotificationsController(NotificationService notifications)
    {
        _notifications = notifications;
    }

    [HttpGet]
    public async Task<IActionResult> GetForUser(int userId)
    {
        var list = await _notifications.GetForUserAsync(userId);
        return Ok(list);
    }

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int userId, int id)
    {
        var n = await _notifications.GetByIdAsync(id);
        if (n == null) return NotFound();
        if (n.NotificationId == 0) return NotFound();
        return Ok(n);
    }

    [HttpPost]
    public async Task<IActionResult> Create(int userId, [FromBody] CreateNotificationDto req)
    {
        req.UserId = userId;
        var n = await _notifications.CreateAsync(req);
        return CreatedAtAction(nameof(GetById), new { userId = userId, id = n.NotificationId }, n);
    }

    [HttpPost("{id:int}/read")]
    public async Task<IActionResult> MarkRead(int userId, int id)
    {
        var ok = await _notifications.MarkAsReadAsync(id);
        if (!ok) return NotFound();
        return NoContent();
    }
}
