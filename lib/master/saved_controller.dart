import 'package:hai_tegal/bloc/list_map_bloc.dart';
import 'package:hai_tegal/service/api.dart';

ListMapBloc savedAll = ListMapBloc();

Future<void> loadAllSaved(String key) async {
  savedAll.removeAll();
  final response = await Api().getSaved(key);
  
  if (response.success) {
    savedAll.addAll(response.data);
  } else {
    print('Failed to load saved items: ${response.message}');
  }
}

Future<bool> addSavedItem(String postId, String status, String dateTime) async {
  final response = await Api().addSaved(postId, status, dateTime);
  
  if (response.success) {
    // Refresh the saved items list after adding
    await loadAllSaved('');
    return true;
  } else {
    print('Failed to add saved item: ${response.message}');
    return false;
  }
}

Future<bool> deleteSavedItem(String savedId) async {
  final response = await Api().delSaved(savedId);
  
  if (response.success) {
    // Refresh the saved items list after deletion
    await loadAllSaved('');
    return true;
  } else {
    print('Failed to delete saved item: ${response.message}');
    return false;
  }
}