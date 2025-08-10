import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/prayer_request.dart';
import '../services/database_service.dart';

class PrayerRequestProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<PrayerRequest> _prayerRequests = [];
  bool _isLoading = false;
  String? _error;

  List<PrayerRequest> get prayerRequests => _prayerRequests;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<PrayerRequest> get activePrayerRequests => _prayerRequests
      .where((request) => request.status != PrayerRequestStatus.answered)
      .toList();

  List<PrayerRequest> get answeredPrayerRequests => _prayerRequests
      .where((request) => request.status == PrayerRequestStatus.answered)
      .toList();

  List<PrayerRequest> getPrayerRequestsByCategory(PrayerCategory category) =>
      _prayerRequests.where((request) => request.category == category).toList();

  Future<void> loadPrayerRequests() async {
    _setLoading(true);
    try {
      _prayerRequests = await _databaseService.getAllPrayerRequests();
      _error = null;
    } catch (e) {
      _error = 'Failed to load prayer requests: $e';
      debugPrint(_error);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addPrayerRequest({
    required String title,
    required String description,
    required PrayerCategory category,
  }) async {
    try {
      final newRequest = PrayerRequest(
        id: const Uuid().v4(),
        title: title,
        description: description,
        category: category,
        status: PrayerRequestStatus.pending,
        createdAt: DateTime.now(),
      );

      await _databaseService.insertPrayerRequest(newRequest);
      _prayerRequests.insert(0, newRequest);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add prayer request: $e';
      debugPrint(_error);
      notifyListeners();
    }
  }

  Future<void> updatePrayerRequestStatus(
    String id,
    PrayerRequestStatus newStatus, {
    String? answeredStoryId,
  }) async {
    try {
      final index = _prayerRequests.indexWhere((request) => request.id == id);
      if (index == -1) return;

      final updatedRequest = _prayerRequests[index].copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
        answeredAt: newStatus == PrayerRequestStatus.answered ? DateTime.now() : null,
        answeredStoryId: answeredStoryId,
      );

      await _databaseService.updatePrayerRequest(updatedRequest);
      _prayerRequests[index] = updatedRequest;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update prayer request: $e';
      debugPrint(_error);
      notifyListeners();
    }
  }

  Future<void> updatePrayerRequest(PrayerRequest updatedRequest) async {
    try {
      final index = _prayerRequests.indexWhere((request) => request.id == updatedRequest.id);
      if (index == -1) return;

      final requestWithUpdateTime = updatedRequest.copyWith(
        updatedAt: DateTime.now(),
      );

      await _databaseService.updatePrayerRequest(requestWithUpdateTime);
      _prayerRequests[index] = requestWithUpdateTime;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update prayer request: $e';
      debugPrint(_error);
      notifyListeners();
    }
  }

  Future<void> deletePrayerRequest(String id) async {
    try {
      await _databaseService.deletePrayerRequest(id);
      _prayerRequests.removeWhere((request) => request.id == id);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete prayer request: $e';
      debugPrint(_error);
      notifyListeners();
    }
  }

  PrayerRequest? getPrayerRequestById(String id) {
    try {
      return _prayerRequests.firstWhere((request) => request.id == id);
    } catch (e) {
      return null;
    }
  }

  Map<PrayerCategory, int> getCategoryStatistics() {
    final stats = <PrayerCategory, int>{};
    for (final category in PrayerCategory.values) {
      stats[category] = _prayerRequests
          .where((request) => request.category == category)
          .length;
    }
    return stats;
  }

  Map<PrayerRequestStatus, int> getStatusStatistics() {
    final stats = <PrayerRequestStatus, int>{};
    for (final status in PrayerRequestStatus.values) {
      stats[status] = _prayerRequests
          .where((request) => request.status == status)
          .length;
    }
    return stats;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
