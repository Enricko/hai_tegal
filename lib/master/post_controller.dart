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

choosePostIndex(Map data){
  postIndexMB.changeVal(data);
}

// loadImgPostIndex(postId)async{
//   imgPostAllLMB.removeAll();
//   var data = await Api().getImgPost('', postId, '20', '');
//   imgPostAllLMB.addAll(data['data']);
// }

loadReviewPostIndex(postId)async{
  reviewPostAllLMB.removeAll();
  var data = await Api().getComment(postId);
  reviewPostAllLMB.addAll(data['data']['data']);
  reviewSummaryPostAllLMB.changeVal(data['data']['rating']);
  averageReviewCB.changeVal(data['data']['average']);
}

// loadVenuePostIndex(postId)async{
//   venuePostAllLMB.removeAll();
//   var data = await Api().getVenuePost('', postId);
//   venuePostAllLMB.addAll(data['data']);
// }

loadNearestPostIndex(lat, long, cat, {radius = 0})async{
  nearestPostAllLMB.removeAll();
    var data = await Api().getNearest(lat, long, cat, radius);
    nearestPostAllLMB.addAll(data['data']);
    print(nearestPostAllLMB.state.listDataMap);
 
}

void loadDetPost(key, categoryId, limit, postId)async{
  allPostChoose.removeAll();
  var data = await Api().getPost(key, categoryId, limit, postId);
  allPostChoose.addAll(data['data']);
}