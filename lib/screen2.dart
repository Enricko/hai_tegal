import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hai_tegal/components/colors.dart';
import 'package:hai_tegal/screen.dart';
import 'package:hai_tegal/screen3.dart';
import 'package:hai_tegal/screen4.dart';
import 'package:line_icons/line_icons.dart';

class Screen2Page extends StatelessWidget {
  const Screen2Page({super.key});

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
    body: SafeArea(child: 
      SingleChildScrollView(child: Stack(children: [
        SizedBox(width: MediaQuery.of(context).size.width, 
        height: MediaQuery.of(context).size.height,
        child:  Stack(children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(bottom: 30),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
          ),
          height: 350.0,
          child: Image.asset('assets/img/background_2.png', fit: BoxFit.fitWidth,),
        ),
        SizedBox(
          height: 350.0,
          child: Column(children: [
            Container(
            height: 170.0,
            ),
            Container(
            height: 180.0,
            decoration: const BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      Colors.transparent,
                      WALightColor,
                    ],
                    stops: [
                      0.0,
                      1.0
                    ])),
          ),
          ],),
          )
        ]),
        ),
        Padding(padding: const EdgeInsets.only(left: 20), 
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            SizedBox(height: 0.3*MediaQuery.of(context).size.height,),
            Text('Mau jalan-jalan ke mana ?', style: GoogleFonts.poppins(fontSize:19, color:WALightColor, fontWeight:FontWeight.bold),),
            SizedBox(height: 0.01*MediaQuery.of(context).size.height,),
            Container(width: 0.9*MediaQuery.of(context).size.width, height: 0.2*MediaQuery.of(context).size.height, 
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: WALightColor, border: Border.all(color: WASecondary), 
              boxShadow: [
                    BoxShadow(
                      color: WADarkColor.withOpacity(0.8),
                      blurRadius: 2,
                      blurStyle: BlurStyle.inner,
                      offset: const Offset(2, 6,), // Shadow position
                    ),
                  ],),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
              Padding(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10), 
                child: Material(
                  elevation: 15.0,
                  shadowColor: WASecondary,
                  color: Colors.transparent,
                  child: TextField(
                  autofocus: false,
                  style: GoogleFonts.roboto(fontSize:16, fontWeight: FontWeight.w400, color:WADarkColor),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: WASecondary,),
                    border: InputBorder.none,
                    hintText: '',
                    hintStyle: GoogleFonts.roboto(fontSize:16, fontWeight: FontWeight.w400, color:WASecondary),
                    filled: true,
                    fillColor: WALightColor,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 11),
                    focusedBorder: OutlineInputBorder(
                      gapPadding: 0.3,
                      borderSide: const BorderSide(color: WASecondary),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: WALightColor),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),),),
                Padding(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10), 
                child: GestureDetector(child: Container(width: 0.8*MediaQuery.of(context).size.width, height: 0.07*MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: WAPrimaryColor1, border: Border.all(color: WASecondary), boxShadow: [
                    BoxShadow(
                      color: WADarkColor.withOpacity(0.2),
                      blurRadius: 2,
                      blurStyle: BlurStyle.inner,
                      offset: const Offset(2, 6,), // Shadow position
                    ),
                  ]),
                  child: Center(child: Text('Yuk Jelajahi!', style: GoogleFonts.roboto(fontSize:16, color:WALightColor),),),
                  ),),)
            ],)),
             SizedBox(height: 0.03*MediaQuery.of(context).size.height,),
             Text('Event seru', style: GoogleFonts.montserrat(fontSize:19, fontWeight:FontWeight.bold, color:WADarkColor),),
              const SizedBox(height: 5,),
              SizedBox(height: 0.32*MediaQuery.of(context).size.height, child: 
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: sliderListImage.length,
                  itemBuilder: (context, index){
                    return Stack(children: [
                      Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5,),
                      height: 0.25*MediaQuery.of(context).size.height,
                      width: 0.4*MediaQuery.of(context).size.width, 
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
                        margin: EdgeInsets.only(left: 5, right: 5, top:  0.168*MediaQuery.of(context).size.height),
                        height: 0.08*MediaQuery.of(context).size.height,
                        width: 0.4*MediaQuery.of(context).size.width, 
                            decoration: const BoxDecoration(color: WALightColor,borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)), ),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ 
                              Text('Event ke-$index', style: GoogleFonts.montserrat(fontSize:18, fontWeight:FontWeight.w700, color:WADarkColor),),
                              Text('Detail event ke-$index', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.normal, color:WADarkColor),),
                              // Text('Keterangan event ke-${index}', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.normal, color:WADarkColor),),
                              ],),),
                        ],);
                    }),),
              Container(
                padding: const EdgeInsets.only(right: 20),
                height: 0.3 *MediaQuery.of(context).size.height, 
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // number of items in each row
                    mainAxisSpacing: 0, // spacing between rows
                    crossAxisSpacing: 0, // spacing between columns
                  ),
                  padding: const EdgeInsets.all(1.0), // padding around the grid
                  itemCount: 16, // total number of items
                  itemBuilder: (context, index) {
                    return SizedBox(height: 0.3*MediaQuery.of(context).size.height, 
                    child: Column(children: [
                    Container(
                    width: 0.16*MediaQuery.of(context).size.width,
                    height: 0.14*MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: WAInfo2Color.withOpacity(0.3)),
                    child: const Icon(LineIcons.car, color: WALightColor, size: 40,),),
                    const SizedBox(height: 3,),
                    Text('Test', style: GoogleFonts.sourceSans3(fontSize:14, fontWeight:FontWeight.bold, color:WAInfo2Color),),
                     const SizedBox(height: 1,),
                  ],),);
                  },
                ),),
          ],),
        )
        
      ],),)
     ,),);
  }
}