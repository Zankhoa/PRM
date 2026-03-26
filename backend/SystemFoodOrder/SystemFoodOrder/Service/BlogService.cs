using Microsoft.EntityFrameworkCore;
using SystemFoodOrder.Data;
using SystemFoodOrder.Model.DTOs;
using SystemFoodOrder.Model.Entities;

namespace SystemFoodOrder.Service;

public class BlogService
{
    private readonly AppDbContext _db;
    public BlogService(AppDbContext db)
    {
        _db = db;
    }

    public async Task<List<BlogDto>> GetAllAsync(int page = 1, int pageSize = 20)
    {
        return await _db.Blogs.AsNoTracking()
            .OrderByDescending(b => b.CreatedAt)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .Select(b => new BlogDto
            {
                BlogId = b.BlogId,
                UserId = b.UserId,
                Title = b.Title,
                Content = b.Content,
                CreatedAt = b.CreatedAt
            }).ToListAsync();
    }

    public async Task<BlogDto?> GetByIdAsync(int id)
    {
        var b = await _db.Blogs.FindAsync(id);
        if (b == null) return null;
        return new BlogDto { BlogId = b.BlogId, UserId = b.UserId, Title = b.Title, Content = b.Content, CreatedAt = b.CreatedAt };
    }

    public async Task<BlogDto> CreateAsync(CreateBlogDto req)
    {
        var b = new Blog { UserId = req.UserId, Title = req.Title, Content = req.Content, CreatedAt = DateTime.UtcNow };
        _db.Blogs.Add(b);
        await _db.SaveChangesAsync();
        return new BlogDto { BlogId = b.BlogId, UserId = b.UserId, Title = b.Title, Content = b.Content, CreatedAt = b.CreatedAt };
    }
}
