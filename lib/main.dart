import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';
import 'core/localization/language_controller.dart';
import 'core/storage/shared_preferences_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize storage & language controller
  final storageService = await SharedPreferencesStorageService.init();
  final languageController = LanguageController(storageService);
  await languageController.loadSavedLanguage();

  runApp(
    NavsanjiviniApp(
      languageController: languageController,
      storageService: storageService,
    ),
  );
}
