using Microsoft.EntityFrameworkCore;
using SystemFoodOrder.Data;
using SystemFoodOrder.Model.DTOs;
using SystemFoodOrder.Model.Entities;

namespace SystemFoodOrder.Service
{
    public class DiscountService
    {
        private readonly AppDbContext _context;

        public DiscountService(AppDbContext context)
        {
            _context = context;
        }

        // Lấy danh sách discount của shop owner (cho màn Manage Discount)
        public async Task<List<DiscountListDTO>> GetDiscountsByShopOwner(int userId)
        {
            var discounts = await _context.Discounts
                .Where(d => d.UserId == userId)
                .OrderByDescending(d => d.DiscountId)
                .Select(d => new DiscountListDTO
                {
                    DiscountId = d.DiscountId,
                    DiscountCode = d.DiscountCode,
                    StartDate = d.StartDate,
                    EndDate = d.EndDate,
                    PercentDiscount = d.PercentDiscount,
                    IsActived = d.IsActived
                })
                .ToListAsync();

            return discounts;
        }

        // Lấy chi tiết discount (cho màn Detail/Update)
        public async Task<Discount?> GetDiscountById(int discountId, int userId)
        {
            return await _context.Discounts
                .FirstOrDefaultAsync(d => d.DiscountId == discountId && d.UserId == userId);
        }

        // Tạo discount mới (cho màn Add Discount)
        public async Task<Discount?> CreateDiscount(CreateDiscountDTO dto, int userId)
        {
            // Kiểm tra mã code đã tồn tại chưa
            var exists = await _context.Discounts
                .AnyAsync(d => d.DiscountCode == dto.DiscountCode);

            if (exists)
            {
                return null; // Code đã tồn tại
            }

            var discount = new Discount
            {
                UserId = userId,
                DiscountCode = dto.DiscountCode,
                PercentDiscount = dto.PercentDiscount,
                StartDate = dto.StartDate,
                EndDate = dto.EndDate,
                IsActived = true,
                OrderId = null // Vô hạn, không giới hạn order
            };

            _context.Discounts.Add(discount);
            await _context.SaveChangesAsync();

            return discount;
        }

        // Cập nhật discount (cho màn Detail/Update)
        public async Task<Discount?> UpdateDiscount(int discountId, UpdateDiscountDTO dto, int userId)
        {
            var discount = await _context.Discounts
                .FirstOrDefaultAsync(d => d.DiscountId == discountId && d.UserId == userId);

            if (discount == null)
            {
                return null;
            }

            // Update các trường nếu có
            if (!string.IsNullOrEmpty(dto.DiscountCode))
            {
                // Kiểm tra code mới có bị trùng không
                var codeExists = await _context.Discounts
                    .AnyAsync(d => d.DiscountCode == dto.DiscountCode && d.DiscountId != discountId);

                if (codeExists)
                {
                    return null;
                }

                discount.DiscountCode = dto.DiscountCode;
            }

            if (dto.PercentDiscount.HasValue)
                discount.PercentDiscount = dto.PercentDiscount.Value;

            if (dto.StartDate.HasValue)
                discount.StartDate = dto.StartDate.Value;

            if (dto.EndDate.HasValue)
                discount.EndDate = dto.EndDate.Value;

            if (dto.IsActived.HasValue)
                discount.IsActived = dto.IsActived.Value;

            await _context.SaveChangesAsync();

            return discount;
        }

        // Xóa discount (soft delete)
        public async Task<bool> DeleteDiscount(int discountId, int userId)
        {
            var discount = await _context.Discounts
                .FirstOrDefaultAsync(d => d.DiscountId == discountId && d.UserId == userId);

            if (discount == null)
            {
                return false;
            }

            // Soft delete: chỉ set IsActived = false
            discount.IsActived = false;
            await _context.SaveChangesAsync();

            return true;
        }

        // Lấy thống kê Dashboard
        public async Task<ShopDashboardDTO> GetDashboardStats(int userId)
        {
            // Lấy tất cả products của shop owner
            var products = await _context.Products
                .Where(p => p.UserId == userId)
                .ToListAsync();

            var productIds = products.Select(p => p.ProductId).ToList();

            // Lấy order details của các products này
            var orderDetails = await _context.OrderDetails
                .Include(od => od.Order)
                .Where(od => productIds.Contains(od.ProductId ?? 0) &&
                            od.Order != null &&
                            od.Order.Status != "Cancelled")
                .ToListAsync();

            // Tính tổng doanh thu
            var totalRevenue = orderDetails.Sum(od => od.Price * od.Quantity);

            // Đếm số orders (distinct)
            var totalOrders = orderDetails
                .Where(od => od.OrderId.HasValue)
                .Select(od => od.OrderId!.Value)
                .Distinct()
                .Count();

            // Đếm discounts đang active
            var now = DateTime.Now;
            var activeDiscounts = await _context.Discounts
                .CountAsync(d => d.UserId == userId &&
                               (d.IsActived ?? false) &&
                               (!d.EndDate.HasValue || d.EndDate.Value >= now));

            // Tính top sản phẩm bán chạy
            var topProducts = products.Select(p => new ProductSalesDTO
            {
                ProductId = p.ProductId,
                ProductName = p.Name,
                Category = p.Category,
                Price = p.Price,
                SoldCount = orderDetails
                    .Where(od => od.ProductId == p.ProductId)
                    .Sum(od => od.Quantity),
                Revenue = orderDetails
                    .Where(od => od.ProductId == p.ProductId)
                    .Sum(od => od.Price * od.Quantity)
            })
            .OrderByDescending(p => p.SoldCount)
            .Take(10)
            .ToList();

            return new ShopDashboardDTO
            {
                TotalRevenue = totalRevenue,
                TotalOrders = totalOrders,
                TotalProducts = products.Count,
                ActiveDiscounts = activeDiscounts,
                TopProducts = topProducts
            };
        }
    }
}