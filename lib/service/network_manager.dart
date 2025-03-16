import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkManager {
  static final NetworkManager _instance = NetworkManager._internal();
  final Connectivity _connectivity = Connectivity();
  bool _isConnected = true;
  final StreamController<bool> _connectionChangeController = StreamController.broadcast();

  // Stream for other parts of the app to listen to connectivity changes
  Stream<bool> get connectionChange => _connectionChangeController.stream;

  // Current connectivity status
  bool get isConnected => _isConnected;

  factory NetworkManager() {
    return _instance;
  }

  NetworkManager._internal() {
    // Initialize
    _checkInternetConnection();

    // Listen for connectivity changes
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatusFromList);
  }

  Future<void> initializeConnectivity() async {
    // Initial connectivity check
    bool isConnected = await checkConnectivity();

    // Add initial result to stream
    _connectionChangeController.add(isConnected);
  }

  // Check the initial connection status
  Future<void> _checkInternetConnection() async {
    try {
      var connectivityResult = await _connectivity.checkConnectivity();
      // Handle both single result and list result
      if (connectivityResult is List<ConnectivityResult>) {
        _updateConnectionStatusFromList(connectivityResult);
      } else {
        _updateConnectionStatus(connectivityResult as ConnectivityResult);
      }
    } catch (e) {
      print('Connectivity check failed: $e');
      _isConnected = false;
      _connectionChangeController.add(false);
    }
  }

  // Handle list of connectivity results (for newer versions of connectivity_plus)
  void _updateConnectionStatusFromList(List<ConnectivityResult> results) {
    // If any connectivity type is not 'none', consider it as connected
    bool isConnected = results.any((result) => result != ConnectivityResult.none);

    // Only notify listeners if there's a change
    if (_isConnected != isConnected) {
      _isConnected = isConnected;
      _connectionChangeController.add(_isConnected);
      print('Network connectivity changed: $_isConnected');
    }
  }

  // Update connection status based on connectivity result (for older versions)
  void _updateConnectionStatus(ConnectivityResult result) {
    bool isConnected = result != ConnectivityResult.none;

    // Only notify listeners if there's a change
    if (_isConnected != isConnected) {
      _isConnected = isConnected;
      _connectionChangeController.add(_isConnected);
      print('Network connectivity changed: $_isConnected');
    }
  }

  // Manually check current connectivity
  Future<bool> checkConnectivity() async {
    try {
      var connectivityResult = await _connectivity.checkConnectivity();

      // Handle both single result and list result
      if (connectivityResult is List<ConnectivityResult>) {
        bool isConnected = connectivityResult.any((result) => result != ConnectivityResult.none);
        _updateConnectionStatusFromList(connectivityResult);
        return isConnected;
      } else {
        bool isConnected = connectivityResult != ConnectivityResult.none;
        _updateConnectionStatus(connectivityResult as ConnectivityResult);
        return isConnected;
      }
    } catch (e) {
      print('Connectivity check failed: $e');
      return false;
    }
  }

  // Dispose resources
  void dispose() {
    _connectionChangeController.close();
  }
}
