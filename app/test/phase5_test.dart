import 'package:flutter_test/flutter_test.dart';
import 'package:scanai/features/auth/auth_gate.dart';
import 'package:scanai/core/sync/sync_service.dart';
import 'package:scanai/data/local/models.dart';

void main() {
  test('free work: no login wall for scan', () {
    const gate = AuthGate(loggedIn: false);
    // scan itself is free -> no gate entry; gated ones need login
    expect(gate.needsAccount(GatedFeature.sync), isTrue);
    expect(
      const AuthGate(loggedIn: true).needsAccount(GatedFeature.sync),
      isFalse,
    );
  });

  test('sync: 1 fail does not block rest; count merges by max', () async {
    final q = [
      QueueItem(id: 'a', kind: 'upload'),
      QueueItem(id: 'b', kind: 'upload'),
      QueueItem(id: 'c', kind: 'upload'),
    ];
    final svc = SyncService(q);
    await svc.syncAll((item) async => item.id != 'b');
    expect(svc.sent, 2);
    expect(svc.failed, 1);
    expect(q.length, 1);
    expect(SyncService.mergeCount(3, 5), 5);
    expect(SyncService.mergeCount(7, 5), 7);
  });
}
