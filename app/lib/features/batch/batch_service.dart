import '../review/review_service.dart';

// Many papers at once. Scan once, check only weak.
// 1 fail never stops the batch.
class BatchItem {
  final String id;
  String status; // ready | needs_review | failed
  List<ReviewField> fields;
  BatchItem({required this.id, this.status = 'ready', this.fields = const []});
}

class BatchSummary {
  final int ready;
  final int needsReview;
  final int failed;
  const BatchSummary(this.ready, this.needsReview, this.failed);
  int get total => ready + needsReview + failed;
}

class BatchService {
  final List<BatchItem> items = [];

  void add(BatchItem i) => items.add(i);

  BatchSummary summary() {
    var r = 0, n = 0, f = 0;
    for (final i in items) {
      if (i.status == 'ready') {
        r++;
      } else if (i.status == 'needs_review') {
        n++;
      } else {
        f++;
      }
    }
    return BatchSummary(r, n, f);
  }

  List<BatchItem> get onlyToCheck =>
      items.where((i) => i.status == 'needs_review').toList();

  void retry(String id) {
    final i = items.firstWhere((e) => e.id == id);
    i.status = 'needs_review';
  }
}
