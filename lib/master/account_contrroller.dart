import 'package:flutter/material.dart';
import 'package:hai_tegal/bloc/custom_bloc.dart';
import 'package:hai_tegal/bloc/map_bloc.dart';
import 'package:hai_tegal/service/api.dart';
import 'package:hai_tegal/service/local_storage.dart';
import 'package:get_storage/get_storage.dart';

CustomBloc imgProfile = CustomBloc();
TextEditingController usernameCont = TextEditingController();
TextEditingController emailCont = TextEditingController();
TextEditingController phoneCont = TextEditingController();
CustomBloc dateBirth = CustomBloc();
CustomBloc latitudeCB = CustomBloc();
CustomBloc longitudeCB = CustomBloc();
TextEditingController addressCont = TextEditingController();
MapBloc userDetailMB = MapBloc();
GetStorage user = LocalStorage().user;

void detailAccount(Map data) {
  userDetailMB.changeVal(data);
}

Future<void> login() async {
  if ('${user.read('email')}' != 'null' && '${user.read('pass')}' != 'null') {
    try {
      final response = await Api().doLogin('${user.read('email')}', '${user.read('pass')}');
      
      if (response.success) {
        userDetailMB.changeVal(response.data);
      } else {
        // Handle login failure - this depends on your UI structure
        print('Login failed: ${response.message}');
      }
    } catch (e) {
      print('Login error: $e');
    }
  }
}