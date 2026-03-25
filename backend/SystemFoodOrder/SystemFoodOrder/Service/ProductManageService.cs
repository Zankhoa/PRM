using Microsoft.AspNetCore.Mvc;
using SystemFoodOrder.Data;
using SystemFoodOrder.Model.DTOs;
using SystemFoodOrder.Model.Entities;
using Microsoft.EntityFrameworkCore;

namespace SystemFoodOrder.Service
{
    public class ProductManageService 
    {
        private readonly AppDbContext _context;

        public ProductManageService(AppDbContext context)
        {
            _context = context;
        }

        public async Task<List<OrderHistoryDTOs>> GetOrderVerifyByUserId(int page = 1, int pageSize = 20)
        {
            var query = _context.Orders.OrderByDescending(x => x.CreatedAt);
            var data = await query
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .SelectMany(order => order.OrderDetails, (order, detailt) => new OrderHistoryDTOs
                {
                    OrderId = order.OrderId,
                    NameProducts = detailt.Product.Name,
                    TotalPrice = order.TotalPrice,
                    Status = order.Status,
                    CreatedAt = order.CreatedAt,
                    Quantity = order.OrderDetails.Count()
                })
                .ToListAsync();
            return data;
        }
        public async Task<List<ProductManageDTOs>> GetProductManageByUserId(int userId, int page = 1, int pageSize = 20)
        {
            var query =  _context.Products.Where(x => x.UserId == userId);
            query = query.OrderByDescending(x => x.CreatedAt);
            var data = await query.Skip((page - 1) * pageSize).Take(pageSize).Select(t => new ProductManageDTOs
            {
                ProductId = t.ProductId,
                avatarImage = t.AvatarProducts,
                NameProduct = t.Name,
                Price = t.Price,
                Status = t.IsAvailable,
                Category = t.Category,
                Description = t.Description
            }).ToListAsync();
            return data;
        }
        public async Task<bool> CreateProduct(ProductManageRequest product)
        {
            try
            {
                var createProduct = new Product
                {
                    UserId = product.UserId,
                    Name = product.Name,
                    Price = product.Price,
                    AvatarProducts = product.AvatarProducts,
                    IsAvailable = product.IsAvailable,
                    CreatedAt = DateTime.UtcNow,
                    Category = product.Category,
                    Description = product.Description,
                };
                await _context.Products.AddAsync(createProduct);
                var result = await _context.SaveChangesAsync();
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }
        public async Task<bool> UpdateProduct(ProductManageRequest product)
        {
            try
            {
                var existingProduct = await _context.Products.FirstOrDefaultAsync(x => x.ProductId == product.ProductId);
                if (existingProduct == null) return false;
                // Update fields
                existingProduct.Name = product.Name;
                existingProduct.Price = product.Price;
                existingProduct.AvatarProducts = product.AvatarProducts;
                existingProduct.IsAvailable = product.IsAvailable;
                existingProduct.Category = product.Category;
                existingProduct.Description = product.Description;
                var result = await _context.SaveChangesAsync();
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

    }
}
