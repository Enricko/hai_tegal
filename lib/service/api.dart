import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:hai_tegal/bloc/custom_bloc.dart';
import 'package:hai_tegal/master/account_contrroller.dart';
import 'package:hai_tegal/service/api_cache.dart';
import 'package:hai_tegal/service/local_storage.dart';
import 'package:hai_tegal/service/network_manager.dart';
import 'package:hai_tegal/service/url.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// Custom API response class for consistent returns
class ApiResponse {
  final bool success;
  final dynamic data;
  final String message;
  final bool fromCache; // Indicates if data is from cache

  ApiResponse({
    required this.success,
    this.data,
    this.message = '',
    this.fromCache = false,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, {bool fromCache = false}) {
    return ApiResponse(
      success: json['res'] ?? false,
      data: json['data'],
      message: json['message'] ?? '',
      fromCache: fromCache,
    );
  }

  factory ApiResponse.error(String errorMessage) {
    return ApiResponse(
      success: false,
      message: errorMessage,
    );
  }

  factory ApiResponse.offline(dynamic cachedData) {
    return ApiResponse(
      success: true,
      data: cachedData,
      message: 'Showing cached data (offline)',
      fromCache: true,
    );
  }
}

CustomBloc latitudeUserCB = CustomBloc();
CustomBloc longitudeUserCB = CustomBloc();
GetStorage user = LocalStorage().user;
CustomBloc networkStatusCB = CustomBloc(); // Track network status

class Api {
  static final Api _instance = Api._internal();

  factory Api() {
    return _instance;
  }

  Api._internal();

  final String url = Url().getUrl();
  final Map<String, String> headers = {
    'authorization': Url().basicAuth,
  };
  final ApiCacheService _cacheService = ApiCacheService();
  final NetworkManager _networkManager = NetworkManager();

  // Initialize both the cache and network manager

  // Initialize cache service
  Future<void> initCache() async {
    try {
      await _cacheService.init();
      print('Cache initialized successfully');
    } catch (e) {
      print('Error initializing cache: $e');
      // Continue without cache if there's an error
    }
  }

  // Check if device is online
  Future<bool> isOnline() async {
    return await _networkManager.checkConnectivity();
  }

  // Show a dialog to reconnect when offline
  void showReconnectDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('You are currently offline. Some features may not be available. '
              'Please check your connection and try again.'),
          actions: [
            TextButton(
              onPressed: () async {
                // Check connectivity again
                bool isConnected = await isOnline();
                if (isConnected) {
                  Navigator.of(context).pop();
                } else {
                  // Still offline
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Still offline. Please check your connection.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Try Again'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Helper method to handle API calls with caching and offline support
  Future<ApiResponse> _handleApiCall(Future<http.Response> Function() apiCall, String cacheKey,
      {String? cacheCategory, bool forceRefresh = false}) async {
    // Try to get from cache if not forcing refresh
    if (!forceRefresh) {
      final cachedData = await _cacheService.getFromCache(cacheKey);
      if (cachedData != null) {
        // Check if we're offline
        final isConnected = await isOnline();
        if (!isConnected) {
          // We're offline, return cached data with offline indicator
          return ApiResponse.offline(cachedData);
        }

        // We're online but have cached data, use it with cache indicator
        return ApiResponse.fromJson(cachedData, fromCache: true);
      }
    }

    // Check if we're online before making the API call
    final isConnected = await isOnline();
    if (!isConnected) {
      // Try one more time to get from cache, even if we initially wanted to force refresh
      final cachedData = await _cacheService.getFromCache(cacheKey);
      if (cachedData != null) {
        return ApiResponse.offline(cachedData);
      }

      // No cached data and offline
      return ApiResponse.error('No internet connection available and no cached data found');
    }

    // If online, make the API call
    try {
      final response = await apiCall();

      // Check for HTTP errors
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Parse response
        try {
          final jsonData = json.decode(response.body);

          // Save to cache if successful
          if (jsonData['res'] == true) {
            await _cacheService.saveToCache(cacheKey, jsonData, category: cacheCategory);
          }

          return ApiResponse.fromJson(jsonData);
        } catch (e) {
          return ApiResponse.error('Failed to parse response: $e');
        }
      } else {
        return ApiResponse.error('Server error: ${response.statusCode}');
      }
    } on SocketException {
      // Network error occurred, try to get from cache as a fallback
      final cachedData = await _cacheService.getFromCache(cacheKey);
      if (cachedData != null) {
        return ApiResponse.offline(cachedData);
      }
      return ApiResponse.error('No internet connection');
    } on HttpException {
      return ApiResponse.error('HTTP error occurred');
    } on FormatException {
      return ApiResponse.error('Invalid response format');
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred: $e');
    }
  }

  // Use forceRefresh for login/register calls even when offline
  Future<ApiResponse> doRegister(String email, String username, String password, String phone,
      String img, String? userMobileDateBirth) async {
    // Registration should always try to access the server
    final isConnected = await isOnline();
    if (!isConnected) {
      return ApiResponse.error('Cannot register without internet connection');
    }

    return _handleApiCall(() {
      Map<String, String> body = {
        "user_email": email,
        "user_name": username,
        "user_pass": password,
        "user_img": img,
        "user_phone": phone,
        "user_latitude": "",
        "user_longitude": "",
        "user_address": "",
        "user_date_birth": userMobileDateBirth ?? '0000-00-00',
      };

      return http.post(Uri.parse(url + 'auth/register'), headers: headers, body: body);
    }, 'register_${email}', // Don't cache registration attempts
        forceRefresh: true // Always force refresh for registration
        );
  }

  Future<ApiResponse> doLogin(String email, String password) async {
    // Login should always try to access the server
    final isConnected = await isOnline();
    if (!isConnected) {
      return ApiResponse.error('Cannot login without internet connection');
    }

    return _handleApiCall(() {
      Map<String, String> body = {"user_email": email, "user_pass": password};

      return http.post(Uri.parse(url + 'auth/login'), headers: headers, body: body);
    }, 'login_${email}', // Don't cache login attempts
            forceRefresh: true // Always force refresh for login
            )
        .then((response) {
      // Save credentials if login successful
      if (response.success) {
        user.write('email', email);
        user.write('pass', password);
      }
      return response;
    });
  }

  Future<ApiResponse> getBannerAll() async {
    return _handleApiCall(
        () => http.get(Uri.parse(url + 'banner/all'), headers: headers), 'banner_all',
        cacheCategory: 'banner');
  }

  Future<ApiResponse> getHomeAll() async {
    return _handleApiCall(() => http.get(Uri.parse(url + 'home'), headers: headers), 'home_all',
        cacheCategory: 'home');
  }

  Future<ApiResponse> getBoardingAll() async {
    return _handleApiCall(
        () => http.get(Uri.parse(url + 'boarding'), headers: headers), 'boarding_all',
        cacheCategory: 'banner');
  }

  Future<ApiResponse> getCategory(String key, String parentCategory) async {
    return _handleApiCall(() {
      Map<String, String> body = {"key": key, "parent_category": parentCategory};

      return http.post(Uri.parse(url + 'post/category'), headers: headers, body: body);
    }, 'category_${key}_${parentCategory}', cacheCategory: 'category');
  }

  Future<ApiResponse> getPost(String key, String category, String limit, String postId) async {
    return _handleApiCall(() {
      Map<String, String> body = {
        "key": key,
        "category": category,
        "limit": limit,
        "post_id": postId
      };

      return http.post(Uri.parse(url + 'post/post'), headers: headers, body: body);
    }, 'post_${key}_${category}_${limit}_${postId}', cacheCategory: 'post');
  }

  Future<ApiResponse> getTagAll(String key) async {
    return _handleApiCall(() {
      Map<String, String> body = {"key": key};

      return http.post(Uri.parse(url + 'post/posttags'), headers: headers, body: body);
    }, 'tags_all_${key}', cacheCategory: 'tags');
  }

  Future<ApiResponse> getTag(String key, String postId, String tagsId) async {
    return _handleApiCall(() {
      Map<String, String> body = {"key": key, "post_id": postId, "tags_id": tagsId};

      return http.post(Uri.parse(url + 'post/tags'), headers: headers, body: body);
    }, 'post_tags_${key}_${postId}_${tagsId}', cacheCategory: 'postTags');
  }

  Future<ApiResponse> getNearest(dynamic lat, dynamic long, String cat, dynamic radius) async {
    return _handleApiCall(() {
      Map<String, String> body = {
        "latitude": lat.toString(),
        "longitude": long.toString(),
        "category_id": cat,
        "radius": radius.toString()
      };

      return http.post(Uri.parse(url + 'post/nearest'), headers: headers, body: body);
    }, 'nearest_${lat}_${long}_${cat}_${radius}', cacheCategory: 'nearest');
  }

  Future<ApiResponse> getHighest(String cat) async {
    return _handleApiCall(() {
      Map<String, String> body = {"category_id": cat};

      return http.post(Uri.parse(url + 'post/highest'), headers: headers, body: body);
    }, 'highest_${cat}', cacheCategory: 'post');
  }

  Future<ApiResponse> getImgPost(String key, String postId, String limit, String categoryId) async {
    return _handleApiCall(() {
      Map<String, String> body = {
        "key": key,
        "post_id": postId,
        "limit": limit,
        "category_id": categoryId
      };

      return http.post(Uri.parse(url + 'post/img'), headers: headers, body: body);
    }, 'img_post_${key}_${postId}_${limit}_${categoryId}', cacheCategory: 'post');
  }

  Future<ApiResponse> getVenuePost(String key, String postId) async {
    return _handleApiCall(() {
      Map<String, String> body = {"key": key, "post_id": postId};

      return http.post(Uri.parse(url + 'post/venue'), headers: headers, body: body);
    }, 'venue_post_${key}_${postId}', cacheCategory: 'post');
  }

  Future<ApiResponse> getEventPost(
      String key, String postId, String startDate, String endDate) async {
    return _handleApiCall(() {
      Map<String, String> body = {
        "key": key,
        "post_id": postId,
        "start_date": startDate,
        "end_date": endDate
      };

      return http.post(Uri.parse(url + 'post/event'), headers: headers, body: body);
    }, 'event_post_${key}_${postId}_${startDate}_${endDate}', cacheCategory: 'post');
  }

  Future<ApiResponse> getSaved(String key) async {
    return _handleApiCall(() {
      Map<String, String> body = {"key": key, "user_id": '${userDetailMB.state['user_id']}'};

      return http.post(Uri.parse(url + 'post/saved'), headers: headers, body: body);
    }, 'saved_${key}_${userDetailMB.state['user_id']}', cacheCategory: 'saved');
  }

  Future<ApiResponse> addSaved(String postId, String postSavedStatus, String postSavedDttm) async {
    // Clear saved cache when adding new saved item
    await _cacheService.clearCache(category: 'saved');

    return _handleApiCall(() {
      Map<String, String> body = {
        "post_id": postId,
        "post_saved_status": postSavedStatus,
        "post_saved_dttm": postSavedDttm,
        "user_id": '${userDetailMB.state['user_id']}'
      };

      return http.post(Uri.parse(url + 'post/addSaved'), headers: headers, body: body);
    }, 'add_saved_${postId}', forceRefresh: true); // Always force refresh for adding items
  }

  Future<ApiResponse> delSaved(String postSavedId) async {
    // Clear saved cache when deleting saved item
    await _cacheService.clearCache(category: 'saved');

    return _handleApiCall(() {
      Map<String, String> body = {"post_saved_id": postSavedId};

      return http.post(Uri.parse(url + 'post/delSaved'), headers: headers, body: body);
    }, 'del_saved_${postSavedId}', forceRefresh: true); // Always force refresh for deleting items
  }

  Future<ApiResponse> getComment(String postId) async {
    return _handleApiCall(() {
      Map<String, String> body = {"post_id": postId};

      return http.post(Uri.parse(url + 'comment/all/'), headers: headers, body: body);
    }, 'comment_all_${postId}', cacheCategory: 'comment');
  }

  Future<ApiResponse> addComment(String postId, String commentTxt, String commentRating,
      String commentStatus, String commentDttm) async {
    // Clear comment cache for this post when adding comment
    await _cacheService.removeFromCache('comment_all_${postId}');

    return _handleApiCall(() {
      Map<String, String> body = {
        "post_id": postId,
        "comment_txt": commentTxt,
        "comment_rating": commentRating,
        "comment_status": commentStatus,
        "comment_dttm": commentDttm,
        "user_id": '${userDetailMB.state['user_id']}'
      };

      return http.post(Uri.parse(url + 'comment/addComment/'), headers: headers, body: body);
    }, 'add_comment_${postId}', forceRefresh: true); // Always force refresh for adding comments
  }

  Future<ApiResponse> updateComment(String commentId, String postId, String commentTxt,
      String commentRating, String commentStatus, String commentDttm) async {
    // Clear comment cache for this post when updating comment
    await _cacheService.removeFromCache('comment_all_${postId}');

    return _handleApiCall(() {
      Map<String, String> body = {
        "comment_id": commentId,
        "post_id": postId,
        "comment_txt": commentTxt,
        "comment_rating": commentRating,
        "comment_status": commentStatus,
        "comment_dttm": commentDttm,
        "user_id": '${userDetailMB.state['user_id']}'
      };

      return http.post(Uri.parse(url + 'comment/updateComment/'), headers: headers, body: body);
    }, 'update_comment_${commentId}',
        forceRefresh: true); // Always force refresh for updating comments
  }

  Future<ApiResponse> delComment(String commentId) async {
    // Note: We can't clear specific post comment cache here since we don't have postId
    // So we'll clear all comment caches
    await _cacheService.clearCache(category: 'comment');

    return _handleApiCall(() {
      Map<String, String> body = {"comment_id": commentId};

      return http.post(Uri.parse(url + 'comment/delComment/'), headers: headers, body: body);
    }, 'del_comment_${commentId}',
        forceRefresh: true); // Always force refresh for deleting comments
  }

  Future<ApiResponse> changeProfile(String email, String username, String? img, String? phone,
      String? lat, String? long, String? address, String? dateBirth) async {
    return _handleApiCall(() {
      Map<String, String> body = {
        "user_email": email,
        "user_name": username,
        "user_pass": '${user.read('pass')}',
        "user_img": img ?? '',
        "user_phone": phone ?? '',
        "user_latitude": long ?? '',
        "user_longitude": lat ?? '',
        "user_address": address ?? '',
        "user_date_birth": dateBirth ?? '0000-00-00',
        "user_id": userDetailMB.state['user_id'].toString(),
      };

      return http.post(Uri.parse(url + 'auth/update'), headers: headers, body: body);
    }, 'profile_update_${userDetailMB.state['user_id']}',
        forceRefresh: true); // Always force refresh for profile updates
  }

  Future<ApiResponse> resetPass(String password) async {
    return _handleApiCall(() {
      Map<String, String> body = {
        'user_id': userDetailMB.state['user_id'],
        'password': password,
      };

      return http.post(Uri.parse(url + 'auth/changePass'), headers: headers, body: body);
    }, 'reset_pass_${userDetailMB.state['user_id']}',
        forceRefresh: true); // Always force refresh for password resets
  }

  // Method to clear specific cache types
  Future<void> clearCache({String? category}) async {
    await _cacheService.clearCache(category: category);
  }

  void logout() {
    user.remove('email');
    user.remove('pass');
    // Clear all caches when logging out
    _cacheService.clearCache();
  }
}
