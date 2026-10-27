/// Contract to check device network connectivity.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

