import 'form_models.dart';

// Check answers. Flag bad ones. Never fix silent.
class FormIssue {
  final String questionId;
  final String msg;
  const FormIssue(this.questionId, this.msg);
}

class FormService {
  List<FormIssue> check(FormDef form, Response r) {
    final out = <FormIssue>[];
    for (final q in form.questions) {
      final v = r.get(q.id).trim();
      if (q.must && v.isEmpty) {
        out.add(FormIssue(q.id, 'Missing. Please fill.'));
        continue;
      }
      if (v.isEmpty) continue;
      if (q.type == QType.number && double.tryParse(v) == null) {
        out.add(FormIssue(q.id, 'Not a number.'));
      }
      if (q.label.toLowerCase().contains('phone') &&
          !RegExp(r'^\+?\d[\d\s-]{6,}$').hasMatch(v)) {
        out.add(FormIssue(q.id, 'Bad phone.'));
      }
      if (q.label.toLowerCase().contains('age')) {
        final age = int.tryParse(v) ?? -1;
        if (age < 0 || age > 120) out.add(FormIssue(q.id, 'Age 0-120 only.'));
      }
    }
    // double names? flag
    return out;
  }

  String toCsv(FormDef form, List<Response> rows) {
    final head = form.questions.map((q) => _cell(q.label)).join(',');
    final body = rows.map((r) => form.questions
        .map((q) => _cell(r.get(q.id)))
        .join(','));
    return ([head, ...body]).join('\n');
  }

  String _cell(String v) {
    if (v.contains(',') || v.contains('"') || v.contains('\n')) {
      return '"${v.replaceAll('"', '""')}"';
    }
    return v;
  }
}
