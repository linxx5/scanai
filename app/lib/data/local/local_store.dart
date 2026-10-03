import 'models.dart';

// Guest store: one random guest per install, no login.
// Keeps: papers, send-later queue, free count (5).
class LocalStore {
  String guestId = 'guest-local';
  final List<Document> documents = [];
  final List<QueueItem> queue = [];
  final UsageCounter usage = UsageCounter();

  void addDocument(Document d) {
    documents.insert(0, d);
    if (usage.canScanFree) usage.conversionsUsed++;
  }

  void enqueue(QueueItem q) => queue.add(q);
  void removeQueued(String id) => queue.removeWhere((e) => e.id == id);
}
