import 'editor_service.dart';
import '../review/review_service.dart';

// Save on phone now. TXT + CSV work offline today.
// PDF/Excel come next with free Dart packs — same call shape.
class ExportService {
  String toTxt(TextDoc d) => d.lines.join('\n');

  String toCsv(TableDoc t) => t.rows
      .map((r) => r.map(_cell).join(','))
      .join('\n');

  String _cell(String v) {
    if (v.contains(',') || v.contains('"') || v.contains('\n')) {
      return '"${v.replaceAll('"', '""')}"';
    }
    return v;
  }

  String fieldsToCsv(List<ReviewField> fields) => fields
      .map((f) => '${_cell(f.name)},${_cell(f.value)}')
      .join('\n');
}
