using Microsoft.EntityFrameworkCore;
using SystemFoodOrder.Data;
using SystemFoodOrder.Model.DTOs;
using SystemFoodOrder.Model.Entities;

namespace SystemFoodOrder.Service;

public class CheckoutService
{
    private readonly AppDbContext _context;
    private readonly CartService _cartService;

    public CheckoutService(AppDbContext context, CartService cartService)
    {
        _context = context;
        _cartService = cartService;
    }

    public async Task<CheckoutResponseDto> CheckoutAsync(CheckoutRequest req, CancellationToken ct = default)
    {
        if (string.IsNullOrWhiteSpace(req.DeliveryAddress))
            throw new ArgumentException("Địa chỉ giao hàng không được để trống.");

        List<(Product Product, int Qty)> lines;

        if (req.UseCartFromDatabase)
        {
            var cart = await _context.CartItems.AsNoTracking()
                .Where(c => c.UserId == req.UserId)
                .Include(c => c.Product)
                .ToListAsync(ct);
            if (cart.Count == 0)
                throw new InvalidOperationException("Giỏ hàng trống.");

            lines = cart
                .Where(c => c.Product.IsAvailable != false)
                .Select(c => (c.Product, c.Quantity))
                .ToList();
        }
        else
        {
            if (req.Items == null || req.Items.Count == 0)
                throw new InvalidOperationException("Không có dòng hàng để thanh toán.");

            lines = new List<(Product, int)>();
            foreach (var it in req.Items)
            {
                var p = await _context.Products.AsNoTracking()
                    .FirstOrDefaultAsync(x => x.ProductId == it.ProductId && x.IsAvailable != false, ct);
                if (p == null)
                    throw new InvalidOperationException($"Sản phẩm #{it.ProductId} không hợp lệ.");
                lines.Add((p, it.Quantity));
            }
        }

        if (lines.Count == 0)
            throw new InvalidOperationException("Không có sản phẩm hợp lệ.");
        decimal subtotal = lines.Sum(x => x.Product.Price * x.Qty);

        decimal discountAmount = 0;
        if (!string.IsNullOrWhiteSpace(req.DiscountCode))
        {
            var now = DateTime.UtcNow;
            var disc = await _context.Discounts.AsNoTracking()
                .FirstOrDefaultAsync(d =>
                    d.DiscountCode == req.DiscountCode.Trim()
                    && d.IsActived == true
                    && (d.StartDate == null || d.StartDate <= now)
                    && (d.EndDate == null || d.EndDate >= now), ct);
            if (disc is { PercentDiscount: > 0 })
            {
                var pct = disc.PercentDiscount ?? 0;
                discountAmount = Math.Round(subtotal * pct / 100m, 2);
            }
        }

        var total = subtotal - discountAmount + req.DeliveryFee;
        if (total < 0) total = 0;

        var order = new Order
        {
            UserId = req.UserId,
            TotalPrice = total,
            DeliveryFee = req.DeliveryFee,
            Status = "Pending",
            CreatedAt = DateTime.UtcNow,
            DeliveryAddress = req.DeliveryAddress.Trim()
        };

        _context.Orders.Add(order);
        await _context.SaveChangesAsync(ct);

        foreach (var (product, qty) in lines)
        {
            _context.OrderDetails.Add(new OrderDetail
            {
                OrderId = order.OrderId,
                ProductId = product.ProductId,
                Quantity = qty,
                Price = product.Price
            });
        }

        var payment = new Payment
        {
            OrderId = order.OrderId,
            PaymentMethod = req.PaymentMethod,
            Amount = total,
            Status = string.Equals(req.PaymentMethod, "COD", StringComparison.OrdinalIgnoreCase) ? "Pending" : "Pending",
            CreatedAt = DateTime.UtcNow
        };
        _context.Payments.Add(payment);

        await _context.SaveChangesAsync(ct);

        if (req.UseCartFromDatabase)
            await _cartService.ClearCartAsync(req.UserId, ct);

        return new CheckoutResponseDto
        {
            OrderId = order.OrderId,
            TotalPrice = total,
            DiscountAmount = discountAmount,
            Status = order.Status,
            PaymentId = payment.PaymentId,
            PaymentStatus = payment.Status
        };
    }
}
