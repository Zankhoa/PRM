import 'package:flutter/material.dart';
import '../discount/discount_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Giỏ hàng',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          /// LIST SẢN PHẨM
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _cartItem(
                  name: "Milk Tea",
                  option: "Size L, 50% Sugar",
                  price: 5.50,
                  quantity: 1,
                ),
                _cartItem(
                  name: "Matcha Latte",
                  option: "Size M, 100% Ice",
                  price: 6.00,
                  quantity: 2,
                ),
              ],
            ),
          ),

          /// TỔNG TIỀN + BUTTON
          _checkoutSection(context),
        ],
      ),
    );
  }

  // ================= CART ITEM =================
  Widget _cartItem({
    required String name,
    required String option,
    required double price,
    required int quantity,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          /// IMAGE
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.local_drink,
                color: Colors.green, size: 32),
          ),
          const SizedBox(width: 16),

          /// INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(option,
                    style: TextStyle(
                        fontSize: 13, color: Colors.grey[600])),
                const SizedBox(height: 8),
                Text(
                  "\$${price.toStringAsFixed(2)}",
                  style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ],
            ),
          ),

          /// QUANTITY
          Column(
            children: [
              _qtyButton(Icons.add),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(quantity.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              _qtyButton(Icons.remove),
            ],
          )
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Icon(icon, size: 16),
    );
  }

  // ================= CHECKOUT =================
  Widget _checkoutSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Tổng cộng",
                  style: TextStyle(fontSize: 15, color: Colors.grey)),
              Text("\$17.50",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                /// CART → DISCOUNT
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DiscountPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                "Tiếp tục",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
