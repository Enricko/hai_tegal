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

void loadBoarding()async{
  boardingAll.removeAll();
  var data = await Api().getBoardingAll();
  boardingAll.addAll(data['data']);
}

void loadHome()async{
  homeContentAll.removeAll();
  var data = await Api().getHomeAll();
  homeContentAll.addAll(data['data']);
}

void loadBanner()async{
  bannerAllLMB.removeAll();
  var data = await Api().getBannerAll();
  bannerAllLMB.addAll(data['data']);
}

void loadCategory(key, parentCat)async{
  categoryAllLMB.removeAll();
  var data = await Api().getCategory(key, parentCat);
  categoryAllLMB.addAll(data['data']);
}

void loadPost(key, categoryId, limit, postId)async{
  postAllLMB.removeAll();
  var data = await Api().getPost(key, categoryId, limit, postId);
  postAllLMB.addAll(data['data']);
}

void loadCategoryHome(ListMapBloc listMapBloc, String limit, String categoryId)async{
  listMapBloc.removeAll();
  var data = await Api().getPost('', categoryId, limit, '0');
  listMapBloc.addAll(data['data']);

}

// void loadWisataImg()async{
//   wisataPostAllLMB.removeAll();
//   var data = await Api().getPost('', '3', '', '0');
//   wisataPostAllLMB.addAll(data['data']);
// }

// void loadJelajahImg()async{
//   jelajahPostAllLMB.removeAll();
//   var data = await Api().getPost('', '9', '', '0');
//   jelajahPostAllLMB.addAll(data['data']);
// }

// void loadKulinerImg()async{
//   kulinerPostAllLMB.removeAll();
//   var data = await Api().getPost('', '22', '', '0');
//   kulinerPostAllLMB.addAll(data['data']);
// }

// void loadPenginapanImg()async{
//   penginapanPostAllLMB.removeAll();
//   var data = await Api().getPost('', '16', '', '0');
//   penginapanPostAllLMB.addAll(data['data']);
// }

void loadEvent()async{
 eventPostAllLMB.removeAll();
  var data = await Api().getPost('', '38', '', '0');
  eventPostAllLMB.addAll(data['data']);
}

loadHomeSearchPostAll(context, key, categoyId, limit, postId)async{
  ModalContainer(context, 'Loading..', CircularProgressIndicator(), []);
  homeSearchPostAll.removeAll();
  var data = await Api().getPost(key, categoyId, limit, postId);
  if(data['res'] == true){
  homeSearchPostAll.addAll(data['data']);
  Navigator.pop(context);
  }else{
    AlertText(context, WAWarningColor, WALightColor, 'Data tidak ditemukan');
  Navigator.pop(context);
  }
  
}

loadLatLongUser(lat,long){
  latitudeUserCB.changeVal(lat);
  longitudeUserCB.changeVal(long);
}