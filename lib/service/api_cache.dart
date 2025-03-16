import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiCacheService {
  static final ApiCacheService _instance = ApiCacheService._internal();
  SharedPreferences? _prefs; // Make nullable
  bool _initializing = false;

  // In-memory cache for faster access
  final Map<String, dynamic> _memoryCache = {};

  // Cache expiration times in milliseconds
  final Map<String, int> _cacheExpirationTimes = {
    'banner': 60 * 60 * 1000, // 1 hour
    'category': 60 * 60 * 1000, // 1 hour
    'post': 30 * 60 * 1000, // 30 minutes
    'tags': 60 * 60 * 1000, // 1 hour
    'home': 15 * 60 * 1000, // 15 minutes
    'postTags': 30 * 60 * 1000, // 30 minutes
    'comment': 15 * 60 * 1000, // 15 minutes
    'saved': 15 * 60 * 1000, // 15 minutes
    'nearest': 10 * 60 * 1000, // 10 minutes
    'default': 30 * 60 * 1000, // 30 minutes default
  };

  factory ApiCacheService() {
    return _instance;
  }

  ApiCacheService._internal();

  // Initialize SharedPreferences
  Future<void> init() async {
    if (_prefs != null || _initializing) return;

    _initializing = true;
    _prefs = await SharedPreferences.getInstance();
    _initializing = false;
  }

  // Ensure SharedPreferences is initialized
  Future<SharedPreferences> _ensureInitialized() async {
    if (_prefs == null) {
      await init();
    }
    return _prefs!;
  }

  Future<void> saveToCache(String key, dynamic data, {String? category}) async {
    // Save to memory cache first (for faster access)
    _memoryCache[key] = data;

    try {
      // Make sure SharedPreferences is initialized
      final prefs = await _ensureInitialized();

      // Then save to shared preferences with timestamp
      final cacheData = {
        'data': data,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'category': category ?? 'default'
      };

      await prefs.setString(key, jsonEncode(cacheData));
    } catch (e) {
      print('Error saving to cache: $e');
      // Still keep in memory cache even if SharedPreferences fails
    }
  }

  Future<dynamic> getFromCache(String key, {bool forceRefresh = false}) async {
    if (forceRefresh) {
      return null;
    }

    // Check memory cache first
    if (_memoryCache.containsKey(key)) {
      return _memoryCache[key];
    }

    try {
      // Make sure SharedPreferences is initialized
      final prefs = await _ensureInitialized();

      // If not in memory, check shared preferences
      final cachedData = prefs.getString(key);
      if (cachedData != null) {
        final decodedData = jsonDecode(cachedData);
        final timestamp = decodedData['timestamp'] as int;
        final category = decodedData['category'] as String;
        final data = decodedData['data'];

        // Check if cache is still valid
        final now = DateTime.now().millisecondsSinceEpoch;
        final expirationTime = _cacheExpirationTimes[category] ?? _cacheExpirationTimes['default']!;

        if (now - timestamp < expirationTime) {
          // Cache is still valid, store in memory for faster access next time
          _memoryCache[key] = data;
          return data;
        }
      }
    } catch (e) {
      print('Error getting from cache: $e');
      // Return null on error
    }

    return null;
  }

  Future<void> clearCache({String? category}) async {
    try {
      // Make sure SharedPreferences is initialized
      final prefs = await _ensureInitialized();

      if (category != null) {
        // Clear only specific category
        final allKeys = prefs.getKeys();
        for (final key in allKeys) {
          final cachedData = prefs.getString(key);
          if (cachedData != null) {
            try {
              final decodedData = jsonDecode(cachedData);
              if (decodedData['category'] == category) {
                await prefs.remove(key);
                _memoryCache.remove(key);
              }
            } catch (e) {
              // Skip entries that can't be decoded
              print('Error decoding cached item: $e');
            }
          }
        }
      } else {
        // Clear all cache
        await prefs.clear();
        _memoryCache.clear();
      }
    } catch (e) {
      print('Error clearing cache: $e');
      // Still clear memory cache even if SharedPreferences fails
      if (category == null) {
        _memoryCache.clear();
      }
    }
  }

  Future<void> removeFromCache(String key) async {
    _memoryCache.remove(key);

    try {
      // Make sure SharedPreferences is initialized
      final prefs = await _ensureInitialized();
      await prefs.remove(key);
    } catch (e) {
      print('Error removing from cache: $e');
      // Already removed from memory cache
    }
  }
}
