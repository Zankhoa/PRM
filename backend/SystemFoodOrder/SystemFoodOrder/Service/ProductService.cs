using Microsoft.EntityFrameworkCore;
using SystemFoodOrder.Data;
using SystemFoodOrder.Model.DTOs;

namespace SystemFoodOrder.Service;

public class ProductService
{
    private readonly AppDbContext _context;

    public ProductService(AppDbContext context)
    {
        _context = context;
    }

    public async Task<List<ProductResponseDto>> GetProductsAsync(string? category, string? search, CancellationToken ct = default)
    {
        var q = _context.Products.AsNoTracking().Where(p => p.IsAvailable != false);

        if (!string.IsNullOrWhiteSpace(category))
            q = q.Where(p => p.Category != null && p.Category == category);

        if (!string.IsNullOrWhiteSpace(search))
        {
            var s = search.Trim();
            q = q.Where(p => p.Name.Contains(s) || (p.Description != null && p.Description.Contains(s)));
        }

        return await q.OrderByDescending(p => p.CreatedAt)
            .Select(p => new ProductResponseDto
            {
                ProductId = p.ProductId,
                Name = p.Name,
                AvatarProducts = p.AvatarProducts,
                Category = p.Category,
                Price = p.Price,
                Description = p.Description,
                IsAvailable = p.IsAvailable,
                CreatedAt = p.CreatedAt
            })
            .ToListAsync(ct);
    }

    public async Task<ProductResponseDto?> GetProductByIdAsync(int id, CancellationToken ct = default)
    {
        var p = await _context.Products.AsNoTracking()
            .Where(x => x.ProductId == id && x.IsAvailable != false)
            .FirstOrDefaultAsync(ct);
        if (p == null) return null;

        return new ProductResponseDto
        {
            ProductId = p.ProductId,
            Name = p.Name,
            AvatarProducts = p.AvatarProducts,
            Category = p.Category,
            Price = p.Price,
            Description = p.Description,
            IsAvailable = p.IsAvailable,
            CreatedAt = p.CreatedAt
        };
    }

    public async Task<List<string>> GetCategoriesAsync(CancellationToken ct = default)
    {
        return await _context.Products.AsNoTracking()
            .Where(p => p.Category != null && p.Category != "")
            .Select(p => p.Category!)
            .Distinct()
            .OrderBy(c => c)
            .ToListAsync(ct);
    }
}
