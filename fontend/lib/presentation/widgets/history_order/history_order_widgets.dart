import 'package:flutter/material.dart';
import 'package:shop_owner_screen/data/models/order_history_dto.dart';

class OrderCardWidget extends StatelessWidget {
  final OrderHistoryDto order;

  const OrderCardWidget({super.key, required this.order});
  // ham phu de map so status tu db ra mau sac va hien thi
  Map<String, dynamic> _getStatusConfig(String status){
   switch(status){
      case 'Pending':
        return {'text': 'Pending', 'color': Colors.orange};
      case 'Processing':
        return {'text': 'Processing', 'color': Colors.blue};
      case 'Completed':
        return {'text': 'Completed', 'color': Colors.green};
      case 'Cancelled':
        return {'text': 'Cancelled', 'color': Colors.red};
      default:
        return {'text': status, 'color': Colors.grey};
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusConfig = _getStatusConfig(order.status);
   final formattedDate = "${order.createdAt.day}/${order.createdAt.month} - ${order.createdAt.hour}:${order.createdAt.minute}";

   return Container(
    margin : const EdgeInsets.only(bottom: 15),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.grey.withOpacity(0.2))
    ),
    child: Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: const DecorationImage(
              image: AssetImage('assets/images/order_icon.png'),
              fit: BoxFit.cover
            )
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Text(
              order.nameProducts,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
             ),
             const SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  statusConfig['text'],
                  style: TextStyle(
                    color: statusConfig['color'],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        )
    ],
    ),
   );
  }
}