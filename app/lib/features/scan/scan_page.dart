import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/local/models.dart';
import 'scan_service.dart';

// Scan opens the camera. Import opens gallery / files.
// No camera on this device? Falls back to a demo page, never crashes.
class ScanPage extends StatefulWidget {
  const ScanPage({super.key});
  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final svc = ScanService();
  final picker = ImagePicker();
  final pages = <DocPage>[];
  int _fake = 0;
  String note = '';

  Future<void> _scan() async {
    try {
      final f = await picker.pickImage(source: ImageSource.camera);
      if (f == null) {
        setState(() => note = 'Cancelled.');
        return;
      }
      setState(() {
        svc.addPage(pages, f.path);
        note = '';
      });
    } catch (_) {
      setState(() {
        _fake++;
        svc.addPage(pages, 'demo-$_fake.png');
        note = 'No camera here. Demo page added.';
      });
    }
  }

  Future<void> _import() async {
    try {
      final files = await picker.pickMultiImage();
      if (files.isEmpty) {
        setState(() => note = 'Nothing picked.');
        return;
      }
      setState(() {
        for (final f in files) {
          svc.addPage(pages, f.path);
        }
        note = '';
      });
    } catch (_) {
      setState(() {
        _fake++;
        svc.addPage(pages, 'demo-$_fake.png');
        note = 'Gallery blocked. Demo page added.';
      });
    }
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
                  onPressed: _scan,
                  child: const Text('Scan'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: _import,
                  child: const Text('Import'),
                ),
                const SizedBox(width: 8),
                Text('${pages.length} pages'),
              ],
            ),
          ),
          if (note.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(note),
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
