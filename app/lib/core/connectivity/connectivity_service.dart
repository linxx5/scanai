// Phone-side status: are we online? Simple words, no jargon.
import 'package:connectivity_plus/connectivity_plus.dart';

enum LinkStatus { online, offline }

class ConnectivityService {
  final Connectivity _c = Connectivity();
  Stream<LinkStatus> watch() async* {
    await for (final r in _c.onConnectivityChanged) {
      yield r.contains(ConnectivityResult.none)
          ? LinkStatus.offline
          : LinkStatus.online;
    }
  }

  Future<LinkStatus> now() async {
    final r = await _c.checkConnectivity();
    return r.contains(ConnectivityResult.none)
        ? LinkStatus.offline
        : LinkStatus.online;
  }
}
