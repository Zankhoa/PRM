import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ===================================================================
// 1. DATA MODEL: Hứng dữ liệu từ API C# trả về
// ===================================================================
class OrderItem {
  final int id; // Backend C# thường dùng int cho OrderId
  final String title;
  final String subtitle;
  final double price;
  final String imageUrl;
  final DateTime orderTime;
  String status;

  OrderItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imageUrl,
    required this.orderTime,
    required this.status,
  });

  // Hàm chuyển đổi JSON sang Object
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['orderId'] ?? 0,
      title: json['nameProducts'] ?? 'Đơn hàng không tên',
      subtitle: "Số lượng: ${json['quantity'] ?? 1}", 
      price: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['avatarImage'] ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjarPqQQhlhk1FkuQNgR9-EGuZQQth3NHKJQ&s",
      orderTime: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      status: json['status']?.toString() ?? 'Pending',
    );
  }
}