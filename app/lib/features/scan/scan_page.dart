import 'package:flutter/material.dart';
import '../../data/local/models.dart';
import 'scan_service.dart';

// Simple page list: Scan, Import, reorder with arrows, delete.
// Camera + ML Kit scanner plug in here later — same buttons.
class ScanPage extends StatefulWidget {
  const ScanPage({super.key});
  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final svc = ScanService();
  final pages = <DocPage>[];
  int _fake = 0;

  void _addDemo() {
    _fake++;
    setState(() => svc.addPage(pages, 'demo-$f.png'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan pages')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: _addDemo,
                  child: const Text('Scan'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: _addDemo,
                  child: const Text('Import'),
                ),
                const SizedBox(width: 8),
                Text('${pages.length} pages'),
              ],
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              itemCount: pages.length,
              onReorder: (a, b) {
                setState(() {
                  if (b > a) b--;
                  svc.movePage(pages, a, b);
                });
              },
              itemBuilder: (c, i) => ListTile(
                key: ValueKey(pages[i].id),
                leading: const Icon(Icons.description),
                title: Text('Page ${i + 1}'),
                subtitle: Text(pages[i].imagePath),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () =>
                      setState(() => svc.removePage(pages, pages[i].id)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
