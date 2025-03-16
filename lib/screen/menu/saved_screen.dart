import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hai_tegal/components/colors.dart';
import 'package:hai_tegal/components/utils.dart';
import 'package:hai_tegal/master/account_contrroller.dart';
import 'package:hai_tegal/master/post_controller.dart';
import 'package:hai_tegal/master/saved_controller.dart';
import 'package:hai_tegal/service/api.dart';
import 'package:hai_tegal/service/url.dart';
import 'package:line_icons/line_icons.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

class SavedScreen extends StatelessWidget {
  SavedScreen({super.key});
  TextEditingController cariSaved =TextEditingController();

  @override
  Widget build(BuildContext context) {
    if(userDetailMB.state.isEmpty){
      login();
    }
    return Scaffold(
      appBar: AppBar(leading: IconButton(onPressed: (){Navigator.pushReplacementNamed(context, '/home');}, icon: const Icon(Icons.keyboard_backspace_outlined, color: WADarkColor,)),),
      bottomNavigationBar: BottomBarBubble(
        selectedIndex:2,
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
        body:RefreshIndicator(onRefresh: ()async{loadAllSaved('');}, child: SafeArea(child: 
          SingleChildScrollView(child: 
          Padding(padding: const EdgeInsets.only(left: 20), 
            child: 
            BlocBuilder(
      buildWhen:(previous, current) {
        if(current!=previous){
          return true;
        }else{
          return false;
        }
      },
      bloc: userDetailMB,
      builder:(context, state){
      return userDetailMB.state.isNotEmpty?
      Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  SizedBox(width: 0.75*MediaQuery.of(context).size.width, 
                  child: appTextField2(context, '', cariSaved, hint: 'Cari lokasi..',),),
                  Container(
                    margin: EdgeInsets.only(top: 0.03*MediaQuery.of(context).size.height),
                    width: 0.15*MediaQuery.of(context).size.width, child: IconButton(onPressed: (){
                      loadAllSaved(cariSaved.text);
                    }, icon: const Icon(LineIcons.search, weight: 25,)),)
                ],),
                BlocBuilder(
                  bloc: savedAll,
                  buildWhen: (previous, current) {
                    if(previous!= current){
                      return true;
                    }else{
                      return false;
                    }
                  },
                  builder: (context, state){
                  return 
                  savedAll.state.listDataMap.isNotEmpty?
                  SizedBox(width: 0.9*MediaQuery.of(context).size.width, 
                  height: 0.8*MediaQuery.of(context).size.height,
                    child: 
                    ListView.builder(
                      itemCount: savedAll.state.listDataMap.length,
                      itemBuilder: (BuildContext context, int index){
                        return GestureDetector(
                          onLongPress: (){
                             ModalText(context, 'Konfirmasi', 'Apakah Anda Yakin akan menghapus Postingan ini dari Penyimpanan Anda ?', [
                              IconsButton(onPressed: ()async{
                                var data = await Api().delSaved(savedAll.state.listDataMap[index]['post_saved_id']);
                                if(data['res'] == true){
                                    AlertText(context, WAAccentColor, WALightColor, data['msg']);
                                      Navigator.pop(context);
                                      loadAllSaved('');
                                  }else{
                                    Navigator.pop(context);
                                    AlertText(context, WADangerColor, WALightColor, data['msg']);
                                  }
                              }, text: 'Ya', color: WAAccentColor, textStyle: GoogleFonts.poppins(color:WALightColor, fontWeight:FontWeight.bold),),
                              IconsButton(onPressed: (){
                                Navigator.pop(context);
                              }, text: 'Tidak', color: WAInfoColor, textStyle: GoogleFonts.poppins(color:WALightColor, fontWeight:FontWeight.bold),)
                            ]);
                          },
                          onTap: (){
                          choosePostIndex(savedAll.state.listDataMap[index]);
                          // loadImgPostIndex(savedAll.state.listDataMap[index]['post_id']);
                          loadNearestPostIndex(savedAll.state.listDataMap[index]['venue']['venue_x_coordinat'], savedAll.state.listDataMap[index]['venue']['venue_y_coordinat'], '');
                          loadReviewPostIndex(savedAll.state.listDataMap[index]['post_id']);
                          Navigator.pushNamed(context, '/detail-post');
                        }, child: 
                        Container(
                      margin: const EdgeInsets.only(top: 10, right: 20),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: WASecondary), ),
                    width:MediaQuery.of(context).size.width,  
                    height: 0.15*MediaQuery.of(context).size.height,
                    child: Row(children: [
                      savedAll.state.listDataMap[index]['img'] != null && savedAll.state.listDataMap[index]['img'].length >0?
                      CachedNetworkImage(
                            imageUrl: "${Url().urlPict}${savedAll.state.listDataMap[index]['img'][0]['images_file']??''}",
                            imageBuilder: (context, ImageProvider)=> Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5,),
                            height: 0.15*MediaQuery.of(context).size.height,
                            width: 0.25*MediaQuery.of(context).size.width, 
                            decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                            image: DecorationImage(image: NetworkImage('${Url().urlPict}${savedAll.state.listDataMap[index]['img'][0]['images_file']}'),fit: BoxFit.cover)),
                            ),
                            placeholder: (context, url) => const SizedBox(),
                            errorWidget: (context, url, error) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5,),
                          height: 0.15*MediaQuery.of(context).size.height,
                          width: 0.25*MediaQuery.of(context).size.width, 
                          decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                          image: DecorationImage(image: AssetImage('assets/img/default_post.jpg'),fit: BoxFit.cover)),
                          )
                      ):Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5,),
                          height: 0.15*MediaQuery.of(context).size.height,
                          width: 0.25*MediaQuery.of(context).size.width, 
                          decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                          image: DecorationImage(image: AssetImage('assets/img/default_post.jpg'),fit: BoxFit.cover)),
                          ),
                      SizedBox(width: 0.01*MediaQuery.of(context).size.width,),
                      SizedBox(width: 0.5*MediaQuery.of(context).size.width, child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text('${savedAll.state.listDataMap[index]['post_title']}', style: GoogleFonts.montserrat(fontSize:16, color:WADarkColor, fontWeight: FontWeight.bold),),
                       savedAll.state.listDataMap[index]['venue'] != null? Text('${savedAll.state.listDataMap[index]['venue']['venue_addr']??''}', style: GoogleFonts.roboto(fontSize:12, color:WADarkColor, fontWeight: FontWeight.normal),):SizedBox()
                        ],),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          savedAll.state.listDataMap[index]['venue']!=null&&savedAll.state.listDataMap[index]['venue'].length>0 && latitudeUserCB.state != '' && longitudeUserCB.state != ''?
                          Row(children: [const Icon(Icons.location_on, color: WAPrimaryColor1, size: 15,), const SizedBox(width: 5,),Text('${(calculateDistance(double.parse(latitudeUserCB.state), double.parse(longitudeUserCB.state), double.parse(savedAll.state.listDataMap[index]['venue']['venue_x_coordinat'].toString()), double.parse(savedAll.state.listDataMap[index]['venue']['venue_y_coordinat'].toString()))).toStringAsFixed(0)} km', style: GoogleFonts.roboto(fontSize:12, color:WADarkColor, fontWeight: FontWeight.normal),),],):const SizedBox(),
                         savedAll.state.listDataMap[index]['review']!= null? Text('${savedAll.state.listDataMap[index]['review'].length} reviews', style: GoogleFonts.roboto(fontSize:12, color:WADisableColor, fontWeight: FontWeight.normal),):const SizedBox()
                          ],),
                          SizedBox(width: 0.1*MediaQuery.of(context).size.width,),
                          Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                          Text(savedAll.state.listDataMap[index]['cost']!=null && savedAll.state.listDataMap[index]['cost'].length >0?'IDR${(int.parse(savedAll.state.listDataMap[index]['cost'][0]['cost_price'].toString())/1000).toStringAsFixed(0)} K':'-', style: GoogleFonts.montserrat(fontSize:14, color:WADarkColor, fontWeight: FontWeight.bold),),
                          Text('${savedAll.state.listDataMap[index]['cost']!=null && savedAll.state.listDataMap[index]['cost'].length >0?savedAll.state.listDataMap[index]['cost'][0]['cost_name']:''}', style: GoogleFonts.roboto(fontSize:10, color:WADarkColor, fontWeight: FontWeight.normal),)
                          ],),
                        ],)
                      ],),)
                      ],)
                    )
                        // Stack(children: [
                        //   savedAll.state.listDataMap[index]['img'].length>0?
                        //             CachedNetworkImage(
                        //                   imageUrl: "${Url().urlPict}${savedAll.state.listDataMap[index]['img'][0]['images_file']}",
                        //                   imageBuilder: (context, ImageProvider)=> Container(
                        //                   margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        //                   height: 0.4*MediaQuery.of(context).size.height,
                        //                   width: 0.9*MediaQuery.of(context).size.width, 
                        //                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
                        //                   border: Border.all(color: WASecondary), 
                        //                   boxShadow: [
                        //                         BoxShadow(
                        //                           color: WADarkColor.withOpacity(0.6),
                        //                           blurRadius: 2,
                        //                           blurStyle: BlurStyle.inner,
                        //                           offset: const Offset(4, 8,), // Shadow position
                        //                         ),
                        //                       ],
                        //                   image: DecorationImage(image: NetworkImage("${Url().urlPict}${savedAll.state.listDataMap[index]['img'][0]['images_file']}"),fit: BoxFit.cover)),
                        //                   ),
                        //                   placeholder: (context, url) => SizedBox(width: 0.03*MediaQuery.of(context).size.width, height: 0.03*MediaQuery.of(context).size.width,),
                        //                   errorWidget: (context, url, error) => Container(
                        //                   margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        //                   height: 0.4*MediaQuery.of(context).size.height,
                        //                   width: 0.9*MediaQuery.of(context).size.width, 
                        //                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
                        //                   border: Border.all(color: WASecondary), 
                        //                   boxShadow: [
                        //                         BoxShadow(
                        //                           color: WADarkColor.withOpacity(0.6),
                        //                           blurRadius: 2,
                        //                           blurStyle: BlurStyle.inner,
                        //                           offset: const Offset(4, 8,), // Shadow position
                        //                         ),
                        //                       ],
                        //                   image: const DecorationImage(image: AssetImage('assets/img/default_post.jpg'),fit: BoxFit.cover)),
                        //                   ),
                        //               ):Container(
                        //                   margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        //                   height: 0.4*MediaQuery.of(context).size.height,
                        //                   width: 0.9*MediaQuery.of(context).size.width, 
                        //                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
                        //                   border: Border.all(color: WASecondary), 
                        //                   boxShadow: [
                        //                         BoxShadow(
                        //                           color: WADarkColor.withOpacity(0.6),
                        //                           blurRadius: 2,
                        //                           blurStyle: BlurStyle.inner,
                        //                           offset: const Offset(4, 8,), // Shadow position
                        //                         ),
                        //                       ],
                        //                   image: const DecorationImage(image: AssetImage('assets/img/default_post.jpg'),fit: BoxFit.cover)),
                        //                   ),
                        //             Container(
                        //               padding: const EdgeInsets.all(5),
                        //               margin: EdgeInsets.only(left: 6, right: 5, top: 0.145*MediaQuery.of(context).size.height),
                        //               height: 0.06*MediaQuery.of(context).size.height,
                        //               width: 0.42*MediaQuery.of(context).size.width, 
                        //                   decoration: const BoxDecoration(color: WALightColor,borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)), ),
                        //                   child: Row(
                        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //                     children: [
                        //                     Column(
                        //                     mainAxisAlignment: MainAxisAlignment.end,
                        //                     crossAxisAlignment: CrossAxisAlignment.start, children: [ 
                        //                     SizedBox(width: 0.35*MediaQuery.of(context).size.width, child: Text('${savedAll.state.listDataMap[index]['post_title']}', style: GoogleFonts.montserrat(fontSize:14, fontWeight:FontWeight.w700, color:WADarkColor,), maxLines: 1,overflow: TextOverflow.ellipsis),),
                        //                     SizedBox(width: 0.35*MediaQuery.of(context).size.width, child: Row(
                        //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //                       children: [
                        //                       Row(
                        //                         mainAxisAlignment: MainAxisAlignment.start,
                        //                         children: [const Icon(Icons.location_on, color: WAPrimaryColor1, size: 15,), const SizedBox(width: 5,),Text('$index km', style: GoogleFonts.roboto(fontSize:10, color:WADarkColor, fontWeight: FontWeight.normal),),],),
                        //                       Row(
                        //                         mainAxisAlignment: MainAxisAlignment.end,
                        //                         children: List.generate(5, (index) => const Icon(Icons.star, color: WAPrimaryColor1, size: 10,)),)
                        //                     ],) ,)                             
                        //                     // Text('Keterangan event ke-${index}', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.normal, color:WADarkColor),),
                        //                     ],),
                        //                     // Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ 
                        //                     // Text('IDR ${index} ', style: GoogleFonts.montserrat(fontSize:12, fontWeight:FontWeight.w700, color:WADarkColor),),
                        //                     // Text('/ night', style: GoogleFonts.roboto(fontSize:10, fontWeight:FontWeight.normal, color:WADarkColor),),
                        //                     // // Text('Keterangan event ke-${index}', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.normal, color:WADarkColor),),
                        //                     // ],)
                        //                   ],),),
                        //               ],)
                                      ,);
                      })
                    // GridView.builder(
                    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //         crossAxisCount: 2, // number of items in each row
                    //         mainAxisSpacing: 0, // spacing between rows
                    //         crossAxisSpacing: 0, // spacing between columns
                    //       ),
                    //       padding: const EdgeInsets.all(5.0), 
                    //   itemCount: savedAll.state.listDataMap.length,
                    //   itemBuilder: (context, index){
                    //     return GestureDetector(
                    //       onLongPress: (){
                    //          ModalText(context, 'Konfirmasi', 'Apakah Anda Yakin akan menghapus Postingan ini dari Penyimpanan Anda ?', [
                    //           IconsButton(onPressed: ()async{
                    //             var data = await Api().delSaved(savedAll.state.listDataMap[index]['post_saved_id']);
                    //             if(data['res'] == true){
                    //                 AlertText(context, WAAccentColor, WALightColor, data['msg']);
                    //                   Navigator.pop(context);
                    //                   loadAllSaved('');
                    //               }else{
                    //                 Navigator.pop(context);
                    //                 AlertText(context, WADangerColor, WALightColor, data['msg']);
                    //               }
                    //           }, text: 'Ya', color: WAAccentColor, textStyle: GoogleFonts.poppins(color:WALightColor, fontWeight:FontWeight.bold),),
                    //           IconsButton(onPressed: (){
                    //             Navigator.pop(context);
                    //           }, text: 'Tidak', color: WAInfoColor, textStyle: GoogleFonts.poppins(color:WALightColor, fontWeight:FontWeight.bold),)
                    //         ]);
                    //       },
                    //       onTap: (){
                    //       choosePostIndex(savedAll.state.listDataMap[index]);
                    //       // loadImgPostIndex(savedAll.state.listDataMap[index]['post_id']);
                    //       loadNearestPostIndex(savedAll.state.listDataMap[index]['venue']['venue_x_coordinat'], savedAll.state.listDataMap[index]['venue']['venue_y_coordinat']);
                    //       loadReviewPostIndex(savedAll.state.listDataMap[index]['post_id']);
                    //       Navigator.pushNamed(context, '/detail-post');
                    //     }, child: Stack(children: [
                    //       savedAll.state.listDataMap[index]['img'].length>0?
                    //                 CachedNetworkImage(
                    //                       imageUrl: "${Url().urlPict}${savedAll.state.listDataMap[index]['img'][0]['images_file']}",
                    //                       imageBuilder: (context, ImageProvider)=> Container(
                    //                       margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    //                       height: 0.4*MediaQuery.of(context).size.height,
                    //                       width: 0.9*MediaQuery.of(context).size.width, 
                    //                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
                    //                       border: Border.all(color: WASecondary), 
                    //                       boxShadow: [
                    //                             BoxShadow(
                    //                               color: WADarkColor.withOpacity(0.6),
                    //                               blurRadius: 2,
                    //                               blurStyle: BlurStyle.inner,
                    //                               offset: const Offset(4, 8,), // Shadow position
                    //                             ),
                    //                           ],
                    //                       image: DecorationImage(image: NetworkImage("${Url().urlPict}${savedAll.state.listDataMap[index]['img'][0]['images_file']}"),fit: BoxFit.cover)),
                    //                       ),
                    //                       placeholder: (context, url) => SizedBox(width: 0.03*MediaQuery.of(context).size.width, height: 0.03*MediaQuery.of(context).size.width,),
                    //                       errorWidget: (context, url, error) => Container(
                    //                       margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    //                       height: 0.4*MediaQuery.of(context).size.height,
                    //                       width: 0.9*MediaQuery.of(context).size.width, 
                    //                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
                    //                       border: Border.all(color: WASecondary), 
                    //                       boxShadow: [
                    //                             BoxShadow(
                    //                               color: WADarkColor.withOpacity(0.6),
                    //                               blurRadius: 2,
                    //                               blurStyle: BlurStyle.inner,
                    //                               offset: const Offset(4, 8,), // Shadow position
                    //                             ),
                    //                           ],
                    //                       image: const DecorationImage(image: AssetImage('assets/img/default_post.jpg'),fit: BoxFit.cover)),
                    //                       ),
                    //                   ):Container(
                    //                       margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    //                       height: 0.4*MediaQuery.of(context).size.height,
                    //                       width: 0.9*MediaQuery.of(context).size.width, 
                    //                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
                    //                       border: Border.all(color: WASecondary), 
                    //                       boxShadow: [
                    //                             BoxShadow(
                    //                               color: WADarkColor.withOpacity(0.6),
                    //                               blurRadius: 2,
                    //                               blurStyle: BlurStyle.inner,
                    //                               offset: const Offset(4, 8,), // Shadow position
                    //                             ),
                    //                           ],
                    //                       image: const DecorationImage(image: AssetImage('assets/img/default_post.jpg'),fit: BoxFit.cover)),
                    //                       ),
                    //                 Container(
                    //                   padding: const EdgeInsets.all(5),
                    //                   margin: EdgeInsets.only(left: 6, right: 5, top: 0.145*MediaQuery.of(context).size.height),
                    //                   height: 0.06*MediaQuery.of(context).size.height,
                    //                   width: 0.42*MediaQuery.of(context).size.width, 
                    //                       decoration: const BoxDecoration(color: WALightColor,borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)), ),
                    //                       child: Row(
                    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                         children: [
                    //                         Column(
                    //                         mainAxisAlignment: MainAxisAlignment.end,
                    //                         crossAxisAlignment: CrossAxisAlignment.start, children: [ 
                    //                         SizedBox(width: 0.35*MediaQuery.of(context).size.width, child: Text('${savedAll.state.listDataMap[index]['post_title']}', style: GoogleFonts.montserrat(fontSize:14, fontWeight:FontWeight.w700, color:WADarkColor,), maxLines: 1,overflow: TextOverflow.ellipsis),),
                    //                         SizedBox(width: 0.35*MediaQuery.of(context).size.width, child: Row(
                    //                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //                           children: [
                    //                           Row(
                    //                             mainAxisAlignment: MainAxisAlignment.start,
                    //                             children: [const Icon(Icons.location_on, color: WAPrimaryColor1, size: 15,), const SizedBox(width: 5,),Text('$index km', style: GoogleFonts.roboto(fontSize:10, color:WADarkColor, fontWeight: FontWeight.normal),),],),
                    //                           Row(
                    //                             mainAxisAlignment: MainAxisAlignment.end,
                    //                             children: List.generate(5, (index) => const Icon(Icons.star, color: WAPrimaryColor1, size: 10,)),)
                    //                         ],) ,)                             
                    //                         // Text('Keterangan event ke-${index}', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.normal, color:WADarkColor),),
                    //                         ],),
                    //                         // Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ 
                    //                         // Text('IDR ${index} ', style: GoogleFonts.montserrat(fontSize:12, fontWeight:FontWeight.w700, color:WADarkColor),),
                    //                         // Text('/ night', style: GoogleFonts.roboto(fontSize:10, fontWeight:FontWeight.normal, color:WADarkColor),),
                    //                         // // Text('Keterangan event ke-${index}', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.normal, color:WADarkColor),),
                    //                         // ],)
                    //                       ],),),
                    //                   ],),)
                    //     ;})
                  ):Align(alignment: Alignment.center,child: Padding(padding: const EdgeInsets.only(top: 10), child: Text('Data tidak tersedia', style: GoogleFonts.montserrat(fontSize:12),),),);
                })
          ],):
      Column(children: [
        Align(alignment: Alignment.center, child: 
        SizedBox(
          width: 0.3 * MediaQuery.of(context).size.width,
          height: 0.3 * MediaQuery.of(context).size.width,
          child: Image.asset(
            'assets/img/profile_img.png',
            fit: BoxFit.contain,
          ),
        ),),
        SizedBox(height: 0.05*MediaQuery.of(context).size.height,),
        Text('Anda Belum Login', style: GoogleFonts.poppins(fontSize:16, fontWeight:FontWeight.bold), ),
        SizedBox(height: 0.03*MediaQuery.of(context).size.height,),
        Text('Silakan Login untuk mengeksplore aplikasi lebih jauh dan mereview tempat favorite Anda', style: GoogleFonts.poppins(fontSize:14), textAlign: TextAlign.center,),
        SizedBox(height: 0.05*MediaQuery.of(context).size.height,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, '/login');
            },
            child: Container(width: 0.4*MediaQuery.of(context).size.width, height: 0.07*MediaQuery.of(context).size.height,
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
          GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, '/register');
            },
            child: Container(width: 0.4*MediaQuery.of(context).size.width, height: 0.07*MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: WALightColor, border: Border.all(color: WASecondary), boxShadow: [
                    BoxShadow(
                      color: WADarkColor.withOpacity(0.2),
                      blurRadius: 2,
                      blurStyle: BlurStyle.inner,
                      offset: const Offset(2, 4,), // Shadow position
                    ),
                  ]),
                  child: Center(child: Material(color: Colors.transparent, child: Text('Register', style: GoogleFonts.roboto(fontSize:16, color:WADarkColor, fontWeight: FontWeight.bold),),),),
                  ),),
        ],)

      ],);}),
        ),)
     ,))    );
  }
}