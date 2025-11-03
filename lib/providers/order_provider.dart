// // lib/providers/order_provider.dart
// import 'package:flutter/foundation.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/order_model.dart';

// class OrderProvider with ChangeNotifier {
//   final SupabaseClient supabase = Supabase.instance.client;

//   List<OrderModel> _orders = [];
//   bool _loading = false;

//   List<OrderModel> get orders => _orders;
//   bool get loading => _loading;

//   Future<void> fetchOrdersForUser(String userId) async {
//     _loading = true;
//     notifyListeners();
//     final res = await supabase
//         .from('orders')
//         .select('*')
//         .eq('user_id', userId)
//         .order('created_at', ascending: false);
//     if (res.error != null) {
//       _loading = false;
//       notifyListeners();
//       throw res.error!;
//     }
//     final data = res as List<dynamic>;
//     _orders = data.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
//     _loading = false;
//     notifyListeners();
//   }

//   Future<void> fetchOrdersForTailor(String tailorId) async {
//     _loading = true;
//     notifyListeners();
//     final res = await supabase
//         .from('orders')
//         .select('*')
//         .eq('tailor_id', tailorId)
//         .order('created_at', ascending: false);
//     if (res.error != null) {
//       _loading = false;
//       notifyListeners();
//       throw res.error!;
//     }
//     final data = res as List<dynamic>;
//     _orders = data.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
//     _loading = false;
//     notifyListeners();
//   }

//   Future<OrderModel?> getOrderById(String id) async {
//     final res = await supabase.from('orders').select('*').eq('id', id).single();
//     if (res.error != null) throw res.error!;
//     return OrderModel.fromJson(res as Map<String, dynamic>);
//   }

//   Future<void> createOrder(OrderModel order) async {
//     final res = await supabase.from('orders').insert(order.toJson()).select().single();
//     if (res.error != null) throw res.error!;
//     // optionally push to local list
//     final created = OrderModel.fromJson(res as Map<String, dynamic>);
//     _orders.insert(0, created);
//     notifyListeners();
//   }

//   Future<void> updateOrderStatus(String orderId, String status) async {
//     final res = await supabase.from('orders').update({
//       'status': status,
//       'updated_at': DateTime.now().toIso8601String(),
//     }).eq('id', orderId).select().single();
//     if (res.error != null) throw res.error!;
//     final updated = OrderModel.fromJson(res as Map<String, dynamic>);
//     final idx = _orders.indexWhere((o) => o.id == orderId);
//     if (idx >= 0) _orders[idx] = updated;
//     notifyListeners();
//   }

//   Future<void> cancelOrder(String orderId) async {
//     await updateOrderStatus(orderId, 'Cancelled');
//   }
// }
// // lib/providers/order_provider.dart
// import 'package:flutter/foundation.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/order_model.dart';

// class OrderProvider with ChangeNotifier {
//   final SupabaseClient supabase = Supabase.instance.client;

//   List<OrderModel> _orders = [];
//   bool _loading = false;

//   List<OrderModel> get orders => _orders;
//   bool get loading => _loading;

//   /// Fetch orders for a specific user
//   Future<void> fetchOrdersForUser(String userId) async {
//     try {
//       _loading = true;
//       notifyListeners();

//       final res = await supabase
//           .from('orders')
//           .select('*')
//           .eq('user_id', userId)
//           .order('created_at', ascending: false);

//       if (res is List) {
//         _orders = res.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('fetchOrdersForUser error: $e');
//       }
//       rethrow;
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   /// Fetch orders assigned to a specific tailor
//   Future<void> fetchOrdersForTailor(String tailorId) async {
//     try {
//       _loading = true;
//       notifyListeners();

//       final res = await supabase
//           .from('orders')
//           .select('*')
//           .eq('tailor_id', tailorId)
//           .order('created_at', ascending: false);

//       if (res is List) {
//         _orders = res.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('fetchOrdersForTailor error: $e');
//       }
//       rethrow;
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   /// Get order details by ID
//   Future<OrderModel?> getOrderById(String id) async {
//     try {
//       final res = await supabase.from('orders').select('*').eq('id', id).single();
//       if (res is Map) {
//         return OrderModel.fromJson(res as Map<String, dynamic>);
//       }
//       return null;
//     } catch (e) {
//       if (kDebugMode) {
//         print('getOrderById error: $e');
//       }
//       rethrow;
//     }
//   }

//   /// Create a new order
//   Future<void> createOrder(OrderModel order) async {
//     try {
//       final res = await supabase.from('orders').insert(order.toJson()).select().single();
//       if (res is Map) {
//         final created = OrderModel.fromJson(res as Map<String, dynamic>);
//         _orders.insert(0, created);
//         notifyListeners();
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('createOrder error: $e');
//       }
//       rethrow;
//     }
//   }

//   /// Update the status of an order
//   Future<void> updateOrderStatus(String orderId, String status) async {
//     try {
//       final res = await supabase
//           .from('orders')
//           .update({
//             'status': status,
//             'updated_at': DateTime.now().toIso8601String(),
//           })
//           .eq('id', orderId)
//           .select()
//           .single();

//       if (res is Map) {
//         final updated = OrderModel.fromJson(res as Map<String, dynamic>);
//         final idx = _orders.indexWhere((o) => o.id == orderId);
//         if (idx >= 0) _orders[idx] = updated;
//         notifyListeners();
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('updateOrderStatus error: $e');
//       }
//       rethrow;
//     }
//   }

//   /// Cancel an existing order
//   Future<void> cancelOrder(String orderId) async {
//     await updateOrderStatus(orderId, 'Cancelled');
//   }
// }
// lib/providers/order_provider.dart
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
      // ✅ Delay notifyListeners until after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      final res = await supabase
          .from('orders')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      if (res is List) {
        _orders = res.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print('fetchOrdersForUser error: $e');
      }
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

      final res = await supabase
          .from('orders')
          .select('*')
          .eq('tailor_id', tailorId)
          .order('created_at', ascending: false);

      if (res is List) {
        _orders = res.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print('fetchOrdersForTailor error: $e');
      }
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
      final res = await supabase.from('orders').select('*').eq('id', id).single();
      if (res is Map) {
        return OrderModel.fromJson(res as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('getOrderById error: $e');
      }
      rethrow;
    }
  }

  /// Create a new order
  Future<void> createOrder(OrderModel order) async {
    try {
      final res = await supabase.from('orders').insert(order.toJson()).select().single();
      if (res is Map) {
        final created = OrderModel.fromJson(res as Map<String, dynamic>);
        _orders.insert(0, created);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('createOrder error: $e');
      }
      rethrow;
    }
  }

  /// Update the status of an order
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      final res = await supabase
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
      if (kDebugMode) {
        print('updateOrderStatus error: $e');
      }
      rethrow;
    }
  }

  /// Cancel an existing order
  Future<void> cancelOrder(String orderId) async {
    await updateOrderStatus(orderId, 'Cancelled');
  }
}
