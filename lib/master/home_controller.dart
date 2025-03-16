import 'package:flutter/material.dart';
import 'package:hai_tegal/bloc/list_map_bloc.dart';
import 'package:hai_tegal/components/colors.dart';
import 'package:hai_tegal/components/utils.dart';
import 'package:hai_tegal/service/api.dart';

List<ListMapBloc> homeListContent = [
  wisataPostAllLMB,
  jelajahPostAllLMB,
  kulinerPostAllLMB,
  eventPostAllLMB,
  penginapanPostAllLMB
];

ListMapBloc bannerAllLMB = ListMapBloc();
ListMapBloc categoryAllLMB = ListMapBloc();
ListMapBloc postAllLMB = ListMapBloc();
ListMapBloc imgPostAllLMB = ListMapBloc();
ListMapBloc eventPostAllLMB = ListMapBloc();
ListMapBloc wisataPostAllLMB = ListMapBloc();
ListMapBloc jelajahPostAllLMB = ListMapBloc();
ListMapBloc kulinerPostAllLMB = ListMapBloc();
ListMapBloc penginapanPostAllLMB = ListMapBloc();
ListMapBloc homeSearchPostAll = ListMapBloc();
ListMapBloc homeContentAll = ListMapBloc();
ListMapBloc boardingAll = ListMapBloc();

// Tracking variables to prevent multiple loads
bool _isInitialized = false;
bool _isLoadingBanner = false;
bool _isLoadingHome = false;
bool _isLoadingBoarding = false;
bool _isLoadingCategory = false;
bool _isLoadingPost = false;
bool _isLoadingEvent = false;

// Initialize the API cache
Future<void> initializeCache() async {
  if (!_isInitialized) {
    await Api().initCache();
    _isInitialized = true;
  }
}

Future<void> loadBoarding({bool forceRefresh = false}) async {
  if (_isLoadingBoarding) return;

  _isLoadingBoarding = true;
  try {
    final response = await Api().getBoardingAll();

    if (response.success) {
      boardingAll.removeAll();
      boardingAll.addAll(response.data);
    } else {
      print('Failed to load boarding: ${response.message}');
    }
  } catch (e) {
    print('Error loading boarding: $e');
  } finally {
    _isLoadingBoarding = false;
  }
}

Future<void> loadHome({bool forceRefresh = false}) async {
  if (_isLoadingHome) return;

  _isLoadingHome = true;
  try {
    final response = await Api().getHomeAll();

    if (response.success) {
      homeContentAll.removeAll();
      homeContentAll.addAll(response.data);
    } else {
      print('Failed to load home: ${response.message}');
    }
  } catch (e) {
    print('Error loading home: $e');
  } finally {
    _isLoadingHome = false;
  }
}

Future<void> loadBanner({bool forceRefresh = false}) async {
  if (_isLoadingBanner) return;

  _isLoadingBanner = true;
  try {
    final response = await Api().getBannerAll();

    if (response.success) {
      bannerAllLMB.removeAll();
      bannerAllLMB.addAll(response.data);
    } else {
      print('Failed to load banners: ${response.message}');
    }
  } catch (e) {
    print('Error loading banners: $e');
  } finally {
    _isLoadingBanner = false;
  }
}

Future<void> loadCategory(String key, String parentCat, {bool forceRefresh = false}) async {
  if (_isLoadingCategory) return;

  _isLoadingCategory = true;
  try {
    final response = await Api().getCategory(key, parentCat);

    if (response.success) {
      categoryAllLMB.removeAll();
      categoryAllLMB.addAll(response.data);
    } else {
      print('Failed to load categories: ${response.message}');
    }
  } catch (e) {
    print('Error loading categories: $e');
  } finally {
    _isLoadingCategory = false;
  }
}

Future<void> loadPost(String key, String categoryId, String limit, String postId,
    {bool forceRefresh = false}) async {
  if (_isLoadingPost) return;

  _isLoadingPost = true;
  try {
    final response = await Api().getPost(key, categoryId, limit, postId);

    if (response.success) {
      postAllLMB.removeAll();
      postAllLMB.addAll(response.data);
    } else {
      print('Failed to load posts: ${response.message}');
    }
  } catch (e) {
    print('Error loading posts: $e');
  } finally {
    _isLoadingPost = false;
  }
}

Future<void> loadCategoryHome(ListMapBloc listMapBloc, String limit, String categoryId,
    {bool forceRefresh = false}) async {
  try {
    final response = await Api().getPost('', categoryId, limit, '0');

    if (response.success) {
      listMapBloc.removeAll();
      listMapBloc.addAll(response.data);
    } else {
      print('Failed to load category home: ${response.message}');
    }
  } catch (e) {
    print('Error loading category home: $e');
  }
}

Future<void> loadEvent({bool forceRefresh = false}) async {
  if (_isLoadingEvent) return;

  _isLoadingEvent = true;
  try {
    final response = await Api().getPost('', '38', '', '0');

    if (response.success) {
      eventPostAllLMB.removeAll();
      eventPostAllLMB.addAll(response.data);
    } else {
      print('Failed to load events: ${response.message}');
    }
  } catch (e) {
    print('Error loading events: $e');
  } finally {
    _isLoadingEvent = false;
  }
}

Future<void> loadHomeSearchPostAll(
    BuildContext context, String key, String categoryId, String limit, String postId,
    {bool forceRefresh = true}) async {
  ModalContainer(context, 'Loading..', CircularProgressIndicator(), []);
  homeSearchPostAll.removeAll();

  try {
    final response = await Api().getPost(key, categoryId, limit, postId);

    // Check if context is still mounted before manipulating UI
    if (!context.mounted) return;

    Navigator.pop(context); // Close loading dialog

    if (response.success) {
      homeSearchPostAll.addAll(response.data);
    } else {
      AlertText(context, WAWarningColor, WALightColor, 'Data tidak ditemukan');
    }
  } catch (e) {
    // Check if context is still mounted before manipulating UI
    if (!context.mounted) return;

    Navigator.pop(context); // Close loading dialog
    AlertText(context, WADangerColor, WALightColor, 'Error: $e');
  }
}

void loadLatLongUser(dynamic lat, dynamic long) {
  latitudeUserCB.changeVal(lat);
  longitudeUserCB.changeVal(long);
}

// Load everything in one go, with optional forced refresh
Future<void> loadAllHomeData({bool forceRefresh = false}) async {
  await initializeCache();

  // Load data in parallel
  await Future.wait([
    loadBanner(forceRefresh: forceRefresh),
    loadHome(forceRefresh: forceRefresh),
    loadCategory('', '0', forceRefresh: forceRefresh),
    loadPost('', '', '10', '0', forceRefresh: forceRefresh),
    loadEvent(forceRefresh: forceRefresh),
  ]);

  // Load category home data if home content is available
  if (homeContentAll.state.listDataMap.isNotEmpty) {
    for (int i = 0;
        i < homeContentAll.state.listDataMap.length && i < homeListContent.length;
        i++) {
      await loadCategoryHome(
          homeListContent[i],
          homeContentAll.state.listDataMap[i]['limit_data'].toString(),
          homeContentAll.state.listDataMap[i]['category_id'].toString(),
          forceRefresh: forceRefresh);
    }
  }
}

// Clear caches of specific categories
Future<void> clearHomeCache() async {
  await Api().clearCache(category: 'banner');
  await Api().clearCache(category: 'home');
  await Api().clearCache(category: 'category');
  await Api().clearCache(category: 'post');
}
