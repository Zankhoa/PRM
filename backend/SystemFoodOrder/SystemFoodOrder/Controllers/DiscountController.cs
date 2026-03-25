using Microsoft.AspNetCore.Mvc;
using SystemFoodOrder.Model.DTOs;
using SystemFoodOrder.Service;

namespace SystemFoodOrder.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DiscountController : ControllerBase
    {
        private readonly DiscountService _discountService;

        public DiscountController(DiscountService discountService)
        {
            _discountService = discountService;
        }

        // ============ MÀN HÌNH: MANAGE DISCOUNT (LIST) ============
        /// <summary>
        /// Lấy danh sách tất cả discount codes của shop owner
        /// </summary>
        /// <param name="userId">ID của shop owner</param>
        [HttpGet("shop/{userId}")]
        public async Task<IActionResult> GetDiscountsByShop(int userId)
        {
            var discounts = await _discountService.GetDiscountsByShopOwner(userId);
            return Ok(discounts);
        }

        // ============ MÀN HÌNH: DISCOUNT DETAIL ============
        /// <summary>
        /// Lấy chi tiết một discount code
        /// </summary>
        /// <param name="discountId">ID của discount</param>
        /// <param name="userId">ID của shop owner</param>
        [HttpGet("{discountId}/shop/{userId}")]
        public async Task<IActionResult> GetDiscountDetail(int discountId, int userId)
        {
            var discount = await _discountService.GetDiscountById(discountId, userId);

            if (discount == null)
            {
                return NotFound(new { message = "Discount not found or you don't have permission" });
            }

            return Ok(discount);
        }

        // ============ MÀN HÌNH: ADD DISCOUNT ============
        /// <summary>
        /// Tạo mã giảm giá mới
        /// </summary>
        /// <param name="userId">ID của shop owner</param>
        /// <param name="dto">Thông tin discount</param>
        [HttpPost("shop/{userId}")]
        public async Task<IActionResult> CreateDiscount(int userId, [FromBody] CreateDiscountDTO dto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var discount = await _discountService.CreateDiscount(dto, userId);

            if (discount == null)
            {
                return BadRequest(new { message = "Discount code already exists" });
            }

            return CreatedAtAction(
                nameof(GetDiscountDetail),
                new { discountId = discount.DiscountId, userId = userId },
                discount
            );
        }

        // ============ MÀN HÌNH: UPDATE DISCOUNT ============
        /// <summary>
        /// Cập nhật thông tin discount
        /// </summary>
        /// <param name="discountId">ID của discount</param>
        /// <param name="userId">ID của shop owner</param>
        /// <param name="dto">Thông tin cập nhật</param>
        [HttpPut("{discountId}/shop/{userId}")]
        public async Task<IActionResult> UpdateDiscount(int discountId, int userId, [FromBody] UpdateDiscountDTO dto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var discount = await _discountService.UpdateDiscount(discountId, dto, userId);

            if (discount == null)
            {
                return BadRequest(new { message = "Discount not found, code exists, or you don't have permission" });
            }

            return Ok(discount);
        }

        // ============ XÓA DISCOUNT ============
        /// <summary>
        /// Xóa (vô hiệu hóa) discount
        /// </summary>
        /// <param name="discountId">ID của discount</param>
        /// <param name="userId">ID của shop owner</param>
        [HttpDelete("{discountId}/shop/{userId}")]
        public async Task<IActionResult> DeleteDiscount(int discountId, int userId)
        {
            var success = await _discountService.DeleteDiscount(discountId, userId);

            if (!success)
            {
                return NotFound(new { message = "Discount not found or you don't have permission" });
            }

            return Ok(new { message = "Discount deleted successfully" });
        }
    }
}