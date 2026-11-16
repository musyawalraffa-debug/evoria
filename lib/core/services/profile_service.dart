import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static const String _keyUserName = 'evoria_user_name';
  static const String _keyPartnerName = 'evoria_partner_name';
  static const String _keyAnniversaryDate = 'evoria_anniversary_date';
  static const String _keyGeminiApiKey = 'evoria_gemini_api_key';

  final SharedPreferences _prefs;

  ProfileService(this._prefs);

  static Future<ProfileService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return ProfileService(prefs);
  }

  String getUserName() => _prefs.getString(_keyUserName) ?? 'Raffa';
  Future<void> setUserName(String name) => _prefs.setString(_keyUserName, name);

  String getPartnerName() => _prefs.getString(_keyPartnerName) ?? 'Jiwa';
  Future<void> setPartnerName(String name) => _prefs.setString(_keyPartnerName, name);

  DateTime getAnniversaryDate() {
    final str = _prefs.getString(_keyAnniversaryDate);
    if (str != null) {
      try {
        return DateTime.parse(str);
      } catch (_) {}
    }
    // Default to roughly 1.2 years ago
    return DateTime.now().subtract(const Duration(days: 430));
  }

  Future<void> setAnniversaryDate(DateTime date) =>
      _prefs.setString(_keyAnniversaryDate, date.toIso8601String());

  int getDaysTogether() {
    final start = getAnniversaryDate();
    final now = DateTime.now();
    return now.difference(start).inDays.abs();
  }

  String? getGeminiApiKey() => _prefs.getString(_keyGeminiApiKey);
  Future<void> setGeminiApiKey(String key) =>
      _prefs.setString(_keyGeminiApiKey, key);
}
