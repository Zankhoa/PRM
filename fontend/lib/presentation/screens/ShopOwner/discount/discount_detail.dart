import 'package:flutter/material.dart';
import 'package:shop_owner_screen/data/service/discount_service.dart';
import 'package:shop_owner_screen/data/models/discount_dto.dart';

class DiscountDetailScreen extends StatelessWidget {
  final int id;

  const DiscountDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Discount Detail")),
      body: FutureBuilder<DiscountDTO>(
  future: DiscountService.getDetail(id),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    final d = snapshot.data!;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              d.discountCode,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text("Discount: ${d.percentDiscount}%"),
            Text("Start: ${d.startDate}"),
            Text("End: ${d.endDate}"),
            Text("Status: ${d.isActive ? "Active" : "Inactive"}"),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  await DiscountService.delete(d.discountId);
                  Navigator.pop(context);
                },
                child: const Text("Delete"),
              ),
            )
          ],
        ),
      ),
    );
  },
)
    ) ;
  }
}