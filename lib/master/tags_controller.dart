import 'package:hai_tegal/bloc/map_bloc.dart';

import '../bloc/list_map_bloc.dart';
import '../service/api.dart';

ListMapBloc allTagsPost = ListMapBloc();
ListMapBloc postTagGet = ListMapBloc();
MapBloc tagIndex = MapBloc();

void loadTagPost(key)async{
 allTagsPost.removeAll();
  var data = await Api().getTagAll(key);
  allTagsPost.addAll(data['data']);
}

void loadPostTagGet(key, postId, tagsId)async{
 postTagGet.removeAll();
  var data = await Api().getTag(key, postId, tagsId);
  postTagGet.addAll(data['data']);
}
