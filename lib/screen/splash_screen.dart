// import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hai_tegal/components/colors.dart';
import 'package:hai_tegal/master/home_controller.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/utils.dart';
import '../master/account_contrroller.dart';
import '../master/saved_controller.dart';
import '../master/tags_controller.dart';
import '../service/api.dart';



class SplashScreens extends StatefulWidget {
  static String tag = '/SplashScreens';

  const SplashScreens({super.key});

  @override
  SplashScreensState createState() => SplashScreensState();
}

class SplashScreensState extends State<SplashScreens> {

  bool loading = false;




  @override
  void initState() {
    init();
    super.initState();
  }  




  Future<void> init() async {
    // await Api().tokenRefresh();
  login();
  loadBanner();
  loadBoarding();
  loadHome();
  loadCategory('', '0');
  loadPost('', '', '20', '0');
  loadTagPost('');
  if(homeContentAll.state.listDataMap.isNotEmpty){
    for(int i = 0; i < homeContentAll.state.listDataMap.length; i++){
      loadCategoryHome(homeListContent[i], homeContentAll.state.listDataMap[i]['limit_data'].toString(), homeContentAll.state.listDataMap[i]['category_id'].toString());
    }
  }
  
  
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) finish(context);
    setStatusBarColor(WAPrimaryColor1.withOpacity(0.8),
        statusBarIconBrightness: Brightness.light);
  }

  @override
  void dispose() {
    setStatusBarColor(WAPrimaryColor1.withOpacity(0.8),
        statusBarIconBrightness: Brightness.dark);
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) { 
    return MaterialApp(
      builder: (context, child) => 
      Stack(children: [
      Container(
        height: context.height(),
        width: context.width(),
        // decoration: const BoxDecoration(
        //     image: DecorationImage(
        //         image: AssetImage(
        //           'assets/imgsplash.jpeg',
        //         ),
        //         fit: BoxFit.fill,
        //         opacity: 0.6)),
        color: WALightColor,
        child: Image.asset(
              'assets/img/background.png', fit: BoxFit.cover,)
      ),
      Container(
        padding: EdgeInsets.only(top: 0.1*MediaQuery.of(context).size.height),
         width: context.width(),
        // decoration: const BoxDecoration(
        //     image: DecorationImage(
        //         image: AssetImage(
        //           'assets/imgsplash.jpeg',
        //         ),
        //         fit: BoxFit.fill,
        //         opacity: 0.6)),
        // color: WALightColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          SizedBox(width: 0.6*MediaQuery.of(context).size.width, child: Image.asset(
              'assets/logo/HT_FULL_COLOR.png', fit: BoxFit.contain,),),
          //   Column(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //   Image.asset(
          //       'assets/img/logo.png', fit: BoxFit.contain,),
          //   SizedBox(height: 0.01*MediaQuery.of(context).size.height,),
          //   Material(color: Colors.transparent,child: Text('Jalan-jalan, Kulineran, Petualangan', style: GoogleFonts.sourceSans3(fontSize:16, fontWeight: FontWeight.w700),),)
          // ],),
          Padding(padding: EdgeInsets.only(bottom: 0.05*MediaQuery.of(context).size.height), child:
          loading == true? 
      const Center(
              child: CircularProgressIndicator(),
            ):
          BlocBuilder(
            bloc: userDetailMB,
            buildWhen: (previous, current) {
              if(current!=previous){
                return true;
              }else{
                return false;
              }
            },
            builder: (context, state){return GestureDetector(
            onTap: (){
            if(bannerAllLMB.state.listDataMap.isNotEmpty || categoryAllLMB.state.listDataMap.isNotEmpty){
              if(userDetailMB.state.isNotEmpty || userDetailMB.state != {}){
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              }else{
                Navigator.pushNamed(context, '/boarding');
              }
            }else{
              if(bannerAllLMB.state.listDataMap.isEmpty){
                loadBanner();
              }
              if(categoryAllLMB.state.listDataMap.isEmpty){
                loadCategory('', '0');
              }
              AlertText(context, WAPrimaryColor1, WALightColor, 'Load data on process..');
            }
            },
            child: Container(width: 0.8*MediaQuery.of(context).size.width, height: 0.07*MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: WAPrimaryColor1, border: Border.all(color: WASecondary), boxShadow: [
                    BoxShadow(
                      color: WADarkColor.withOpacity(0.2),
                      blurRadius: 2,
                      blurStyle: BlurStyle.inner,
                      offset: const Offset(2, 6,), // Shadow position
                    ),
                  ]),
                  child: Center(child: Material(color: Colors.transparent, child: Text('Siap Berpetualang?', style: GoogleFonts.roboto(fontSize:16, color:WALightColor, fontWeight: FontWeight.bold),),),),
                  ),);}),)
        ],)
      )
      ],),
    );
  }
}
