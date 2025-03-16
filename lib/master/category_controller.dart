import 'package:flutter/material.dart';
import 'package:hai_tegal/bloc/custom_bloc.dart';
import 'package:hai_tegal/bloc/list_map_bloc.dart';
import 'package:hai_tegal/bloc/map_bloc.dart';
import 'package:hai_tegal/components/colors.dart';
import 'package:hai_tegal/components/utils.dart';
import 'package:hai_tegal/master/home_controller.dart';
import 'package:hai_tegal/service/api.dart';

MapBloc categoryIndex = MapBloc();
ListMapBloc subCategoryAll = ListMapBloc();
ListMapBloc postSearchAll = ListMapBloc();
ListMapBloc postNearestAll = ListMapBloc();
ListMapBloc postHighestAll = ListMapBloc();
ListMapBloc postFeaturedTripAll = ListMapBloc();
CustomBloc latitudeUser = CustomBloc();
CustomBloc longitudeUser = CustomBloc();
MapBloc datacat = MapBloc();

void chooseCategoryIndex(Map data) {
  categoryIndex.changeVal(data);
}

Future<void> loadSubCategory(String key, String parentId) async {
  subCategoryAll.removeAll();
  final response = await Api().getCategory(key, parentId);
  
  if (response.success) {
    subCategoryAll.addAll(response.data);
  } else {
    print('Failed to load sub-categories: ${response.message}');
  }
}

Future<void> loadPostAllCategory(BuildContext context, String key, String categoryId, String limit, String postId) async {
  ModalContainer(context, 'Loading..', CircularProgressIndicator(), []);
  postSearchAll.removeAll();
  
  final response = await Api().getPost(key, categoryId, limit, postId);
  
  // Check if context is still mounted before manipulating UI
  if (!context.mounted) return;
  
  Navigator.pop(context); // Close loading dialog
  
  if (response.success) {
    postSearchAll.addAll(response.data);
  } else {
    AlertText(context, WAWarningColor, WALightColor, 'Data tidak ditemukan');
  }
}

Future<void> loadPostAllCategoryInner(String key, String categoryId, String limit, String postId) async {
  postSearchAll.removeAll();
  final response = await Api().getPost(key, categoryId, limit, postId);
  
  if (response.success) {
    postSearchAll.addAll(response.data);
  } else {
    print('Failed to load posts: ${response.message}');
  }
}

Future<void> loadPostNearestUser(String parentCatId, {dynamic radius = 0}) async {
  postNearestAll.removeAll();
  final response = await Api().getNearest(
    latitudeUser.state, 
    longitudeUser.state, 
    parentCatId, 
    radius
  );
  
  if (response.success) {
    postNearestAll.addAll(response.data);
  } else {
    print('Failed to load nearest posts: ${response.message}');
  }
}

Future<void> loadPostHighest(String parentCatId) async {
  postHighestAll.removeAll();
  final response = await Api().getHighest(parentCatId);
  
  if (response.success) {
    postHighestAll.addAll(response.data);
  } else {
    print('Failed to load highest posts: ${response.message}');
  }
}

Future<void> loadPostFeatured() async {
  postFeaturedTripAll.removeAll();
  categoryAllLMB.findMap('category_name', 'Featured Trip', datacat);
  
  final response = await Api().getPost('', datacat.state['category_id'], '', '0');
  
  if (response.success) {
    postFeaturedTripAll.addAll(response.data);
  } else {
    print('Failed to load featured posts: ${response.message}');
  }
}