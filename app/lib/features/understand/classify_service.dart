import 'ocr_service.dart';

// Simple guess first (free, instant). Smarter later.
// receipt -> has total/amount + date. table -> many numbers in rows.
// form -> has name/phone/LGA words. else notes.
enum DocKind { receipt, table, form, notes }

DocKind guessKind(OcrResult r) {
  final t = r.fullText.toLowerCase();
  final hasTotal = t.contains('total') || t.contains('amount') || t.contains('₦');
  final hasDate = RegExp(r'\d{1,2}[/-]\d{1,2}[/-]\d{2,4}').hasMatch(t);
  final numCount = RegExp(r'\d+').allMatches(t).length;
  final hasFormWords =
      t.contains('name') || t.contains('phone') || t.contains('lga');
  if (hasTotal && hasDate) return DocKind.receipt;
  if (numCount >= 8) return DocKind.table;
  if (hasFormWords) return DocKind.form;
  return DocKind.notes;
}

String nextStep(DocKind k) {
  switch (k) {
    case DocKind.receipt:
      return 'Receipt flow';
    case DocKind.table:
      return 'Excel flow';
    case DocKind.form:
      return 'Form flow';
    case DocKind.notes:
      return 'Notes flow';
  }
}
