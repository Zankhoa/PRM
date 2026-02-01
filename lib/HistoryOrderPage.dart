import 'package:flutter/material.dart';

// Đừng quên file AppColors bạn đã tạo nhé!
class OrderHistoryDesign extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
        title: Text(
          "Order History",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
               border: Border.all(color: const Color.fromARGB(255, 5, 2, 2).withOpacity(0.2)),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search past orders",
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),

          //title list
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 10, bottom: 10),
            child: Text(
              "RECENT TRANSACTIONS",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),

          // 3. Order List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildOrderItem(
                  "Starbucks Reserve",
                  "Oct 24, 10:30 AM",
                  "\$5.50",
                  "Completed",
                  Colors.green,
                ),
                _buildOrderItem(
                  "Bubble Tea Co",
                  "Oct 22, 02:15 PM",
                  "\$6.00",
                  "Completed",
                  Colors.green,
                ),
                _buildOrderItem(
                  "Green Leaf Tea",
                  "Oct 20, 09:45 AM",
                  "\$4.25",
                  "Cancelled",
                  Colors.red,
                ),
                _buildOrderItem(
                  "Fruity Fresh",
                  "Oct 18, 12:00 PM",
                  "\$7.20",
                  "Completed",
                  Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Giữ các icon cố định vị trí
        currentIndex: 2, // Giả sử 'History' là index thứ 2 (đang được chọn)
        selectedItemColor: Colors.greenAccent[400], // Màu xanh lá như trong ảnh
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket_outlined),
            activeIcon: Icon(Icons.shopping_basket),
            label: 'Order',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // Widget con cho từng Item đơn hàng
  Widget _buildOrderItem(
    String name,
    String date,
    String price,
    String status,
    Color statusColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: const DecorationImage(
                image: NetworkImage(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjarPqQQhlhk1FkuQNgR9-EGuZQQth3NHKJQ&s",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Icon(Icons.circle, size: 12, color: statusColor.withOpacity(0.5)),
            ],
          ),
        ],
      ),
    );
  }
}
