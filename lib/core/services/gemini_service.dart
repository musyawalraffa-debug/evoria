import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service integrasi Google AI Studio (Gemini 1.5 Flash)
/// Digunakan untuk pencarian foto cerdas (Tab Jelajah) dan refleksi harian (Tab Refleksi).
/// Gratis tanpa kartu kredit melalui Google AI Studio (aistudio.google.com).
class GeminiService {
  final String apiKey;
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  GeminiService({required this.apiKey});

  /// Mencari indeks kenangan yang paling relevan dengan deskripsi bahasa alami pengguna
  /// Contoh query: "foto kita waktu sunset di pantai"
  Future<List<int>> searchMemoriesSemantic({
    required String query,
    required List<String> memoryStories,
  }) async {
    if (apiKey.isEmpty || memoryStories.isEmpty) return [];

    final systemInstruction = '''
Anda adalah mesin pencari semantik cerdas untuk aplikasi kenangan pasangan bernama EVORIA.
Diberikan query pencarian bahasa alami dan daftar deskripsi foto kenangan.
Tugas Anda adalah mengurutkan indeks kenangan (0-indexed) yang paling cocok dengan query.
Keluarkan output HANYA dalam format JSON array berisi angka indeks, contoh: [2, 0, 1].
Jika tidak ada yang relevan, keluarkan [].
''';

    final promptText = '''
Query Pencarian: "$query"

Daftar Kenangan:
${memoryStories.asMap().entries.map((e) => '[${e.key}] ${e.value}').join('\n')}
''';

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': '$systemInstruction\n\n$promptText'}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.2,
            'responseMimeType': 'application/json',
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rawText = data['candidates'][0]['content']['parts'][0]['text'];
        final List<dynamic> indices = jsonDecode(rawText);
        return indices.map((e) => (e as num).toInt()).toList();
      }
    } catch (_) {
      // Graceful fallback jika offline atau limit tercapai
    }
    return [];
  }

  /// Menghasilkan pertanyaan refleksi harian yang puitis dan intim untuk pasangan
  Future<String> generateDailyReflectionQuestion() async {
    if (apiKey.isEmpty) {
      return 'Hal kecil apa dari pasanganmu hari ini yang diam-diam membuatmu bersyukur?';
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text':
                      'Buatkan SATU kalimat pertanyaan refleksi harian yang romantis, hangat, dan lembut untuk pasangan kekasih dalam Bahasa Indonesia yang puitis. Jangan berikan tanda kutip ganda berlebih.'
                }
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 60,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rawText = data['candidates'][0]['content']['parts'][0]['text'];
        return rawText.trim();
      }
    } catch (_) {}

    return 'Hal kecil apa dari pasanganmu hari ini yang diam-diam membuatmu bersyukur?';
  }
}
