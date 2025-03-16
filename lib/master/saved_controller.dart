import 'package:hai_tegal/bloc/list_map_bloc.dart';
import 'package:hai_tegal/service/api.dart';

ListMapBloc savedAll = ListMapBloc();

loadAllSaved(key)async{
  savedAll.removeAll();
  var data = await Api().getSaved(key);
  savedAll.addAll(data['data']);
}