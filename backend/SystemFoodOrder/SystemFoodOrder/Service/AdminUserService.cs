using Microsoft.EntityFrameworkCore;
using SystemFoodOrder.Data;
using SystemFoodOrder.Model.DTOs;
using SystemFoodOrder.Model.Entities;

namespace SystemFoodOrder.Service;

public class AdminUserService
{
    private readonly AppDbContext _db;
    public AdminUserService(AppDbContext db)
    {
        _db = db;
    }

    public async Task<List<AdminUserListDto>> ListUsersAsync(int page = 1, int pageSize = 50)
    {
        return await _db.Users.AsNoTracking()
            .OrderBy(u => u.UserId)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .Select(u => new AdminUserListDto
            {
                UserId = u.UserId,
                Username = u.Username,
                FullName = u.FullName,
                Email = u.Email,
                Phone = u.Phone,
                IsActive = u.IsActive,
                RoleId = u.RoleId
            }).ToListAsync();
    }

    public async Task<AdminUserListDto?> GetByIdAsync(int id)
    {
        var u = await _db.Users.FindAsync(id);
        if (u == null) return null;
        return new AdminUserListDto { UserId = u.UserId, Username = u.Username, FullName = u.FullName, Email = u.Email, Phone = u.Phone, IsActive = u.IsActive, RoleId = u.RoleId };
    }

    public async Task<AdminUserListDto?> CreateAsync(CreateUserDto req)
    {
        if (await _db.Users.AnyAsync(u => u.Username == req.Username)) return null;
        var u = new User { Username = req.Username, FullName = req.FullName, Password = req.Password, Email = req.Email, Phone = req.Phone, RoleId = req.RoleId, IsActive = true, CreatedAt = DateTime.UtcNow };
        _db.Users.Add(u);
        await _db.SaveChangesAsync();
        return new AdminUserListDto { UserId = u.UserId, Username = u.Username, FullName = u.FullName, Email = u.Email, Phone = u.Phone, IsActive = u.IsActive, RoleId = u.RoleId };
    }

    public async Task<bool> UpdateAsync(int id, UpdateUserDto req)
    {
        var u = await _db.Users.FindAsync(id);
        if (u == null) return false;
        if (!string.IsNullOrEmpty(req.FullName)) u.FullName = req.FullName;
        if (!string.IsNullOrEmpty(req.Password)) u.Password = req.Password;
        if (req.Email != null) u.Email = req.Email;
        if (req.Phone != null) u.Phone = req.Phone;
        if (req.IsActive.HasValue) u.IsActive = req.IsActive;
        if (req.RoleId.HasValue) u.RoleId = req.RoleId;
        await _db.SaveChangesAsync();
        return true;
    }
}
