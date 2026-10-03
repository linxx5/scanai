// Folders, tags, find fast, smart names. All on phone.
class DocEntry {
  final String id;
  String title;
  String folder;
  List<String> tags;
  String text; // found text for search
  DocEntry({
    required this.id,
    required this.title,
    this.folder = 'Inbox',
    this.tags = const [],
    this.text = '',
  });
}

String smartName(String kind, DateTime d) {
  final y = d.year.toString();
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '${kind}_$y-$m-$day';
}

class OrganizeService {
  final List<DocEntry> docs = [];
  void add(DocEntry d) => docs.insert(0, d);
  List<DocEntry> search(String q) {
    final s = q.toLowerCase();
    if (s.isEmpty) return docs;
    return docs
        .where((d) =>
            d.title.toLowerCase().contains(s) ||
            d.text.toLowerCase().contains(s) ||
            d.tags.any((t) => t.toLowerCase().contains(s)))
        .toList();
  }
}
