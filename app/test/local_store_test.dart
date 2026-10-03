import 'package:flutter_test/flutter_test.dart';
import 'package:scanai/data/local/local_store.dart';
import 'package:scanai/data/local/models.dart';

void main() {
  test('airplane mode: scan 1 paper saves it + counts 1 free', () {
    final store = LocalStore();
    store.addDocument(const Document(id: 'doc-1', title: 'Scan 1'));
    expect(store.documents.length, 1);
    expect(store.usage.conversionsUsed, 1);
  });

  test('free limit: 5th scan ok, 6th blocked', () {
    final store = LocalStore();
    for (var i = 0; i < 6; i++) {
      if (store.usage.canScanFree) {
        store.addDocument(Document(id: 'doc-$i', title: 'Scan $i'));
      }
    }
    expect(store.documents.length, 5);
    expect(store.usage.canScanFree, isFalse);
  });
}
