import 'package:app/core/network/api_client.dart';

/// Base contract for feature remote data sources.
abstract class BaseRemoteDataSource {
  final ApiClient apiClient;

  const BaseRemoteDataSource(this.apiClient);
}

