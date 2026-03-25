using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using SystemFoodOrder.Data;
using SystemFoodOrder.Model.DTOs;
using SystemFoodOrder.Service;

namespace SystemFoodOrder.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ShopOwnerController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly DiscountService _discountService;

        public ShopOwnerController(AppDbContext context, DiscountService discountService)
        {
            _context = context;
            _discountService = discountService;
        }

        // ============ MÀN HÌNH: SHOP OWNER DASHBOARD ============
        /// <summary>
        /// Lấy thống kê dashboard cho shop owner
        /// </summary>
        /// <param name="userId">ID của shop owner</param>
        [HttpGet("{userId}/dashboard")]
        public async Task<IActionResult> GetDashboard(int userId)
        {
            var stats = await _discountService.GetDashboardStats(userId);
            return Ok(stats);
        }

        /// <summary>
        /// Lấy danh sách sản phẩm bán chạy theo category (cho filter trong dashboard)
        /// </summary>
        /// <param name="userId">ID của shop owner</param>
        /// <param name="category">Category để filter (optional)</param>
        [HttpGet("{userId}/products/sales")]
        public async Task<IActionResult> GetProductSales(int userId, [FromQuery] string? category = null)
        {
            var products = await _context.Products
                .Where(p => p.UserId == userId && (category == null || p.Category == category))
                .ToListAsync();

            var productIds = products.Select(p => p.ProductId).ToList();

            var orderDetails = await _context.OrderDetails
                .Include(od => od.Order)
                .Where(od => productIds.Contains(od.ProductId) &&
                             od.Order != null &&
                             od.Order.Status != "Cancelled")
                .ToListAsync();

            var salesData = products.Select(p => new ProductSalesDTO
            {
                ProductId = p.ProductId,
                ProductName = p.Name,
                Category = p.Category,
                Price = p.Price,
                SoldCount = orderDetails.Where(od => od.ProductId == p.ProductId).Sum(od => od.Quantity),
                Revenue = orderDetails.Where(od => od.ProductId == p.ProductId).Sum(od => od.Price * od.Quantity)
            })
            .OrderByDescending(p => p.SoldCount)
            .ToList();

            return Ok(salesData);
        }

        /// <summary>
        /// Lấy danh sách categories của shop owner (cho filter)
        /// </summary>
        /// <param name="userId">ID của shop owner</param>
        [HttpGet("{userId}/categories")]
        public async Task<IActionResult> GetCategories(int userId)
        {
            var categories = await _context.Products
                .Where(p => p.UserId == userId && p.Category != null)
                .Select(p => p.Category)
                .Distinct()
                .ToListAsync();

            return Ok(categories);
        }

        // ============ MÀN HÌNH: SHOP OWNER PROFILE ============
        /// <summary>
        /// Lấy thông tin profile của shop owner
        /// </summary>
        /// <param name="userId">ID của shop owner</param>
        [HttpGet("{userId}/profile")]
        public async Task<IActionResult> GetProfile(int userId)
        {
            var user = await _context.Users
                .Where(u => u.UserId == userId)
                .Select(u => new ShopProfileDTO
                {
                    UserId = u.UserId,
                    Username = u.Username,
                    FullName = u.FullName,
                    Phone = u.Phone,
                    Email = u.Email,
                    Address = u.Address,
                    AvatarUser = u.AvatarUser,
                    CreatedAt = u.CreatedAt ?? DateTime.Now
                })
                .FirstOrDefaultAsync();

            if (user == null)
            {
                return NotFound(new { message = "User not found" });
            }

            return Ok(user);
        }

        // ============ MÀN HÌNH: EDIT PROFILE ============
        /// <summary>
        /// Cập nhật profile của shop owner
        /// </summary>
        /// <param name="userId">ID của shop owner</param>
        /// <param name="dto">Thông tin cập nhật</param>
        [HttpPut("{userId}/profile")]
        public async Task<IActionResult> UpdateProfile(int userId, [FromBody] UpdateProfileDTO dto)
        {
            var user = await _context.Users.FindAsync(userId);

            if (user == null)
            {
                return NotFound(new { message = "User not found" });
            }

            // Update các trường nếu có
            if (!string.IsNullOrEmpty(dto.FullName))
                user.FullName = dto.FullName;

            if (dto.Phone != null)
                user.Phone = dto.Phone;

            if (dto.Email != null)
            {
                // Kiểm tra email đã tồn tại chưa
                var emailExists = await _context.Users
                    .AnyAsync(u => u.Email == dto.Email && u.UserId != userId);

                if (emailExists)
                {
                    return BadRequest(new { message = "Email already exists" });
                }

                user.Email = dto.Email;
            }

            if (dto.Address != null)
                user.Address = dto.Address;

            if (dto.AvatarUser != null)
                user.AvatarUser = dto.AvatarUser;

            await _context.SaveChangesAsync();

            return Ok(new { message = "Profile updated successfully", user });
        }
    }
}