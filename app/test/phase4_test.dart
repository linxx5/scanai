import 'package:flutter_test/flutter_test.dart';
import 'package:scanai/features/review/review_service.dart';
import 'package:scanai/features/editor/editor_service.dart';
import 'package:scanai/features/export/export_service.dart';
import 'package:scanai/features/organize/organize_service.dart';

void main() {
  test('check list: fix weak, tick ok, list empties', () {
    final svc = ReviewService([
      ReviewField(name: 'Name', value: 'Ibrahim Musa', score: 0.99),
      ReviewField(name: 'Age', value: '3?', score: 0.4),
    ]);
    expect(svc.toCheck.length, 1);
    svc.fix('Age', '38');
    expect(svc.allDone, isTrue);
  });

  test('fix then save: edit line -> txt keeps it', () {
    final doc = TextDoc(['Hello', 'Age: 3?']);
    doc.setLine(1, 'Age: 38');
    expect(ExportService().toTxt(doc), 'Hello\nAge: 38');
  });

  test('table to Excel-ready csv: commas kept safe', () {
    final t = TableDoc([
      ['Item', 'Price'],
      ['Rice, 5kg', '5000'],
    ]);
    expect(
      ExportService().toCsv(t),
      'Item,Price\n"Rice, 5kg",5000',
    );
  });

  test('find: search name finds paper', () {
    final org = OrganizeService();
    org.add(DocEntry(id: '1', title: 'Form A', text: 'Ibrahim Musa Lafia'));
    expect(org.search('ibrahim').length, 1);
    expect(org.search('kano').isEmpty, isTrue);
  });
}
