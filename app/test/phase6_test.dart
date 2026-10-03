import 'package:flutter_test/flutter_test.dart';
import 'package:scanai/features/batch/batch_service.dart';
import 'package:scanai/features/review/review_service.dart';

void main() {
  test('batch: counts right, check shows weak only, retry 1', () {
    final b = BatchService();
    for (var i = 0; i < 46; i++) {
      b.add(BatchItem(id: 'r$i', status: 'ready'));
    }
    for (var i = 0; i < 3; i++) {
      b.add(BatchItem(
        id: 'n$i',
        status: 'needs_review',
        fields: [ReviewField(name: 'Age', value: '3?', score: 0.4)],
      ));
    }
    b.add(BatchItem(id: 'f0', status: 'failed'));

    final s = b.summary();
    expect(s.total, 50);
    expect(s.ready, 46);
    expect(b.onlyToCheck.length, 3);

    b.retry('f0');
    expect(b.summary().needsReview, 4);
    expect(b.summary().ready, 46); // rest untouched
  });
}
