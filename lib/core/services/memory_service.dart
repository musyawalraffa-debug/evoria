import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/memory_item.dart';

class MemoryService {
  static const String _storageKey = 'evoria_sanctuary_memories_v1';
  final SharedPreferences _prefs;

  MemoryService(this._prefs);

  static Future<MemoryService> init() async {
    final prefs = await SharedPreferences.getInstance();
    final service = MemoryService(prefs);
    await service._ensureInitialData();
    return service;
  }

  Future<void> _ensureInitialData() async {
    final existing = _prefs.getString(_storageKey);
    if (existing == null || existing.isEmpty) {
      // Seed with initial poetic sanctuary memories
      final initialMemories = [
        MemoryItem(
          id: const Uuid().v4(),
          title: 'Senja Pertama di Pantai Parangtritis',
          date: DateTime.now().subtract(const Duration(days: 42)),
          location: 'Bantul, Yogyakarta',
          note:
              'Kala langit memerah jingga dan deburan ombak menyentuh jemari kita, kau berbisik bahwa waktu terasa berhenti saat kita berjalan berdampingan tanpa kata.',
          mood: 'Romantis',
          imagePath: null, // Displays poetic gradient placeholder if null
          isFavorite: true,
          partnerReaction: 'love',
          partnerReactionNote: 'Momen terindah yang tak pernah pudar.',
          createdAt: DateTime.now().subtract(const Duration(days: 42)),
        ),
        MemoryItem(
          id: const Uuid().v4(),
          title: 'Secangkir Kopi Kala Hujan Rintik',
          date: DateTime.now().subtract(const Duration(days: 15)),
          location: 'Dago Atas, Bandung',
          note:
              'Hujan turun menderu di luar jendela kafe kecil itu. Aroma kopi panas dan tawa lirihmu menjadi pelindung terbaik dari dinginnya dunia luar.',
          mood: 'Hangat',
          imagePath: null,
          isFavorite: false,
          partnerReaction: 'warmth',
          partnerReactionNote: 'Ingin mengulang sore itu lagi.',
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
        ),
        MemoryItem(
          id: const Uuid().v4(),
          title: 'Langkah Sunyi Menyusuri Pinus',
          date: DateTime.now().subtract(const Duration(days: 4)),
          location: 'Hutan Pinus Mangunan',
          note:
              'Kabut pagi tipis yang memeluk pepohonan tinggi. Genggaman tanganmu begitu hangat menuntun setiap langkah di jalan setapak tanah basah.',
          mood: 'Tenang',
          imagePath: null,
          isFavorite: true,
          partnerReaction: null,
          partnerReactionNote: null,
          createdAt: DateTime.now().subtract(const Duration(days: 4)),
        ),
      ];

      await saveMemories(initialMemories);
    }
  }

  List<MemoryItem> getMemories() {
    final raw = _prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = json.decode(raw);
      final items = list.map((e) => MemoryItem.fromMap(e as Map<String, dynamic>)).toList();
      items.sort((a, b) => b.date.compareTo(a.date)); // Newest first
      return items;
    } catch (_) {
      return [];
    }
  }

  Future<void> saveMemories(List<MemoryItem> memories) async {
    final list = memories.map((e) => e.toMap()).toList();
    await _prefs.setString(_storageKey, json.encode(list));
  }

  Future<MemoryItem> addMemory({
    required String title,
    required DateTime date,
    required String location,
    required String note,
    required String mood,
    String? imagePath,
  }) async {
    final newMemory = MemoryItem(
      id: const Uuid().v4(),
      title: title,
      date: date,
      location: location,
      note: note,
      mood: mood,
      imagePath: imagePath,
      createdAt: DateTime.now(),
    );

    final current = getMemories();
    current.insert(0, newMemory);
    await saveMemories(current);
    return newMemory;
  }

  Future<void> updateMemory(MemoryItem updated) async {
    final current = getMemories();
    final index = current.indexWhere((m) => m.id == updated.id);
    if (index != -1) {
      current[index] = updated;
      await saveMemories(current);
    }
  }

  Future<void> deleteMemory(String id) async {
    final current = getMemories();
    current.removeWhere((m) => m.id == id);
    await saveMemories(current);
  }

  Future<void> toggleFavorite(String id) async {
    final current = getMemories();
    final index = current.indexWhere((m) => m.id == id);
    if (index != -1) {
      current[index] =
          current[index].copyWith(isFavorite: !current[index].isFavorite);
      await saveMemories(current);
    }
  }

  Future<void> addReaction(String id, String reaction, String note) async {
    final current = getMemories();
    final index = current.indexWhere((m) => m.id == id);
    if (index != -1) {
      current[index] = current[index].copyWith(
        partnerReaction: reaction,
        partnerReactionNote: note,
      );
      await saveMemories(current);
    }
  }
}
