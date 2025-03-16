  import 'package:flutter/material.dart';
import 'package:hai_tegal/bloc/custom_bloc.dart';
import 'package:hai_tegal/bloc/map_bloc.dart';
import 'package:hai_tegal/service/api.dart';


CustomBloc imgProfile= CustomBloc();
TextEditingController usernameCont = TextEditingController();
TextEditingController emailCont = TextEditingController();
TextEditingController phoneCont = TextEditingController();
CustomBloc dateBirth = CustomBloc();
CustomBloc latitudeCB = CustomBloc();
CustomBloc longitudeCB = CustomBloc();
TextEditingController addressCont = TextEditingController();
MapBloc userDetailMB = MapBloc();

detailAccount(Map data){
  userDetailMB.changeVal(data);
}

Future<void> login() async {
    if ('${user.read('email')}' != 'null' &&
        '${user.read('pass')}' != 'null') {
        var data = await Api().doLogin('${user.read('email')}', '${user.read('pass')}');
            if(data['res'] == true){
                userDetailMB.changeVal(data['data']);
            }
    }
}

