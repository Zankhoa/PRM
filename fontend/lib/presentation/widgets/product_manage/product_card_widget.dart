import 'package:flutter/material.dart';
import 'package:shop_owner_screen/data/models/product_manage_dto.dart';
import 'package:shop_owner_screen/presentation/screens/ShopOwner/UpdateProduct.dart';


class ProductCardWidget extends StatelessWidget {
  final ProductManageDto product;

  const ProductCardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              // Nếu không có ảnh từ DB thì dùng ảnh mặc định
              product.avatarImage ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjarPqQQhlhk1FkuQNgR9-EGuZQQth3NHKJQ&s",
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => 
                  Container(width: 60, height: 60, color: Colors.grey[200], child: const Icon(Icons.broken_image)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.nameProduct,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product.category ?? "Không có mô tả",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product.isAvailable ? "Còn hàng" : "Hết hàng",
                  style: TextStyle(
                    fontSize: 12,
                    color: product.isAvailable ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "\$${product.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.blueGrey),
                onPressed: () async {
                  // Đợi kết quả trả về từ màn Update
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UpdateProduct(
                        initialData: {
                          'productId': product.productId, // Cực kỳ quan trọng
                          'title': product.nameProduct,
                          'price': product.price.toString(),
                          'image': product.avatarImage, 
                          'description': product.description, // Nếu có mô tả
                          'category': product.category, // Nếu có category
                          'isAvailable': product.isAvailable,
                        
                        },
                      ),
                    ),
                  );
                  if (result == true) {
                    // Gọi hàm fetch list ở đây (hoặc truyền callback)
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () {
                  // Thêm logic gọi API xóa sản phẩm ở đây
                  print("Xóa sản phẩm: ${product.productId}");
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}