import 'package:flutter/material.dart';

class TailorProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  // Simulated local data (Supabase integration later)
  Map<String, dynamic>? _tailorProfile;

  Map<String, dynamic>? get tailorProfile => _tailorProfile;

  Future<void> registerTailor(Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // fake API delay
    _tailorProfile = data;

    _loading = false;
    notifyListeners();
  }

  Future<void> updateTailorProfile(Map<String, dynamic> data) async {
    _tailorProfile?.addAll(data);
    notifyListeners();
  }
}
