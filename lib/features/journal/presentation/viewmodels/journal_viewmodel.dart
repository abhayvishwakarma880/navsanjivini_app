import 'package:flutter/foundation.dart';
import '../../domain/entities/journal_entry.dart';

class JournalViewModel extends ChangeNotifier {
  final List<JournalEntry> _entries = [];
  bool _isLoading = false;

  List<JournalEntry> get entries => List.unmodifiable(_entries);
  bool get isLoading => _isLoading;

  void addEntry(String title, String body) {
    final entry = JournalEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim().isEmpty ? 'Untitled Entry' : title.trim(),
      body: body.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _entries.insert(0, entry);
    notifyListeners();
  }

  void deleteEntry(String id) {
    _entries.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
