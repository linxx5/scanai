// Check list: only weak lines need you. Fix, tick ok, or drop.
class ReviewField {
  final String name;
  String value;
  double score;
  bool approved;
  ReviewField({
    required this.name,
    required this.value,
    this.score = 1.0,
    this.approved = false,
  });
  bool get needsCheck => score < 0.7 && !approved;
}

class ReviewService {
  final List<ReviewField> fields;
  ReviewService(this.fields);
  List<ReviewField> get toCheck => fields.where((f) => f.needsCheck).toList();
  void fix(String name, String v) {
    final f = fields.firstWhere((e) => e.name == name);
    f.value = v;
    f.score = 1.0;
  }

  void approve(String name) {
    fields.firstWhere((e) => e.name == name).approved = true;
  }

  void reject(String name) {
    fields.removeWhere((e) => e.name == name);
  }

  bool get allDone => toCheck.isEmpty;
}
