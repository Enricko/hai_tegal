import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hai_tegal/components/colors.dart';
import 'package:hai_tegal/screen.dart';
import 'package:hai_tegal/screen2.dart';
import 'package:hai_tegal/screen3.dart';
import 'package:line_icons/line_icons.dart';

class Screen4Page extends StatelessWidget {
  const Screen4Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomBarBubble(
        selectedIndex:3,
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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=>const ScreenPage()));
          }else if(index == 1){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=>const Screen2Page()));
          }else if(index == 2){
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=>const Screen3Page()));
          }else{
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=>const Screen4Page()));
          }
          // implement your select function here
        },
      ),
      body: SafeArea(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
    child: SizedBox(height: 0.9*MediaQuery.of(context).size.height, child: SingleChildScrollView(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      SizedBox(height: 0.05*MediaQuery.of(context).size.height,),
      Text('Transportasi', style: GoogleFonts.poppins(fontSize: 30, fontWeight:FontWeight.w700, color:WADarkColor),),
      SizedBox(height: 0.01*MediaQuery.of(context).size.height,),
      Container(
          padding: EdgeInsets.symmetric(horizontal: 0.05*MediaQuery.of(context).size.width),
          height: 0.1 *MediaQuery.of(context).size.height, 
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // number of items in each row
              mainAxisSpacing: 0, // spacing between rows
              crossAxisSpacing: 0, // spacing between columns
            ),
            padding: const EdgeInsets.all(0), // padding around the grid
            itemCount: 4, // total number of items
            itemBuilder: (context, index) {
              return Column(children: [
              Container(
              width: 0.16*MediaQuery.of(context).size.width,
              height: 0.13*MediaQuery.of(context).size.width,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: WAInfo2Color.withOpacity(0.3)),
              child: const Icon(LineIcons.car, color: WALightColor, size: 40,),),
              const SizedBox(height: 3,),
              Text('Test', style: GoogleFonts.sourceSans3(fontSize:16, fontWeight:FontWeight.bold, color:WAInfo2Color),)
            ],);
            },
          ),),
      SizedBox(height: 0.05*MediaQuery.of(context).size.height,),
      Text('Alam', style: GoogleFonts.poppins(fontSize: 20, fontWeight:FontWeight.w700, color:WADarkColor),),
      SizedBox(width: 0.9*MediaQuery.of(context).size.width, height: 0.6*MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: sliderListImage.length,
        itemBuilder: (context, index){
          return Stack(children: [
                      Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      height: 0.4*MediaQuery.of(context).size.height,
                      width: 0.9*MediaQuery.of(context).size.width, 
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: WASecondary), 
                      boxShadow: [
                            BoxShadow(
                              color: WADarkColor.withOpacity(0.6),
                              blurRadius: 2,
                              blurStyle: BlurStyle.inner,
                              offset: const Offset(4, 8,), // Shadow position
                            ),
                          ],
                      image: DecorationImage(image: NetworkImage(sliderListImage[index]),fit: BoxFit.cover)),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: EdgeInsets.only(left: 6, right: 5, top:  0.29*MediaQuery.of(context).size.height),
                        height: 0.12*MediaQuery.of(context).size.height,
                        width: 0.9*MediaQuery.of(context).size.width, 
                            decoration: const BoxDecoration(color: WALightColor,borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)), ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start, children: [ 
                              Text('Staiun ke-$index', style: GoogleFonts.montserrat(fontSize:18, fontWeight:FontWeight.w700, color:WADarkColor),),
                              Row(children: [const Icon(Icons.location_on, color: WAPrimaryColor1, size: 15,), const SizedBox(width: 5,),Text('Penginapan $index', style: GoogleFonts.roboto(fontSize:12, color:WADarkColor, fontWeight: FontWeight.normal),),],),
                              Row(children: List.generate(5, (index) => const Icon(Icons.star, color: WAPrimaryColor1, size: 15,)),)
                              // Text('Keterangan event ke-${index}', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.normal, color:WADarkColor),),
                              ],),
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ 
                              Text('IDR $index ', style: GoogleFonts.montserrat(fontSize:18, fontWeight:FontWeight.w700, color:WADarkColor),),
                              Text('/ night', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.normal, color:WADarkColor),),
                              // Text('Keterangan event ke-${index}', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.normal, color:WADarkColor),),
                              ],)
                            ],),),
                        ],);}),
      )
    ],),),),)),);
  }
}