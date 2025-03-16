import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hai_tegal/components/colors.dart';
import 'package:hai_tegal/master/saved_controller.dart';
import 'package:line_icons/line_icons.dart';

class NotifikasiScreen extends StatelessWidget {
  const NotifikasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomBarBubble(
        selectedIndex:1,
        color: WAPrimaryColor1,
        items: [
          BottomBarItem(
            iconData: LineIcons.home,
            label: 'Home',
            labelTextStyle: GoogleFonts.montserrat(fontSize:14)
          ),
          BottomBarItem(
            iconData: LineIcons.bell,
            label: 'Notification',
            labelTextStyle: GoogleFonts.montserrat(fontSize:14)
          ),
          BottomBarItem(
            iconData: LineIcons.bookmark,
            label: 'Saved',
            labelTextStyle: GoogleFonts.montserrat(fontSize:14)
          ),
          BottomBarItem(
            iconData: LineIcons.user,
            label: 'Account',
            labelTextStyle: GoogleFonts.montserrat(fontSize:14)
          ),
        ],
        onSelect: (index) {
         if(index == 0){
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          }else if(index == 1){
          Navigator.pushNamedAndRemoveUntil(context, '/notifikasi', (route) => false);
          }else if(index == 2){
          loadAllSaved('');
          Navigator.pushNamedAndRemoveUntil(context, '/saved', (route) => false);
          }else{
           Navigator.pushNamedAndRemoveUntil(context, '/account', (route) => false);
          }
        },
      ),
      body: SafeArea(child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
         child: Image.asset('assets/img/coming_soon.jpg'),
      ),),
    );
  }
}