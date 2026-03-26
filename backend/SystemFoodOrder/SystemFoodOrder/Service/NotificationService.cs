using Microsoft.EntityFrameworkCore;
using SystemFoodOrder.Data;
using SystemFoodOrder.Model.DTOs;
using SystemFoodOrder.Model.Entities;

namespace SystemFoodOrder.Service;

public class NotificationService
{
    private readonly AppDbContext _db;
    public NotificationService(AppDbContext db)
    {
        _db = db;
    }

    public async Task<List<NotificationDto>> GetForUserAsync(int userId)
    {
        return await _db.Notifications
            .AsNoTracking()
            .Where(n => n.UserId == userId)
            .OrderByDescending(n => n.CreatedAt)
            .Select(n => new NotificationDto
            {
                NotificationId = n.NotificationId,
                Title = n.Title,
                Message = n.Message,
                IsRead = n.IsRead,
                CreatedAt = n.CreatedAt
            })
            .ToListAsync();
    }

    public async Task<NotificationDto?> GetByIdAsync(int id)
    {
        var n = await _db.Notifications.FindAsync(id);
        if (n == null) return null;
        return new NotificationDto
        {
            NotificationId = n.NotificationId,
            Title = n.Title,
            Message = n.Message,
            IsRead = n.IsRead,
            CreatedAt = n.CreatedAt
        };
    }

    public async Task<NotificationDto> CreateAsync(CreateNotificationDto req)
    {
        var n = new Notification
        {
            UserId = req.UserId,
            Title = req.Title,
            Message = req.Message,
            IsRead = false,
            CreatedAt = DateTime.UtcNow
        };
        _db.Notifications.Add(n);
        await _db.SaveChangesAsync();
        return new NotificationDto
        {
            NotificationId = n.NotificationId,
            Title = n.Title,
            Message = n.Message,
            IsRead = n.IsRead,
            CreatedAt = n.CreatedAt
        };
    }

    public async Task<bool> MarkAsReadAsync(int id)
    {
        var n = await _db.Notifications.FindAsync(id);
        if (n == null) return false;
        n.IsRead = true;
        await _db.SaveChangesAsync();
        return true;
    }
}
