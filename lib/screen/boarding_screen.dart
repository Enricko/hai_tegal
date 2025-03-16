import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hai_tegal/bloc/count_bloc.dart';
import 'package:hai_tegal/components/colors.dart';
import 'package:hai_tegal/master/home_controller.dart';
import 'package:hai_tegal/service/url.dart';
import 'package:nb_utils/nb_utils.dart';

import '../master/account_contrroller.dart';
import '../service/api.dart';

class SwipeDetector extends StatelessWidget {
  static const double minMainDisplacement = 50;
  static const double maxCrossRatio = 0.75;
  static const double minVelocity = 300;

  final Widget child;

  final VoidCallback? onSwipeUp;
  final VoidCallback? onSwipeDown;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;

  const SwipeDetector({super.key, 
    required this.child,
    this.onSwipeUp,
    this.onSwipeDown,
    this.onSwipeLeft,
    this.onSwipeRight,
  });

  @override
  Widget build(BuildContext context) {
    DragStartDetails? panStartDetails;
    DragUpdateDetails? panUpdateDetails;

    return GestureDetector(
      onTapDown: (_) => panUpdateDetails = null,  // This prevents two fingers quick taps from being detected as a swipe
      behavior: HitTestBehavior.opaque, // This allows swipe above other clickable widgets
      child: child,
      onPanStart: (startDetails) => panStartDetails = startDetails,
      onPanUpdate: (updateDetails) => panUpdateDetails = updateDetails,
      onPanEnd: (endDetails) {
        if (panStartDetails == null || panUpdateDetails == null) return;

        double dx = panUpdateDetails!.globalPosition.dx -
            panStartDetails!.globalPosition.dx;
        double dy = panUpdateDetails!.globalPosition.dy -
            panStartDetails!.globalPosition.dy;

        int panDurationMiliseconds =
            panUpdateDetails!.sourceTimeStamp!.inMilliseconds -
                panStartDetails!.sourceTimeStamp!.inMilliseconds;

        double mainDis, crossDis, mainVel;
        bool isHorizontalMainAxis = dx.abs() > dy.abs();

        if (isHorizontalMainAxis) {
          mainDis = dx.abs();
          crossDis = dy.abs();
        } else {
          mainDis = dy.abs();
          crossDis = dx.abs();
        }

        mainVel = 1000 * mainDis / panDurationMiliseconds;

        // if (mainDis < minMainDisplacement) return;
        // if (crossDis > maxCrossRatio * mainDis) return;
        // if (mainVel < minVelocity) return;

        if (mainDis < minMainDisplacement) {
          debugPrint(
              "SWIPE DEBUG | Displacement too short. Real: $mainDis - Min: $minMainDisplacement");
          return;
        }
        if (crossDis > maxCrossRatio * mainDis) {
          debugPrint(
              "SWIPE DEBUG | Cross axis displacemnt bigger than limit. Real: $crossDis - Limit: ${mainDis * maxCrossRatio}");
          return;
        }
        if (mainVel < minVelocity) {
          debugPrint(
              "SWIPE DEBUG | Swipe velocity too slow. Real: $mainVel - Min: $minVelocity");
          return;
        }

        // dy < 0 => UP -- dx > 0 => RIGHT
        if (isHorizontalMainAxis) {
          if (dx > 0) {
            onSwipeRight?.call();
          } else {
            onSwipeLeft?.call();
          }
        } else {
          if (dy < 0) {
            onSwipeUp?.call();
          } else {
            onSwipeDown?.call();
          }
        }
      },
    );
  }
}

class BoardingScreen extends StatelessWidget {
  BoardingScreen({super.key});
  

  CountBloc indexBoarding = CountBloc();

  @override
  Widget build(BuildContext context) {
    if(userDetailMB.state.isEmpty){
      login();
    }else{
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }

    return Scaffold(body: 
    SafeArea(child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
      SizedBox(height: 0.1*MediaQuery.of(context).size.height,),
      BlocBuilder(
        bloc: indexBoarding,
        buildWhen: (previous, current) {
          if(current!=previous){
            return true;
          }else{
            return false;
          }
        },
        builder: (context, state){
        return SwipeDetector(
        onSwipeRight:(){
                if(indexBoarding.state > 0){
                indexBoarding.decrement();
                }else{
                  indexBoarding.changeVal(boardingAll.state.listDataMap.length-1);
                }
        },
        onSwipeLeft: (){
                 if(indexBoarding.state < boardingAll.state.listDataMap.length ){
                    indexBoarding.increment();
                  }else{
                    indexBoarding.changeVal(0);
                  }
        },
        child: SizedBox(
        width:MediaQuery.of(context).size.width,  
        height: 0.6*MediaQuery.of(context).size.height,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
        SizedBox(width: context.width(), child: Center(child: SizedBox(width: 0.6*MediaQuery.of(context).size.width, child: Image.network('${Url().getUrlPict()}/${boardingAll.state.listDataMap[indexBoarding.state]['img']}'),),),),
        SizedBox(height: 0.1*MediaQuery.of(context).size.height,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(boardingAll.state.listDataMap.length, (index2) => Padding(padding: const EdgeInsets.symmetric(horizontal: 5), child: CircleAvatar(backgroundColor: indexBoarding.state ==  index2?WAPrimaryColor1:WADisableColor, radius: 5,),)),),
        SizedBox(height: 0.05*MediaQuery.of(context).size.height,),
        Text('${boardingAll.state.listDataMap[indexBoarding.state]['title']}', style: GoogleFonts.poppins(fontSize:30, fontWeight: FontWeight.w700),),
        SizedBox(height: 0.01*MediaQuery.of(context).size.height,),
        Text('${boardingAll.state.listDataMap[indexBoarding.state]['description']}', style: GoogleFonts.roboto(fontSize:14, fontWeight: FontWeight.w400), textAlign: TextAlign.center,),
        ],),),);
      }),
      SizedBox(height: 0.05*MediaQuery.of(context).size.height,),
      GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, '/login');
            },
            child: Container(width: 0.8*MediaQuery.of(context).size.width, height: 0.07*MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: WAPrimaryColor1, border: Border.all(color: WASecondary), boxShadow: [
                    BoxShadow(
                      color: WADarkColor.withOpacity(0.2),
                      blurRadius: 2,
                      blurStyle: BlurStyle.inner,
                      offset: const Offset(2, 4,), // Shadow position
                    ),
                  ]),
                  child: Center(child: Material(color: Colors.transparent, child: Text('Login', style: GoogleFonts.roboto(fontSize:16, color:WALightColor, fontWeight: FontWeight.bold),),),),
                  ),),
       SizedBox(height: 0.005*MediaQuery.of(context).size.height,),
      GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, '/register');
            },
            child: Container(width: 0.8*MediaQuery.of(context).size.width, height: 0.07*MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: WALightColor, border: Border.all(color: WASecondary), boxShadow: [
                    BoxShadow(
                      color: WADarkColor.withOpacity(0.2),
                      blurRadius: 2,
                      blurStyle: BlurStyle.inner,
                      offset: const Offset(2, 4,), // Shadow position
                    ),
                  ]),
                  child: Center(child: Material(color: Colors.transparent, child: Text('Create Account', style: GoogleFonts.roboto(fontSize:16, color:WADarkColor, fontWeight: FontWeight.bold),),),),
                  ),),
       SizedBox(height: 0.01*MediaQuery.of(context).size.height,),
      GestureDetector(onTap: (){
        Navigator.pushNamed(context, '/home');
      },
      child: Text('Masuk tanpa login >>', style: GoogleFonts.poppins(fontSize:12, color:WADisableColor),),
      )
    ],),),);
  }
}