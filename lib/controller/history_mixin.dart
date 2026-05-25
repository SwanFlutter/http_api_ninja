import 'package:get_x_master/get_x_master.dart';
import 'package:get_x_storage/get_x_storage.dart';

import '../models/history_model.dart';

mixin HistoryMixin {
  final storage = GetXStorage();

  // History
  final RxList<HistoryModel> history = <HistoryModel>[].obs;
  final RxString historySearchQuery = ''.obs;
  final RxString historyFilterMethod = 'All'.obs;

  // These will be provided by the main controller or other mixins
  RxString get httpMethod;
  RxString get url;
  RxMap<String, String> get headers;
  RxMap<String, String> get queryParams;
  RxString get bodyType;
  void setBodyForType(String newBody);
  void syncHeadersListFromMap();

  void loadHistory() {
    final savedHistory = storage.readList<Map<String, dynamic>>(key: 'history');
    if (savedHistory != null && savedHistory.isNotEmpty) {
      history.value = savedHistory
          .map((h) => HistoryModel.fromJson(h))
          .toList();
    }
  }

  void saveHistory() {
    storage.writeList(
      key: 'history',
      value: history.map((h) => h.toJson()).toList(),
    );
  }

  void addToHistory(HistoryModel item) {
    // Add to beginning of list
    history.insert(0, item);

    // Keep only last 100 items
    if (history.length > 100) {
      history.removeRange(100, history.length);
    }

    saveHistory();
  }

  void deleteHistoryItem(String id) {
    history.removeWhere((h) => h.id == id);
    saveHistory();
  }

  void clearHistory() {
    history.clear();
    saveHistory();
  }

  void clearHistoryByMethod(String method) {
    history.removeWhere((h) => h.method == method);
    saveHistory();
  }

  void clearHistoryOlderThan(Duration duration) {
    final cutoff = DateTime.now().subtract(duration);
    history.removeWhere((h) => h.timestamp.isBefore(cutoff));
    saveHistory();
  }

  /// Get filtered history based on search and method filter
  List<HistoryModel> get filteredHistory {
    var result = history.toList();

    // Filter by method
    if (historyFilterMethod.value != 'All') {
      result = result
          .where((h) => h.method == historyFilterMethod.value)
          .toList();
    }

    // Filter by search query
    if (historySearchQuery.value.isNotEmpty) {
      final query = historySearchQuery.value.toLowerCase();
      result = result
          .where(
            (h) =>
                h.url.toLowerCase().contains(query) ||
                (h.requestName?.toLowerCase().contains(query) ?? false),
          )
          .toList();
    }

    return result;
  }

  /// Load history item into request builder
  void loadFromHistory(HistoryModel item) {
    httpMethod.value = item.method;
    url.value = item.url;
    headers.value = RxMap<String, String>(item.headers);
    queryParams.value = RxMap<String, String>(item.queryParams);
    if (item.body != null && item.body!.isNotEmpty) {
      bodyType.value = 'JSON';
      setBodyForType(item.body!);
    }

    syncHeadersListFromMap();
  }
}
