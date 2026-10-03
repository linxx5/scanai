import 'package:flutter_test/flutter_test.dart';
import 'package:scanai/features/forms/form_models.dart';
import 'package:scanai/features/forms/form_service.dart';

FormDef demo() => const FormDef(id: 'f1', title: 'Beneficiary', questions: [
      Question(id: 'name', label: 'Name', must: true),
      Question(id: 'phone', label: 'Phone', must: true),
      Question(id: 'age', label: 'Age', type: QType.number),
    ]);

void main() {
  test('5 questions -> 15 answers -> 15 csv rows', () {
    final form = demo();
    final svc = FormService();
    final rows = List.generate(
      15,
      (i) => Response(id: 'r$i', answers: [
        Answer(questionId: 'name', value: 'Person $i'),
        Answer(questionId: 'phone', value: '+2348000000$i'),
        Answer(questionId: 'age', value: '30'),
      ]),
    );
    for (final r in rows) {
      expect(svc.check(form, r), isEmpty);
    }
    final csv = svc.toCsv(form, rows);
    expect(csv.split('\n').length, 16); // head + 15
  });

  test('bad phone + bad age flagged, never fixed silent', () {
    final svc = FormService();
    final r = Response(id: 'x', answers: [
      Answer(questionId: 'name', value: 'A'),
      Answer(questionId: 'phone', value: 'abc'),
      Answer(questionId: 'age', value: '300'),
    ]);
    final issues = svc.check(demo(), r);
    expect(issues.length, 2);
    expect(r.get('phone'), 'abc'); // kept as typed
  });
}
