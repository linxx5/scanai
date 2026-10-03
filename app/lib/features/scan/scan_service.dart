// Scan pages on the phone. No internet needed.
// Add, remove, move pages. One bad page never kills the paper.
import '../data/local/models.dart';

class ScanService {
  int _n = 0;

  DocPage addPage(List<DocPage> pages, String imagePath) {
    _n++;
    final p = DocPage(id: 'p$_n', imagePath: imagePath);
    pages.add(p);
    return p;
  }

  void removePage(List<DocPage> pages, String id) {
    pages.removeWhere((p) => p.id == id);
  }

  void movePage(List<DocPage> pages, int from, int to) {
    if (from < 0 || from >= pages.length) return;
    if (to < 0 || to >= pages.length) return;
    final p = pages.removeAt(from);
    pages.insert(to, p);
  }
}
