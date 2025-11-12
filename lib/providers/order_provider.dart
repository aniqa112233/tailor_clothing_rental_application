
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';

class OrderProvider with ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  List<OrderModel> _orders = [];
  bool _loading = false;

  List<OrderModel> get orders => _orders;
  bool get loading => _loading;

  /// Fetch orders for a specific user
  Future<void> fetchOrdersForUser(String userId) async {
    try {
      _loading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      final List<dynamic> res = await supabase
          .from('orders')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      _orders = res.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      if (kDebugMode) print('fetchOrdersForUser error: $e');
      rethrow;
    } finally {
      _loading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  /// Fetch orders assigned to a specific tailor
  Future<void> fetchOrdersForTailor(String tailorId) async {
    try {
      _loading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      final List<dynamic> res = await supabase
          .from('orders')
          .select('*')
          .eq('tailor_id', tailorId)
          .order('created_at', ascending: false);

      _orders = res.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      if (kDebugMode) print('fetchOrdersForTailor error: $e');
      rethrow;
    } finally {
      _loading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  /// Get order details by ID
  Future<OrderModel?> getOrderById(String id) async {
    try {
      final dynamic res = await supabase
          .from('orders')
          .select('*')
          .eq('id', id)
          .single();

      if (res is Map) {
        return OrderModel.fromJson(res as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      if (kDebugMode) print('getOrderById error: $e');
      rethrow;
    }
  }

  /// Create a new order
  Future<void> createOrder(OrderModel order) async {
    try {
      final dynamic res =
          await supabase.from('orders').insert(order.toJson()).select().single();

      if (res is Map) {
        final created = OrderModel.fromJson(res as Map<String, dynamic>);
        _orders.insert(0, created);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      }
    } catch (e) {
      if (kDebugMode) print('createOrder error: $e');
      rethrow;
    }
  }

  /// Update the status of an order
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      final dynamic res = await supabase
          .from('orders')
          .update({
            'status': status,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', orderId)
          .select()
          .single();

      if (res is Map) {
        final updated = OrderModel.fromJson(res as Map<String, dynamic>);
        final idx = _orders.indexWhere((o) => o.id == orderId);
        if (idx >= 0) _orders[idx] = updated;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      }
    } catch (e) {
      if (kDebugMode) print('updateOrderStatus error: $e');
      rethrow;
    }
  }

  /// Cancel an existing order
  Future<void> cancelOrder(String orderId) async {
    await updateOrderStatus(orderId, 'Cancelled');
  }
}
