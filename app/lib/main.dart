import 'package:flutter/material.dart';
import 'theme/theme.dart';

void main() => runApp(const ScanaiApp());

class ScanaiApp extends StatelessWidget {
  const ScanaiApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scanai',
      theme: buildScanaiTheme(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanai')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _HomeTile('Scan', 'Single scan, no login'),
          _HomeTile('Import', 'Gallery or PDF'),
          _HomeTile('Forms', 'Create or fill'),
          _HomeTile('My Documents', 'On this device'),
        ],
      ),
    );
  }
}

class _HomeTile extends StatelessWidget {
  final String title;
  final String sub;
  const _HomeTile(this.title, this.sub);
  @override
  Widget build(BuildContext context) {
    return Card(child: ListTile(title: Text(title), subtitle: Text(sub)));
  }
}
