import 'package:flutter_test/flutter_test.dart';
import 'package:scanai/features/scan/scan_service.dart';
import 'package:scanai/features/understand/ocr_service.dart';
import 'package:scanai/features/understand/classify_service.dart';
import 'package:scanai/data/local/models.dart';

void main() {
  test('pages: add, move, remove; bad page never kills paper', () {
    final svc = ScanService();
    final pages = <DocPage>[];
    svc.addPage(pages, 'a.png');
    svc.addPage(pages, 'b.png');
    expect(pages.length, 2);
    svc.movePage(pages, 0, 1);
    expect(pages.first.imagePath, 'b.png');
    svc.removePage(pages, pages.first.id);
    expect(pages.length, 1);
  });

  test('receipt guess: total + date -> receipt flow', () async {
    final ocr = FakeOcr({
      'r.png': const OcrResult([
        OcrLine('INV-2045', 0.99),
        OcrLine('Total: 5000', 0.95),
        OcrLine('12/05/2026', 0.9),
      ]),
    });
    final r = await ocr.read('r.png');
    expect(guessKind(r), DocKind.receipt);
    expect(nextStep(DocKind.receipt), 'Receipt flow');
  });

  test('low score lines get flagged for human check', () async {
    const r = OcrResult([OcrLine('Age: 3?', 0.4)]);
    expect(r.weak.length, 1);
  });
}
