import 'package:flutter/material.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_spacing.dart';
import '../viewmodels/journal_viewmodel.dart';
import '../widgets/journal_card.dart';
import 'journal_entry_screen.dart';

class JournalListScreen extends StatefulWidget {
  const JournalListScreen({super.key});

  @override
  State<JournalListScreen> createState() => _JournalListScreenState();
}

class _JournalListScreenState extends State<JournalListScreen> {
  final JournalViewModel _viewModel = JournalViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Private Journal'),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => JournalEntryScreen(
                    onSave: (title, body) {
                      _viewModel.addEntry(title, body);
                    },
                  ),
                ),
              );
            },
            child: const Icon(Icons.add_rounded),
          ),
          body: SafeArea(
            child: _viewModel.entries.isEmpty
                ? const Center(
                    child: Text('Your journal is private. Tap + to write your thoughts.'),
                  )
                : ListView.separated(
                    padding: AppSpacing.screenPadding,
                    itemCount: _viewModel.entries.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final entry = _viewModel.entries[index];
                      return JournalCard(
                        entry: entry,
                        onTap: () {},
                        onDelete: () => _viewModel.deleteEntry(entry.id),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
