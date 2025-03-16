import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:carousel_custom_slider/carousel_custom_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hai_tegal/bloc/count_bloc.dart';
import 'package:hai_tegal/components/colors.dart';
import 'package:hai_tegal/master/home_controller.dart';
import 'package:hai_tegal/screen2.dart';
import 'package:hai_tegal/screen3.dart';
import 'package:hai_tegal/screen4.dart';
import 'package:line_icons/line_icons.dart';

import 'service/url.dart';

List<String> sliderListImage = [
  "https://img.freepik.com/free-photo/nature-tranquil-beauty-reflected-calm-water-generative-ai_188544-12798.jpg?size=626&ext=jpg&ga=GA1.1.8332681.1703272078&semt=ais",
  "https://img.freepik.com/free-photo/painting-mountain-lake-with-mountain-background_188544-9126.jpg?size=626&ext=jpg&ga=GA1.1.8332681.1703272078&semt=ais",
  "https://img.freepik.com/free-photo/forest-landscape_71767-127.jpg?size=626&ext=jpg&ga=GA1.1.8332681.1703272078&semt=ais",
];

List<String> listImage = <String>[
  "https://img.freepik.com/free-photo/nature-tranquil-beauty-reflected-calm-water-generative-ai_188544-12798.jpg?size=626&ext=jpg&ga=GA1.1.8332681.1703272078&semt=ais",
  "https://img.freepik.com/free-photo/painting-mountain-lake-with-mountain-background_188544-9126.jpg?size=626&ext=jpg&ga=GA1.1.8332681.1703272078&semt=ais",
  "https://img.freepik.com/free-photo/forest-landscape_71767-127.jpg?size=626&ext=jpg&ga=GA1.1.8332681.1703272078&semt=ais",
  "https://img.freepik.com/free-photo/natures-beauty-reflected-tranquil-mountain-waters-generative-ai_188544-7867.jpg?size=626&ext=jpg&ga=GA1.1.8332681.1703272078&semt=ais",
  "https://img.freepik.com/free-photo/snowy-mountain-peak-starry-galaxy-majesty-generative-ai_188544-9650.jpg?size=626&ext=jpg&ga=GA1.1.8332681.1703272078&semt=ais",
  "https://img.freepik.com/free-photo/glowing-lines-human-heart-3d-shape-dark-background-generative-ai_191095-1435.jpg?size=626&ext=jpg&ga=GA1.1.8332681.1703272078&semt=ais",
];

List<String> imageUrls = <String>[
  "https://i.pravatar.cc/300",
  "https://i.pravatar.cc/300",
  "https://i.pravatar.cc/300",
  "https://i.pravatar.cc/300",
  "https://i.pravatar.cc/300",
  "https://i.pravatar.cc/300",
  "https://i.pravatar.cc/300",
  "https://i.pravatar.cc/300",
  "https://i.pravatar.cc/300",
  "https://i.pravatar.cc/300",
  "https://i.pravatar.cc/300",
  "https://i.pravatar.cc/300",
  "https://i.pravatar.cc/300",
  "https://i.pravatar.cc/300",
];

List<String> sliderTitlePost = [
  "Slide 1",
  "Slide 2",
  "Slide 3",
  "Slide 4",
  "Slide 5",
  "Slide 6",
  "Slide 7",
  "Slide 8",
  "Slide 9",
  "Slide 10",
  "Slide 11",
  "Slide 12",
  "Slide 13",
  "Slide 14",
  // Add more slides here
];

CountBloc initPage = CountBloc();

class ScreenPage extends StatefulWidget {
  const ScreenPage({super.key});

  @override
  State<ScreenPage> createState() => _ScreenPageState();
}

class _ScreenPageState extends State<ScreenPage> {
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      bottomNavigationBar: BottomBarBubble(
        selectedIndex:0,
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
      body: SizedBox(width: MediaQuery.of(context).size.width, height:  0.9*MediaQuery.of(context).size.height, child: 
      SingleChildScrollView(child: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        BlocBuilder(
              bloc: initPage,
              buildWhen: (previous, current) {
                if(previous!=current){
                  return true;
                }else{
                  return false;
                }
              },
              builder: (context, state){
              return SizedBox(height: 0.4*MediaQuery.of(context).size.height, child: 
          Stack(children: [
            CarouselCustomSlider(
              initialPage: initPage.state,
              isDisplayIndicator: false,
              allowImplicitScrolling: true,
              backgroundColor: WAPrimaryColor1,
                doubleTapZoom: true,
                clipBehaviorZoom: true,
                autoPlay: true,
                height: 0.4*MediaQuery.of(context).size.height,
                sliderList:List.generate(imgPostAllLMB.state.listDataMap.length, (index) => Url().urlPict+imgPostAllLMB.state.listDataMap[index]['images_file']),
                fitPic:BoxFit.fill
            ),
            //  Align(child: Row(children: List.generate(imgPostAllLMB.state.listDataMap.length, (index) => GestureDetector(onTap: (){ initPage.changeVal(index);}, 
            // child: Padding(padding: EdgeInsets.symmetric(horizontal: 1), child: CircleAvatar(backgroundColor: index == initPage.state?WAPrimaryColor1:WASecondary, radius: 4,),),)),), alignment: Alignment.bottomLeft,),
            Padding(
                padding: EdgeInsets.only(top:0.06*MediaQuery.of(context).size.height, left: 0.08*MediaQuery.of(context).size.width, right: 0.08*MediaQuery.of(context).size.width),
                child: Material(
                  elevation: 20.0,
                  shadowColor: WADarkColor,
                  color: Colors.transparent,
                  child: TextField(
                  autofocus: false,
                  style: GoogleFonts.roboto(fontSize:16, fontWeight: FontWeight.w400, color:WADarkColor),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: WASecondary,),
                    border: InputBorder.none,
                    hintText: 'Mau jalan-jalan kemana hari ini ?',
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
                ),),
              )
          ],),);
            }),
          SizedBox(height: 0.05*MediaQuery.of(context).size.height,),
          Container(
          padding: EdgeInsets.symmetric(horizontal: 0.05*MediaQuery.of(context).size.width),
          height: 0.12 *MediaQuery.of(context).size.height, 
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // number of items in each row
              mainAxisSpacing: 0, // spacing between rows
              crossAxisSpacing: 0, // spacing between columns
            ),
            padding: const EdgeInsets.all(5.0), // padding around the grid
            itemCount: 4, // total number of items
            itemBuilder: (context, index) {
              return Column(children: [
              Container(
              width: 0.16*MediaQuery.of(context).size.width,
              height: 0.15*MediaQuery.of(context).size.width,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: WAInfo2Color.withOpacity(0.3)),
              child: const Icon(LineIcons.car, color: WALightColor, size: 40,),),
              const SizedBox(height: 3,),
              Text(categoryAllLMB.state.listDataMap[index]['category_name'], style: GoogleFonts.sourceSans3(fontSize:16, fontWeight:FontWeight.bold, color:WAInfo2Color),)
            ],);
            },
          ),),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: List.generate(4, (index) => Padding(padding: EdgeInsets.symmetric(horizontal: 10), 
          //   child: 
          // Column(children: [
          //     Container(
          //     child: Icon(LineIcons.car, color: WALightColor, size: 40,),
          //     width: 0.18*MediaQuery.of(context).size.width,
          //     height: 0.18*MediaQuery.of(context).size.width,
          //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: WAInfo2Color.withOpacity(0.3)),),
          //     SizedBox(height: 5,),
          //     Text('Test', style: GoogleFonts.sourceSans3(fontSize:16, fontWeight:FontWeight.bold, color:WAInfo2Color),)
          //   ],),)),),
           SizedBox(height: 0.01*MediaQuery.of(context).size.height,),
           Center(child: TextButton(onPressed: (){}, child: Text('Cari lebih Banyak?', style: GoogleFonts.sourceSans3(fontSize:14, fontWeight:FontWeight.w600, color:WADangerColor,decoration: TextDecoration.underline, decorationColor:WADangerColor),),),),           
           Padding(padding: const EdgeInsets.only(left: 20), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Wisata yang Lagi rame', style: GoogleFonts.montserrat(fontSize:19, fontWeight:FontWeight.bold, color:WADarkColor),),
              const SizedBox(height: 5,),
              SizedBox(height: 0.2*MediaQuery.of(context).size.height, child: 
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imgPostAllLMB.state.listDataMap.length,
                  itemBuilder: (context, index){return 
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      height: 0.2*MediaQuery.of(context).size.height,
                      width: 0.8*MediaQuery.of(context).size.width, 
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), 
                      image: DecorationImage(image: NetworkImage(Url().urlPict+ imgPostAllLMB.state.listDataMap[index]['images_file']),fit: BoxFit.cover)),
                      child: Padding(padding: const EdgeInsets.only(left: 20, top: 20), child: Text('Wisata ke-$index', style: GoogleFonts.poppins(fontSize:18, fontWeight:FontWeight.w700, color:WALightColor),),),
                      );
                    }),)
            ],),),
            SizedBox(height: 0.05*MediaQuery.of(context).size.height,),
            Padding(padding: const EdgeInsets.only(left: 20), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Jelajahi lebih jauh', style: GoogleFonts.montserrat(fontSize:19, fontWeight:FontWeight.bold, color:WADarkColor),),
              const SizedBox(height: 5,),
              SizedBox(height: 0.3*MediaQuery.of(context).size.height, child: 
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: sliderListImage.length,
                  itemBuilder: (context, index){return 
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      height: 0.3*MediaQuery.of(context).size.height,
                      width: 0.4*MediaQuery.of(context).size.width, 
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), 
                      image: DecorationImage(image: NetworkImage(sliderListImage[index]),fit: BoxFit.cover)),
                       child: Padding(padding: EdgeInsets.only(left: 20, top:  0.25*MediaQuery.of(context).size.height), child: Text('Wisata ke-$index', style: GoogleFonts.montserrat(fontSize:18, fontWeight:FontWeight.w700, color:WALightColor),),),
                      );
                    }),)
            ],),),
            SizedBox(height: 0.05*MediaQuery.of(context).size.height,),
            Padding(padding: const EdgeInsets.only(left: 20), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kuliner Ngehits', style: GoogleFonts.montserrat(fontSize:19, fontWeight:FontWeight.bold, color:WADarkColor),),
              const SizedBox(height: 5,),
              SizedBox(height: 0.2*MediaQuery.of(context).size.height, child: 
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: sliderListImage.length,
                  itemBuilder: (context, index){return 
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      height: 0.2*MediaQuery.of(context).size.height,
                      width: 0.8*MediaQuery.of(context).size.width, 
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), 
                      image: DecorationImage(image: NetworkImage(sliderListImage[index]),fit: BoxFit.cover)),
                      child: Padding(padding: const EdgeInsets.only(left: 20, top: 20), child: Text('Kuliner ke-$index', style: GoogleFonts.montserrat(fontSize:18, fontWeight:FontWeight.w700, color:WALightColor),),),
                      );
                    }),)
            ],),),
            SizedBox(height: 0.05*MediaQuery.of(context).size.height,),
            Padding(padding: const EdgeInsets.only(left: 20), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      height: 0.3*MediaQuery.of(context).size.height,
                      width: 0.7*MediaQuery.of(context).size.width, 
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
                        margin: EdgeInsets.only(left: 5, right: 5, top:  0.22*MediaQuery.of(context).size.height),
                        height: 0.08*MediaQuery.of(context).size.height,
                        width: 0.7*MediaQuery.of(context).size.width, 
                            decoration: const BoxDecoration(color: WALightColor,borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)), ),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ 
                              Text('Event ke-$index', style: GoogleFonts.montserrat(fontSize:18, fontWeight:FontWeight.w700, color:WADarkColor),),
                              Text('Detail event ke-$index', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.normal, color:WADarkColor),),
                              // Text('Keterangan event ke-${index}', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.normal, color:WADarkColor),),
                              ],),),
                        ],);
                    }),)
            ],),),
            SizedBox(height: 0.05*MediaQuery.of(context).size.height,),
            Padding(padding: const EdgeInsets.only(left: 20), child: Row(children: List.generate(3, (index) => 
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        height: 0.03*MediaQuery.of(context).size.height, 
                      decoration: BoxDecoration(border: Border.all(color: WATagColor, width: 1), color: WALightColor, borderRadius: BorderRadius.circular(30)), child: 
                          Row(children: [
                            const Icon(LineIcons.home, size: 18, color: WATagColor,), 
                            const SizedBox(width: 3,),
                            Text('Index k $index', style: GoogleFonts.sourceSans3(fontSize:14, color:WATagColor, fontWeight: FontWeight.bold),)],)),),),),
            SizedBox(height: 0.05*MediaQuery.of(context).size.height,),
            Padding(padding: const EdgeInsets.only(left: 20), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mau coba menginap disini ?', style: GoogleFonts.montserrat(fontSize:19, fontWeight:FontWeight.bold, color:WADarkColor),),
              const SizedBox(height: 5,),
              Column(
                children: List.generate(sliderListImage.length, (index) => Container(
                      margin: const EdgeInsets.only(top: 10, right: 20),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: WASecondary), ),
                    width:MediaQuery.of(context).size.width,  
                    height: 0.2*MediaQuery.of(context).size.height,
                    child: Row(children: [Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5,),
                      height: 0.2*MediaQuery.of(context).size.height,
                      width: 0.3*MediaQuery.of(context).size.width, 
                      decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                      image: DecorationImage(image: NetworkImage(sliderListImage[index]),fit: BoxFit.fill)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text('Penginapan $index', style: GoogleFonts.montserrat(fontSize:19, color:WADarkColor, fontWeight: FontWeight.bold),),
                        Text('Lokasi tempat $index', style: GoogleFonts.roboto(fontSize:12, color:WADarkColor, fontWeight: FontWeight.normal),)
                        ],),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Row(children: [const Icon(Icons.location_on, color: WAPrimaryColor1, size: 15,), const SizedBox(width: 5,),Text('Penginapan $index', style: GoogleFonts.roboto(fontSize:12, color:WADarkColor, fontWeight: FontWeight.normal),),],),
                          Row(children: List.generate(5, (index) => const Icon(Icons.star, color: WAPrimaryColor1, size: 15,)),)
                          ],),
                          SizedBox(width: 0.1*MediaQuery.of(context).size.width,),
                          Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                          Text("IDR 268", style: GoogleFonts.montserrat(fontSize:14, color:WADarkColor, fontWeight: FontWeight.bold),),
                          Text('/night', style: GoogleFonts.roboto(fontSize:10, color:WADarkColor, fontWeight: FontWeight.normal),)
                          ],),
                        ],)
                      ],)
                      
                      ],)
                    
                    )),)
            ],),),
            SizedBox(height: 0.1*MediaQuery.of(context).size.height,),

        ],),

      )
    ));
  }
}
