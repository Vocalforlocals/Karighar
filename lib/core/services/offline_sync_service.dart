class PendingSyncItem {
  final String id;
  final String actionType; // 'product_upload', 'tender_commit', 'quote_counter'
  final Map<String, dynamic> payload;
  final DateTime queuedAt;
  bool isSynced;

  PendingSyncItem({
    required this.id,
    required this.actionType,
    required this.payload,
    required this.queuedAt,
    this.isSynced = false,
  });
}

class OfflineSyncService {
  static final OfflineSyncService _instance = OfflineSyncService._internal();
  factory OfflineSyncService() => _instance;
  OfflineSyncService._internal();

  final List<PendingSyncItem> _pendingQueue = [];
  bool _isOnline = true;

  bool get isOnline => _isOnline;
  int get pendingCount => _pendingQueue.where((i) => !i.isSynced).length;
  List<PendingSyncItem> get pendingItems => List.unmodifiable(_pendingQueue);

  void setConnectivity(bool online) {
    _isOnline = online;
    if (_isOnline && pendingCount > 0) {
      syncPendingQueue();
    }
  }

  void queueItem(String actionType, Map<String, dynamic> payload) {
    _pendingQueue.add(
      PendingSyncItem(
        id: 'sync_${DateTime.now().millisecondsSinceEpoch}',
        actionType: actionType,
        payload: payload,
        queuedAt: DateTime.now(),
      ),
    );
  }

  int syncPendingQueue() {
    int syncedCount = 0;
    for (final item in _pendingQueue) {
      if (!item.isSynced) {
        item.isSynced = true;
        syncedCount++;
      }
    }
    return syncedCount;
  }
}
