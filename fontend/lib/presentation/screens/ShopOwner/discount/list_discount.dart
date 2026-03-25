import 'package:flutter/material.dart';
import 'package:shop_owner_screen/data/service/discount_service.dart';
import 'package:shop_owner_screen/data/models/discount_dto.dart';
import 'create_discount.dart';
import 'discount_detail.dart';

class ListDiscountScreen extends StatelessWidget {
  const ListDiscountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Discount Management"),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<List<DiscountDTO>>(
        future: DiscountService.getDiscounts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;

          if (data.isEmpty) {
            return const Center(child: Text("No discount available"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final d = data[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  title: Text(
                    d.discountCode,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text("Discount: ${d.percentDiscount}%"),
                      Text("Valid: ${d.startDate} → ${d.endDate}"),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DiscountDetailScreen(id: d.discountId),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateDiscountScreen(),
            ),
          );
        },
      ),
    );
  }
}