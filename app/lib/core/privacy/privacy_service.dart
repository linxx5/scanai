// My data: see all, delete all. Simple + local first.
import '../data/local/local_store.dart';

class PrivacyService {
  final LocalStore store;
  const PrivacyService(this.store);

  String exportJson() {
    final docs = store.documents
        .map((d) => '{"id":"${d.id}","title":"${d.title}"}')
        .join(',');
    return '{"guest":"${store.guestId}","used":${store.usage.conversionsUsed},"docs":[$docs]}';
  }

  void deleteAll() {
    store.documents.clear();
    store.queue.clear();
    store.usage.conversionsUsed = 0;
  }
}
