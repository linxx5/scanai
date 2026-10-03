// Papers saved ON the phone (SQLite later). Small plain models first.
// Swap this memory store with Drift/Isar later — same names.

class DocPage {
  final String id;
  final String imagePath;
  const DocPage({required this.id, required this.imagePath});
}

class Document {
  final String id;
  final String title;
  final String status; // ready | needs_review | failed
  final List<DocPage> pages;
  const Document({
    required this.id,
    required this.title,
    this.status = 'ready',
    this.pages = const [],
  });
}

class QueueItem {
  final String id;
  final String kind; // upload | export | ai
  int tries;
  QueueItem({required this.id, required this.kind, this.tries = 0});
}

class UsageCounter {
  int conversionsUsed;
  static const int freeLimit = 5;
  UsageCounter({this.conversionsUsed = 0});
  bool get canScanFree => conversionsUsed < freeLimit;
}
