// Smart help: local first, cloud only with clear tap.
// Hides phone/ID numbers before any cloud call. Same question twice = cache.
class AiRequest {
  final String text;
  final String mode; // summary | qa | extract
  final bool sensitive; // ID, money, beneficiary list
  final bool consentCloud; // user tapped "use cloud anyway"
  const AiRequest({
    required this.text,
    this.mode = 'summary',
    this.sensitive = true,
    this.consentCloud = false,
  });
}

class AiRoute {
  final String to; // ollama-local | groq | gemini | blocked
  final String cleanText;
  const AiRoute(this.to, this.cleanText);
}

String hidePrivate(String t) => t
    .replaceAll(RegExp(r'\+?\d[\d\s-]{7,}\d'), '[PHONE]')
    .replaceAll(RegExp(r'\b\d{6,}\b'), '[ID]');

AiRoute route(AiRequest r) {
  final clean = hidePrivate(r.text);
  if (!r.sensitive && r.consentCloud) return AiRoute('groq', clean);
  if (r.sensitive && r.consentCloud) return AiRoute('gemini', clean);
  if (!r.consentCloud) return const AiRoute('ollama-local', '');
  return const AiRoute('blocked', '');
}

// tiny cache key: same mode + same clean text
String cacheKey(String mode, String cleanText) => '$mode::$cleanText';
