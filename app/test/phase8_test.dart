import 'package:flutter_test/flutter_test.dart';
import 'package:scanai/features/ai/ai_service.dart';

void main() {
  test('private papers stay local unless clear tap', () {
    const r = AiRequest(text: 'Ibrahim 08012345678', sensitive: true);
    expect(route(r).to, 'ollama-local');
  });

  test('numbers hidden before cloud', () {
    const r = AiRequest(
      text: 'Call 08012345678 id 123456',
      sensitive: false,
      consentCloud: true,
    );
    final out = route(r);
    expect(out.to, 'groq');
    expect(out.cleanText.contains('08012345678'), isFalse);
    expect(out.cleanText.contains('[PHONE]'), isTrue);
  });

  test('same ask twice: same key = free cache', () {
    expect(cacheKey('summary', 'abc'), cacheKey('summary', 'abc'));
  });
}
