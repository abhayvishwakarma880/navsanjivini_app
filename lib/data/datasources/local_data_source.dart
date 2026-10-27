import 'package:app/core/storage/storage_service.dart';

/// Base contract for feature local data sources.
abstract class BaseLocalDataSource {
  final StorageService storageService;

  const BaseLocalDataSource(this.storageService);
}

