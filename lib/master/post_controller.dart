import 'package:hai_tegal/bloc/list_map_bloc.dart';
import 'package:hai_tegal/bloc/map_bloc.dart';
import 'package:hai_tegal/service/api.dart';

MapBloc postIndexMB = MapBloc();
ListMapBloc imgPostAllLMB = ListMapBloc();
ListMapBloc reviewPostAllLMB = ListMapBloc();
MapBloc averageReviewCB = MapBloc();
MapBloc reviewSummaryPostAllLMB = MapBloc();
ListMapBloc venuePostAllLMB = ListMapBloc();
ListMapBloc otherPostAllLMB = ListMapBloc();
ListMapBloc nearestPostAllLMB = ListMapBloc();
ListMapBloc allPostChoose = ListMapBloc();

void choosePostIndex(Map data) {
  postIndexMB.changeVal(data);
}

Future<void> loadImgPostIndex(String postId) async {
  imgPostAllLMB.removeAll();
  final response = await Api().getImgPost('', postId, '20', '');
  
  if (response.success) {
    imgPostAllLMB.addAll(response.data);
  } else {
    print('Failed to load post images: ${response.message}');
  }
}

Future<void> loadReviewPostIndex(String postId) async {
  reviewPostAllLMB.removeAll();
  final response = await Api().getComment(postId);
  
  if (response.success) {
    // Check if the data structure contains nested 'data' and 'rating' fields
    if (response.data != null && 
        response.data['data'] != null && 
        response.data['rating'] != null &&
        response.data['average'] != null) {
      
      reviewPostAllLMB.addAll(response.data['data']);
      reviewSummaryPostAllLMB.changeVal(response.data['rating']);
      averageReviewCB.changeVal(response.data['average']);
    } else {
      print('Review data structure is not as expected');
    }
  } else {
    print('Failed to load reviews: ${response.message}');
  }
}

Future<void> loadVenuePostIndex(String postId) async {
  venuePostAllLMB.removeAll();
  final response = await Api().getVenuePost('', postId);
  
  if (response.success) {
    venuePostAllLMB.addAll(response.data);
  } else {
    print('Failed to load venue post: ${response.message}');
  }
}

Future<void> loadNearestPostIndex(dynamic lat, dynamic long, String cat, {dynamic radius = 0}) async {
  nearestPostAllLMB.removeAll();
  final response = await Api().getNearest(lat, long, cat, radius);
  
  if (response.success) {
    nearestPostAllLMB.addAll(response.data);
  } else {
    print('Failed to load nearest posts: ${response.message}');
  }
}

Future<void> loadDetPost(String key, String categoryId, String limit, String postId) async {
  allPostChoose.removeAll();
  final response = await Api().getPost(key, categoryId, limit, postId);
  
  if (response.success) {
    allPostChoose.addAll(response.data);
  } else {
    print('Failed to load post details: ${response.message}');
  }
}