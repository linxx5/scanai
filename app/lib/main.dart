import 'package:flutter/material.dart';
import 'package:scanai/theme/theme.dart';
import 'package:scanai/core/connectivity/connectivity_service.dart';
import 'package:scanai/core/connectivity/offline_banner.dart';
import 'package:scanai/data/local/local_store.dart';
import 'package:scanai/data/local/models.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final store = LocalStore();
  final net = ConnectivityService();
  LinkStatus link = LinkStatus.online;

  @override
  void initState() {
    super.initState();
    net.now().then((v) => setState(() => link = v));
    net.watch().listen((v) => setState(() => link = v));
  }

  void _demoScan() {
    final n = store.documents.length + 1;
    store.addDocument(
      Document(id: 'doc-$n', title: 'Scan $n', pages: const []),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanai')),
      body: Column(
        children: [
          OfflineBanner(status: link, pending: store.queue.length),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: ListTile(
                    title: const Text('Scan'),
                    subtitle: Text(
                      store.usage.canScanFree
                          ? 'Free left: ${UsageCounter.freeLimit - store.usage.conversionsUsed}'
                          : 'Free used up. Make an account.',
                    ),
                    trailing: const Icon(Icons.camera_alt),
                    onTap: _demoScan,
                  ),
                ),
                const Card(
                  child: ListTile(
                    title: Text('Import'),
                    subtitle: Text('Gallery or PDF'),
                  ),
                ),
                const Card(
                  child: ListTile(
                    title: Text('Forms'),
                    subtitle: Text('Create or fill'),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text('My Documents'),
                    subtitle: Text(
                      store.documents.isEmpty
                          ? 'On this device: none yet'
                          : 'On this device: ${store.documents.length}',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
