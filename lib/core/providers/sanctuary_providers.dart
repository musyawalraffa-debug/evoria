import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/memory_item.dart';
import '../services/memory_service.dart';
import '../services/profile_service.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Must override in main()');
});

final memoryServiceProvider = Provider<MemoryService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return MemoryService(prefs);
});

final profileServiceProvider = Provider<ProfileService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ProfileService(prefs);
});

class MemoriesNotifier extends StateNotifier<List<MemoryItem>> {
  final MemoryService _service;

  MemoriesNotifier(this._service) : super([]) {
    refresh();
  }

  void refresh() {
    state = _service.getMemories();
  }

  Future<void> addMemory({
    required String title,
    required DateTime date,
    required String location,
    required String note,
    required String mood,
    String? imagePath,
  }) async {
    await _service.addMemory(
      title: title,
      date: date,
      location: location,
      note: note,
      mood: mood,
      imagePath: imagePath,
    );
    refresh();
  }

  Future<void> deleteMemory(String id) async {
    await _service.deleteMemory(id);
    refresh();
  }

  Future<void> toggleFavorite(String id) async {
    await _service.toggleFavorite(id);
    refresh();
  }

  Future<void> addReaction(String id, String reaction, String note) async {
    await _service.addReaction(id, reaction, note);
    refresh();
  }
}

final memoriesProvider =
    StateNotifierProvider<MemoriesNotifier, List<MemoryItem>>((ref) {
  final service = ref.watch(memoryServiceProvider);
  return MemoriesNotifier(service);
});

class ProfileState {
  final String userName;
  final String partnerName;
  final DateTime anniversaryDate;
  final int daysTogether;
  final String? geminiApiKey;

  ProfileState({
    required this.userName,
    required this.partnerName,
    required this.anniversaryDate,
    required this.daysTogether,
    this.geminiApiKey,
  });

  ProfileState copyWith({
    String? userName,
    String? partnerName,
    DateTime? anniversaryDate,
    int? daysTogether,
    String? geminiApiKey,
  }) {
    return ProfileState(
      userName: userName ?? this.userName,
      partnerName: partnerName ?? this.partnerName,
      anniversaryDate: anniversaryDate ?? this.anniversaryDate,
      daysTogether: daysTogether ?? this.daysTogether,
      geminiApiKey: geminiApiKey ?? this.geminiApiKey,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileService _service;

  ProfileNotifier(this._service)
      : super(
          ProfileState(
            userName: _service.getUserName(),
            partnerName: _service.getPartnerName(),
            anniversaryDate: _service.getAnniversaryDate(),
            daysTogether: _service.getDaysTogether(),
            geminiApiKey: _service.getGeminiApiKey(),
          ),
        );

  Future<void> updateNames(String user, String partner) async {
    await _service.setUserName(user);
    await _service.setPartnerName(partner);
    state = state.copyWith(userName: user, partnerName: partner);
  }

  Future<void> updateAnniversary(DateTime date) async {
    await _service.setAnniversaryDate(date);
    state = state.copyWith(
      anniversaryDate: date,
      daysTogether: _service.getDaysTogether(),
    );
  }

  Future<void> updateGeminiKey(String key) async {
    await _service.setGeminiApiKey(key);
    state = state.copyWith(geminiApiKey: key);
  }
}

final profileProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final service = ref.watch(profileServiceProvider);
  return ProfileNotifier(service);
});
