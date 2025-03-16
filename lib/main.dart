import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hai_tegal/service/route.dart';
import 'package:nb_utils/nb_utils.dart';

import 'bloc/count_bloc.dart';
import 'bloc/custom_bloc.dart';
import 'bloc/list_bloc.dart';
import 'bloc/list_map_bloc.dart';
import 'bloc/map_bloc.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final router = MyRoute();

    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => CustomBloc()),
          BlocProvider(create: (context) => ListMapBloc()),
          BlocProvider(create: (context) => MapBloc()),
          BlocProvider(create: (context) => CountBloc()),
          BlocProvider(create: (context) => ListBloc()),
        ],
        child: MaterialApp(
          initialRoute: "/",
          // home: Screen5Page(),
          onGenerateRoute: router.onRoute,
          title: 'Hai Tegal Apps',
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          // home: WASplashScreen(),
        ));
  }
}