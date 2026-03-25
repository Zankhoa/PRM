using Microsoft.EntityFrameworkCore;
using SystemFoodOrder.Data;
using SystemFoodOrder.Model.DTOs;

namespace SystemFoodOrder.Service;

public class DiscountService
{
    private readonly AppDbContext _context;

    public DiscountService(AppDbContext context)
    {
        _context = context;
    }

    public async Task<List<DiscountResponseDto>> GetActiveDiscountsAsync(CancellationToken ct = default)
    {
        var now = DateTime.UtcNow;
        return await _context.Discounts.AsNoTracking()
            .Where(d => d.IsActived == true
                && (d.StartDate == null || d.StartDate <= now)
                && (d.EndDate == null || d.EndDate >= now))
            .OrderBy(d => d.DiscountCode)
            .Select(d => new DiscountResponseDto
            {
                DiscountId = d.DiscountId,
                DiscountCode = d.DiscountCode,
                PercentDiscount = d.PercentDiscount,
                StartDate = d.StartDate,
                EndDate = d.EndDate,
                IsActived = d.IsActived
            })
            .ToListAsync(ct);
    }
}
