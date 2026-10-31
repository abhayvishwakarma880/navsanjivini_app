import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';
import 'core/localization/language_controller.dart';
import 'core/storage/in_memory_storage_service.dart';
import 'core/storage/shared_preferences_storage_service.dart';
import 'core/storage/storage_service.dart';

void main() async {
  // Ensure Flutter engine bindings are initialized before any native calls
  WidgetsFlutterBinding.ensureInitialized();

  // Global Flutter framework error handling to prevent silent black screen crashes
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Navsanjivini FlutterError: ${details.exceptionAsString()}');
  };

  // Asynchronous error handler
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Navsanjivini AsyncError: $error\n$stack');
    return true; // handled
  };

  // Set system UI overlay style safely
  try {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  } catch (e) {
    debugPrint('SystemUiOverlayStyle error: $e');
  }

  // Resilient Storage & Language initialization:
  // We provide an InMemory fallback with timeouts so that if SharedPreferences
  // or native JNI platform channel delays or throws in release mode,
  // runApp() is ALWAYS guaranteed to execute immediately without a black screen.
  StorageService storageService = InMemoryStorageService();
  LanguageController languageController = LanguageController(storageService);

  try {
    final prefsService = await SharedPreferencesStorageService.init()
        .timeout(const Duration(milliseconds: 1500));
    storageService = prefsService;
    languageController = LanguageController(storageService);
    await languageController
        .loadSavedLanguage()
        .timeout(const Duration(milliseconds: 800));
  } catch (e, stackTrace) {
    debugPrint('Storage init fallback to InMemory: $e\n$stackTrace');
  }

  runApp(
    NavsanjiviniApp(
      languageController: languageController,
      storageService: storageService,
    ),
  );
}
