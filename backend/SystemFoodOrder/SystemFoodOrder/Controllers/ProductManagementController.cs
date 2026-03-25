using Microsoft.AspNetCore.Mvc;
using SystemFoodOrder.Model.DTOs;
using SystemFoodOrder.Service;

namespace SystemFoodOrder.Controllers
{
    [Route("api/shop-owner/{userId}/products")]
    [ApiController]
    public class ProductManagementController : ControllerBase 
    {
        private readonly ProductManageService _productManage; 

        public ProductManagementController(ProductManageService productManage)
        {
            _productManage = productManage;
        }
        [HttpGet]
        public async Task<IActionResult> GetProductManagement(int userId, int page , int pageSize )
        {
            var products = await _productManage.GetProductManageByUserId(userId,page,pageSize);
            if (products == null)
                return NotFound(new { message = "Không tìm thấy sản phẩm" });
            return Ok(products);
        }

        [HttpPost]
        public async Task<IActionResult> CreateProduct(int userId, [FromBody] ProductManageRequest product)
        {
            var result = await _productManage.CreateProduct(product);
            if (!result)
            return BadRequest(new { message = "Tạo sản phẩm thất bại do dữ liệu không hợp lệ" });
            return Ok(new { message = "Tạo sản phẩm thành công" });
        }

        [HttpPut]
        public async Task<IActionResult> UpdateProduct(int userId, [FromBody] ProductManageRequest product)
        {
            var result = await _productManage.UpdateProduct(product);
            if (!result)
            return BadRequest(new { message = "Cập nhật thất bại" });
            return Ok(new { message = "Cập nhật thành công" });
        }

    }
}