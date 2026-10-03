// Read text on the phone (ML Kit). Same shape for tests.
// Real ML Kit plugs in via MlKitOcr. FakeOcr is for fast tests.

class OcrLine {
  final String text;
  final double score; // 0..1. Low = needs human check.
  const OcrLine(this.text, [this.score = 1.0]);
}

class OcrResult {
  final List<OcrLine> lines;
  final String lang; // auto found, e.g. 'en'
  const OcrResult(this.lines, [this.lang = 'en']);
  String get fullText => lines.map((e) => e.text).join('\n');
  List<OcrLine> get weak => lines.where((e) => e.score < 0.7).toList();
}

abstract class Ocr {
  Future<OcrResult> read(String imagePath, {String? lang});
}

// Test double: no camera needed.
class FakeOcr implements Ocr {
  final Map<String, OcrResult> canned;
  FakeOcr(this.canned);
  @override
  Future<OcrResult> read(String imagePath, {String? lang}) async {
    return canned[imagePath] ?? const OcrResult([], 'en');
  }
}

// Real one (wires google_mlkit_text_recognition). Kept thin on purpose.
class MlKitOcr implements Ocr {
  final String? forcedLang;
  MlKitOcr({this.forcedLang});
  @override
  Future<OcrResult> read(String imagePath, {String? lang}) async {
    // TODO: call TextRecognizer + Latin script, map blocks -> OcrLine.
    // Fallback: return empty so UI flags "needs review", never crashes.
    return OcrResult(const [], lang ?? forcedLang ?? 'en');
  }
}
