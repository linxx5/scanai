// Simple form: questions, answers, checks. Paper or phone.
enum QType {
  shortText,
  longText,
  number,
  choice, // one of many
  tick, // many of many
  drop, // dropdown
  date,
  photo,
  sign,
  gps,
  yesNo,
}

class Question {
  final String id;
  final String label;
  final QType type;
  final bool must;
  final List<String> options;
  const Question({
    required this.id,
    required this.label,
    this.type = QType.shortText,
    this.must = false,
    this.options = const [],
  });
}

class FormDef {
  final String id;
  final String title;
  final List<Question> questions;
  const FormDef({required this.id, required this.title, this.questions = const []});
}

class Answer {
  final String questionId;
  String value;
  Answer({required this.questionId, this.value = ''});
}

class Response {
  final String id;
  final List<Answer> answers;
  Response({required this.id, this.answers = const []});
  String get(String qid) =>
      answers.where((a) => a.questionId == qid).map((a) => a.value).join('|');
}
