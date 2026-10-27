import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../../core/storage/storage_service.dart';
import '../../domain/entities/journal_entry.dart';

class JournalViewModel extends ChangeNotifier {
  static const String _storageKey = 'navsanjivini_journal_entries';
  final StorageService? storageService;

  final List<JournalEntry> _entries = [];
  bool _isLoading = false;
  String? _selectedQuickMood;

  JournalViewModel({this.storageService}) {
    _loadEntries();
  }

  List<JournalEntry> get entries => List.unmodifiable(_entries);
  bool get isLoading => _isLoading;
  String? get selectedQuickMood => _selectedQuickMood;

  void selectQuickMood(String? mood) {
    if (_selectedQuickMood == mood) {
      _selectedQuickMood = null;
    } else {
      _selectedQuickMood = mood;
    }
    notifyListeners();
  }

  void clearQuickMood() {
    _selectedQuickMood = null;
    notifyListeners();
  }

  Future<void> _loadEntries() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (storageService != null) {
        final rawJson = await storageService!.getString(_storageKey);
        if (rawJson != null && rawJson.isNotEmpty) {
          final List<dynamic> decoded = jsonDecode(rawJson) as List<dynamic>;
          _entries.clear();
          for (final item in decoded) {
            _entries.add(JournalEntry.fromJson(item as Map<String, dynamic>));
          }
        } else {
          _seedInitialMockEntries();
          await _persistEntries();
        }
      } else {
        if (_entries.isEmpty) {
          _seedInitialMockEntries();
        }
      }
      _sortEntries();
    } catch (_) {
      if (_entries.isEmpty) {
        _seedInitialMockEntries();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _seedInitialMockEntries() {
    final now = DateTime.now();
    final earlierToday = now.subtract(const Duration(hours: 3));
    final yesterday = now.subtract(const Duration(days: 1));
    final yesterdayTime = DateTime(yesterday.year, yesterday.month, yesterday.day, 16, 45);

    _entries.addAll([
      JournalEntry(
        id: 'mock_1',
        title: 'A small step forward',
        body: 'Today was a little difficult, but I took some time for myself...',
        mood: 'calm',
        createdAt: earlierToday,
        updatedAt: earlierToday,
      ),
      JournalEntry(
        id: 'mock_2',
        title: "Things I'm grateful for",
        body: 'Three little things that made my day feel better...',
        mood: 'good',
        createdAt: yesterdayTime,
        updatedAt: yesterdayTime,
      ),
    ]);
  }

  Future<void> _persistEntries() async {
    if (storageService == null) return;
    try {
      final jsonList = _entries.map((e) => e.toJson()).toList();
      await storageService!.setString(_storageKey, jsonEncode(jsonList));
    } catch (_) {}
  }

  void _sortEntries() {
    _entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> addEntry({
    required String title,
    required String body,
    String? mood,
  }) async {
    final now = DateTime.now();
    final entry = JournalEntry(
      id: 'entry_${now.millisecondsSinceEpoch}',
      title: title.trim().isEmpty ? 'A quiet reflection' : title.trim(),
      body: body.trim(),
      mood: mood,
      createdAt: now,
      updatedAt: now,
    );

    _entries.insert(0, entry);
    _sortEntries();
    notifyListeners();
    await _persistEntries();
  }

  Future<void> updateEntry(
    String id, {
    required String title,
    required String body,
    String? mood,
  }) async {
    final index = _entries.indexWhere((e) => e.id == id);
    if (index == -1) return;

    final existing = _entries[index];
    final updated = existing.copyWith(
      title: title.trim().isEmpty ? existing.title : title.trim(),
      body: body.trim(),
      mood: mood,
      updatedAt: DateTime.now(),
    );

    _entries[index] = updated;
    notifyListeners();
    await _persistEntries();
  }

  Future<void> deleteEntry(String id) async {
    _entries.removeWhere((item) => item.id == id);
    notifyListeners();
    await _persistEntries();
  }

  JournalEntry? getEntryById(String id) {
    try {
      return _entries.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
