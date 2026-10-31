import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/localization/language_controller.dart';
import 'package:app/core/localization/language_scope.dart';
import 'package:app/core/storage/in_memory_storage_service.dart';
import 'package:app/core/theme/app_theme.dart';
import 'package:app/user/features/journal/presentation/viewmodels/journal_viewmodel.dart';
import 'package:app/user/features/journal/presentation/views/journal_list_screen.dart';

void main() {
  late InMemoryStorageService storage;
  late LanguageController languageController;
  late JournalViewModel viewModel;

  setUp(() {
    storage = InMemoryStorageService();
    languageController = LanguageController(storage);
    viewModel = JournalViewModel(storageService: storage);
  });

  Widget buildTestableWidget() {
    return LanguageScope(
      controller: languageController,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: JournalListScreen(viewModel: viewModel),
      ),
    );
  }

  testWidgets('JournalListScreen renders all blueprint UI elements matching reference image',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    // 1. Header
    expect(find.text('My Journal 🌿'), findsOneWidget);
    expect(find.text('A little space for your thoughts.'), findsOneWidget);
    expect(find.byIcon(Icons.menu_book_rounded), findsWidgets);

    // 2. Featured Mint Card
    expect(find.text('How are you feeling today?'), findsOneWidget);
    expect(find.text('Take a moment to check in with yourself.'), findsOneWidget);
    expect(find.text('Good'), findsOneWidget);
    expect(find.text('Calm'), findsOneWidget);
    expect(find.text('Low'), findsOneWidget);
    expect(find.text('Anxious'), findsOneWidget);
    expect(find.text('+ Write a new entry'), findsOneWidget);

    // 3. Reflections Section
    expect(find.text('Your reflections'), findsOneWidget);
    expect(find.text('View all'), findsOneWidget);

    // 4. Default Seeded Reflections
    expect(find.text('A small step forward'), findsOneWidget);
    expect(find.text("Things I'm grateful for"), findsOneWidget);
    expect(find.text('Private entry'), findsNWidgets(2));
  });

  testWidgets('Tapping mood on featured card selects it', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    // Tap Calm
    await tester.tap(find.text('Calm'));
    await tester.pumpAndSettle();
    expect(viewModel.selectedQuickMood, 'calm');

    // Tap Calm again to deselect
    await tester.tap(find.text('Calm'));
    await tester.pumpAndSettle();
    expect(viewModel.selectedQuickMood, isNull);
  });

  testWidgets('Tapping Write a new entry opens JournalEntryScreen and saves reflection',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    // Tap + Write a new entry
    await tester.tap(find.text('+ Write a new entry'));
    await tester.pumpAndSettle();

    // Verify Write Entry screen elements
    expect(find.text('New journal entry'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
    expect(find.text('Give your entry a title'), findsOneWidget);
    expect(find.text("What's on your mind?"), findsOneWidget);
    expect(find.text('How are you feeling? (Optional)'), findsOneWidget);
    expect(find.text('Save entry'), findsOneWidget);
    expect(find.text('Your reflections deserve privacy.'), findsOneWidget);

    // Enter title & thoughts
    await tester.enterText(
      find.widgetWithText(TextField, '').first,
      'Peaceful Evening',
    );
    await tester.enterText(
      find.widgetWithText(TextField, '').last,
      'Had a calm walk in nature and drank hot green tea.',
    );

    // Tap Save entry button
    await tester.tap(find.text('Save entry'));
    await tester.pumpAndSettle();

    // Verify back on main screen and new entry is present
    expect(find.text('Peaceful Evening'), findsOneWidget);
    expect(
      find.text('Had a calm walk in nature and drank hot green tea.'),
      findsOneWidget,
    );
  });

  testWidgets('Tapping reflection card opens details and allows reading',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    // Tap first card
    await tester.tap(find.text('A small step forward'));
    await tester.pumpAndSettle();

    // Verify Detail screen
    expect(find.text('A small step forward'), findsOneWidget);
    expect(
      find.text('Today was a little difficult, but I took some time for myself...'),
      findsOneWidget,
    );
    expect(find.text('Private & Local'), findsOneWidget);
    expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);

    // Go back
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();
  });

  testWidgets('More options menu allows deleting entry after confirmation',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    final initialCount = viewModel.entries.length;

    // Tap options button on first card
    await tester.tap(find.byIcon(Icons.more_horiz_rounded).first);
    await tester.pumpAndSettle();

    // Verify options sheet
    expect(find.text('Read reflection'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);

    // Tap Delete
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    // Verify confirmation dialog
    expect(find.text('Delete entry?'), findsOneWidget);
    expect(
      find.text('Are you sure you want to delete this reflection? This cannot be undone.'),
      findsOneWidget,
    );

    // Confirm Delete
    await tester.tap(find.widgetWithText(ElevatedButton, 'Delete'));
    await tester.pumpAndSettle();

    // Verify entry removed
    expect(viewModel.entries.length, initialCount - 1);
  });

  test('JournalViewModel manages CRUD and persists accurately', () async {
    final localVm = JournalViewModel(storageService: storage);
    await Future.delayed(Duration.zero);

    expect(localVm.entries.isNotEmpty, isTrue);
    final countBefore = localVm.entries.length;

    // Add entry
    await localVm.addEntry(
      title: 'Morning Yoga',
      body: 'Did 15 minutes of surya namaskar.',
      mood: 'calm',
    );

    expect(localVm.entries.length, countBefore + 1);
    expect(localVm.entries.first.title, 'Morning Yoga');

    // Update entry
    final addedId = localVm.entries.first.id;
    await localVm.updateEntry(
      addedId,
      title: 'Morning Yoga & Meditation',
      body: 'Updated body text.',
      mood: 'good',
    );

    final updated = localVm.getEntryById(addedId);
    expect(updated?.title, 'Morning Yoga & Meditation');
    expect(updated?.mood, 'good');

    // Delete entry
    await localVm.deleteEntry(addedId);
    expect(localVm.getEntryById(addedId), isNull);
    expect(localVm.entries.length, countBefore);
  });
}
