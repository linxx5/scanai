import 'package:flutter_test/flutter_test.dart';
import 'package:scanai/core/privacy/privacy_service.dart';
import 'package:scanai/data/local/local_store.dart';
import 'package:scanai/data/local/models.dart';

void main() {
  test('see all + wipe all works', () {
    final store = LocalStore();
    store.addDocument(const Document(id: 'd1', title: 'Scan 1'));
    final p = PrivacyService(store);
    expect(p.exportJson().contains('Scan 1'), isTrue);
    p.deleteAll();
    expect(store.documents.isEmpty, isTrue);
    expect(store.usage.conversionsUsed, 0);
  });
}
