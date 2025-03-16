import 'package:hai_tegal/bloc/list_map_bloc.dart';
import 'package:hai_tegal/bloc/map_bloc.dart';
import 'package:hai_tegal/service/api.dart';

ListMapBloc allTagsPost = ListMapBloc();
ListMapBloc postTagGet = ListMapBloc();
MapBloc tagIndex = MapBloc();

Future<void> loadTagPost(String key) async {
  allTagsPost.removeAll();
  final response = await Api().getTagAll(key);

  if (response.success) {
    allTagsPost.addAll(response.data);
  } else {
    print('Failed to load tags: ${response.message}');
  }
}

Future<void> loadPostTagGet(String key, String postId, String tagsId) async {
  postTagGet.removeAll();
  final response = await Api().getTag(key, postId, tagsId);

  if (response.success) {
    postTagGet.addAll(response.data);
  } else {
    print('Failed to load posts by tag: ${response.message}');
  }
}

void selectTagIndex(Map tagData) {
  tagIndex.changeVal(tagData);
}
