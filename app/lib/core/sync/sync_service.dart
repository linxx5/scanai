import '../data/local/models.dart';

// Send queue oldest first to Docker API on office WiFi.
// One fail never blocks rest. Free count takes max(phone, server).
typedef PushFn = Future<bool> Function(QueueItem q);

class SyncService {
  final List<QueueItem> queue;
  int sent = 0;
  int failed = 0;
  SyncService(this.queue);

  Future<void> syncAll(PushFn push) async {
    for (final q in List<QueueItem>.of(queue)) {
      try {
        final ok = await push(q);
        if (ok) {
          queue.remove(q);
          sent++;
        } else {
          q.tries++;
          failed++;
        }
      } catch (_) {
        q.tries++;
        failed++;
      }
    }
  }

  // max merge: never double-count free scans.
  static int mergeCount(int phone, int server) =>
      phone > server ? phone : server;
}
