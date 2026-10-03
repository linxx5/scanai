import 'package:flutter/material.dart';
import 'review_service.dart';

// Shows weak fields first. Tap to fix. Tick to keep. X to drop.
class ReviewPage extends StatefulWidget {
  final ReviewService svc;
  const ReviewPage({super.key, required this.svc});
  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    final items = [
      ...widget.svc.toCheck,
      ...widget.svc.fields.where((f) => !f.needsCheck),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Check')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (c, i) {
          final f = items[i];
          final chip = f.needsCheck ? '⚠ check' : '✓ ok';
          return ListTile(
            title: Text('${f.name}: ${f.value}'),
            subtitle: Text(chip),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final ctl = TextEditingController(text: f.value);
                    final v = await showDialog<String>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Fix ${f.name}'),
                        content: TextField(controller: ctl),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, ctl.text),
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    );
                    if (v != null) {
                      setState(() => widget.svc.fix(f.name, v));
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () =>
                      setState(() => widget.svc.approve(f.name)),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () =>
                      setState(() => widget.svc.reject(f.name)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
