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

chooseCategoryIndex(Map data){
  categoryIndex.changeVal(data);
}

loadSubCategory(key, parentId)async{
  subCategoryAll.removeAll();
  var data = await Api().getCategory(key, parentId);
  subCategoryAll.addAll(data['data']);
}

loadPostAllCategory(context, key, categoyId, limit, postId)async{
  ModalContainer(context, 'Loading..', CircularProgressIndicator(), []);
  postSearchAll.removeAll();
  var data = await Api().getPost(key, categoyId, limit, postId);
  if(data['res'] == true){
    postSearchAll.addAll(data['data']);
    Navigator.pop(context);
  }else{
    AlertText(context, WAWarningColor, WALightColor, 'Data tidak ditemukan');
    Navigator.pop(context);

  }
  
}

loadPostAllCategoryInner(key, categoyId, limit, postId)async{
  postSearchAll.removeAll();
  var data = await Api().getPost(key, categoyId, limit, postId);
    postSearchAll.addAll(data['data']);
} 

loadPostNearestUser(parentCatId, {radius = 0})async{
  postNearestAll.removeAll();
  var data = await Api().getNearest(latitudeUser.state, longitudeUser.state, parentCatId, radius);
    postNearestAll.addAll(data['data']);
} 

loadPostHighest(parentCatId)async{
  postHighestAll.removeAll();
  var data = await Api().getHighest(parentCatId);
    postHighestAll.addAll(data['data']);
} 

loadPostFeatured()async{
  postFeaturedTripAll.removeAll();
  categoryAllLMB.findMap('category_name', 'Featured Trip', datacat);
  var data = await Api().getPost('', datacat.state['category_id'], '', '0');
    postFeaturedTripAll.addAll(data['data']);
 
} 

