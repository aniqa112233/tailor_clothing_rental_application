// lib/models/order_model.dart
import 'package:flutter/foundation.dart';

class OrderModel {
  final String? id;
  final String userId;
  final String? tailorId;
  final String orderType; // "stitching" or "rental"
  final String serviceId;
  final Map<String, dynamic>? measurements;
  final String status; // Pending / In Progress / Ready / Delivered / Cancelled
  final DateTime? deliveryDate;
  final double totalAmount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderModel({
    this.id,
    required this.userId,
    this.tailorId,
    required this.orderType,
    required this.serviceId,
    this.measurements,
    required this.status,
    this.deliveryDate,
    required this.totalAmount,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      tailorId: json['tailor_id'] as String?,
      orderType: json['order_type'] as String,
      serviceId: json['service_id'] as String,
      measurements: (json['measurements'] as Map?)?.cast<String, dynamic>(),
      status: json['status'] as String,
      deliveryDate: json['delivery_date'] != null
          ? DateTime.parse(json['delivery_date'] as String)
          : null,
      totalAmount: (json['total_amount'] is num)
          ? (json['total_amount'] as num).toDouble()
          : double.parse(json['total_amount'].toString()),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'tailor_id': tailorId,
      'order_type': orderType,
      'service_id': serviceId,
      'measurements': measurements,
      'status': status,
      'delivery_date': deliveryDate?.toIso8601String(),
      'total_amount': totalAmount,
    };
  }

  OrderModel copyWith({
    String? status,
    String? tailorId,
    DateTime? deliveryDate,
  }) {
    return OrderModel(
      id: id,
      userId: userId,
      tailorId: tailorId ?? this.tailorId,
      orderType: orderType,
      serviceId: serviceId,
      measurements: measurements,
      status: status ?? this.status,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      totalAmount: totalAmount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
