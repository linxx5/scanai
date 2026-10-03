import 'package:flutter/material.dart';
import 'connectivity_service.dart';

// Yellow bar when offline. Green flash when back online.
class OfflineBanner extends StatelessWidget {
  final LinkStatus status;
  final int pending;
  const OfflineBanner({super.key, required this.status, this.pending = 0});

  @override
  Widget build(BuildContext context) {
    if (status == LinkStatus.online && pending == 0) {
      return const SizedBox.shrink();
    }
    final text = status == LinkStatus.offline
        ? 'Offline. Work is safe on this phone.'
            '${pending > 0 ? ' $pending to send later.' : ''}'
        : 'Back online. Sending $pending…';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: status == LinkStatus.offline
          ? const Color(0xFFFFF8E1)
          : const Color(0xFFE8F5E9),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
