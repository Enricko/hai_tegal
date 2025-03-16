import 'package:hai_tegal/bloc/custom_bloc.dart';

CustomBloc routeMenuBloc = CustomBloc();

moveRouteMenu(String route){
  routeMenuBloc.changeVal(route);
}
