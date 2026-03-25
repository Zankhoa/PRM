using Microsoft.EntityFrameworkCore;
using SystemFoodOrder.Data;
using SystemFoodOrder.Model.DTOs;
using SystemFoodOrder.Model.Entities;

namespace SystemFoodOrder.Service;

public class CartService
{
    private readonly AppDbContext _context;

    public CartService(AppDbContext context)
    {
        _context = context;
    }

    public async Task<CartSummaryDto> GetCartAsync(int userId, CancellationToken ct = default)
    {
        var rows = await _context.CartItems.AsNoTracking()
            .Where(c => c.UserId == userId)
            .Include(c => c.Product)
            .ToListAsync(ct);

        var items = rows.Select(c => new CartItemResponseDto
        {
            CartItemId = c.CartItemId,
            ProductId = c.ProductId,
            ProductName = c.Product.Name,
            AvatarProducts = c.Product.AvatarProducts,
            UnitPrice = c.Product.Price,
            Quantity = c.Quantity,
            LineTotal = c.Product.Price * c.Quantity
        }).ToList();

        return new CartSummaryDto
        {
            Items = items,
            Subtotal = items.Sum(x => x.LineTotal)
        };
    }

    public async Task<CartSummaryDto> AddOrUpdateAsync(int userId, AddOrUpdateCartItemRequest req, CancellationToken ct = default)
    {
        if (req.Quantity <= 0)
        {
            var existing = await _context.CartItems
                .FirstOrDefaultAsync(c => c.UserId == userId && c.ProductId == req.ProductId, ct);
            if (existing != null)
            {
                _context.CartItems.Remove(existing);
                await _context.SaveChangesAsync(ct);
            }
            return await GetCartAsync(userId, ct);
        }

        var product = await _context.Products.AsNoTracking()
            .FirstOrDefaultAsync(p => p.ProductId == req.ProductId && p.IsAvailable != false, ct);
        if (product == null)
            throw new InvalidOperationException("Sản phẩm không tồn tại hoặc đã ngừng bán.");

        var line = await _context.CartItems
            .FirstOrDefaultAsync(c => c.UserId == userId && c.ProductId == req.ProductId, ct);
        if (line == null)
        {
            _context.CartItems.Add(new CartItem
            {
                UserId = userId,
                ProductId = req.ProductId,
                Quantity = req.Quantity,
                UpdatedAt = DateTime.UtcNow
            });
        }
        else
        {
            line.Quantity = req.Quantity;
            line.UpdatedAt = DateTime.UtcNow;
        }

        await _context.SaveChangesAsync(ct);
        return await GetCartAsync(userId, ct);
    }

    public async Task ClearCartAsync(int userId, CancellationToken ct = default)
    {
        var rows = await _context.CartItems.Where(c => c.UserId == userId).ToListAsync(ct);
        _context.CartItems.RemoveRange(rows);
        await _context.SaveChangesAsync(ct);
    }
}
