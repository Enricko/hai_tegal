// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:hai_tegal/bloc/count_bloc.dart';
// import 'package:hai_tegal/bloc/list_bloc.dart';
// import 'package:hai_tegal/bloc/list_map_bloc.dart';
// import 'package:hai_tegal/bloc/map_bloc.dart';
// import 'package:hai_tegal/components/colors.dart';
// import 'package:hai_tegal/components/utils.dart';
// import 'package:hai_tegal/master/account_contrroller.dart';
// import 'package:hai_tegal/master/category_controller.dart';
// import 'package:hai_tegal/master/post_controller.dart';
// import 'package:hai_tegal/master/saved_controller.dart';
// import 'package:hai_tegal/service/api.dart';
// import 'package:hai_tegal/service/url.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:line_icons/line_icons.dart';
// import 'package:material_dialogs/widgets/buttons/icon_button.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:screenshot/screenshot.dart';

//   CountBloc isSaved = CountBloc();

// class DetailPostScreen extends StatelessWidget {
//   DetailPostScreen({super.key});
//   final Completer<GoogleMapController> _controllerGoogleMap = Completer();
//   GoogleMapController? newGoogleMapController;
//   Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

//   //deskripsi
//   CountBloc readAll = CountBloc();
//   CountBloc venueHoursAll = CountBloc();
//   CountBloc costAll = CountBloc();
//   CountBloc reviewAll = CountBloc();
//   CountBloc nearestAll = CountBloc();

//   //komentar
//   CountBloc ratingCB = CountBloc();
//   CountBloc idEditedComment = CountBloc();
//   CountBloc screenshotProcess = CountBloc();
//   TextEditingController komentar = TextEditingController();

//   //nearest
//   MapBloc nearestCategory = MapBloc();
  

//   void _add() {
//     var markerIdVal = postIndexMB.state['venue']['venue_id'];
//     final MarkerId markerId = MarkerId(markerIdVal);

//     // creating a new MARKER
//     final Marker marker = Marker(
//       markerId: markerId,
//       position: postIndexMB.state['venue']!=null&& postIndexMB.state['venue'].length>0? LatLng(double.parse(postIndexMB.state['venue']['venue_x_coordinat']),
//           double.parse(postIndexMB.state['venue']['venue_y_coordinat'])):LatLng(double.parse('-6.98528'),
//           double.parse('110.409358')),
//       infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
//       onTap: () {
//         if(postIndexMB.state['venue']!=null&& postIndexMB.state['venue'].length>0){
//           openMap(double.parse(postIndexMB.state['venue']['venue_x_coordinat']), double.parse(postIndexMB.state['venue']['venue_y_coordinat']));
//         }else{
//           openMap(double.parse('-6.98528'), double.parse('110.409358'));
//         }
        
//       },
//     );
//     markers[markerId] = marker;

//     // setState(() {
//     //   // adding a new marker to map
      
//     // });
//   }

//   void cekBookMark(){
//     MapBloc valPostSaved = MapBloc();
//     savedAll.findMap('post_id', postIndexMB.state['post_id'], valPostSaved);
//     print(valPostSaved.state);
//     if(valPostSaved.state.isNotEmpty){
//       isSaved.changeVal(1);
//     }else{
//       isSaved.defaultVal();
//     }
//     print(isSaved.state);
//   }

//   ScreenshotController screenshotController = ScreenshotController();
  
  

//     @override
//   Widget build(BuildContext context) {
//   print(reviewAll.state);

//   Future<String> copyImage(String filename) async {
//     final tempDir = await getTemporaryDirectory();
//     ByteData bytes = await rootBundle.load("assets/$filename");
//     final assetPath = '${tempDir.path}/$filename';
//     File file = await File(assetPath).create();
//     await file.writeAsBytes(bytes.buffer.asUint8List());
//     return file.path;
//   }

//   Future<String?> pickImage() async {
//     final file = await ImagePicker().pickImage(
//       source: ImageSource.gallery,
//     );
//     var path = file?.path;
//     if (path == null) {
//       return null;
//     }
//     return file?.path;
//   }

//   Future<String?> screenshot() async {
//     var data = await screenshotController.capture();
//     if (data == null) {
//       return null;
//     }
//     final tempDir = await getTemporaryDirectory();
//     final assetPath = '${tempDir.path}/temp.png';
//     File file = await File(assetPath).create();
//     await file.writeAsBytes(data);
//     return file.path;
//   }

//     isSaved.defaultVal();
//     cekBookMark();
//     print(isSaved.state);
//     nearestCategory.removeVal();

//     CameraPosition kGooglePlex = CameraPosition(
//         target: LatLng(double.parse('-6.98528'),
//             double.parse('110.345221')),
//         zoom: 14.4746,
//       );

//     if(postIndexMB.state['venue']!=null && postIndexMB.state['venue'].length >0){
//         loadNearestPostIndex(postIndexMB.state['venue']['venue_x_coordinat'], postIndexMB.state['venue']['venue_y_coordinat'],'');
//       _add();
//       kGooglePlex = CameraPosition(
//         target: LatLng(double.parse(postIndexMB.state['venue']['venue_x_coordinat']),
//             double.parse(postIndexMB.state['venue']['venue_y_coordinat']),),
//         zoom: 14.4746,
//       );
//     }
    
//         loadLocation(context, latitudeUser, longitudeUser);

//     void _refresh(){
//        postIndexMB.state['venue']!=null&&postIndexMB.state['venue'].length>0? loadNearestPostIndex(postIndexMB.state['venue']['venue_x_coordinat'], postIndexMB.state['venue']['venue_y_coordinat'], ''):(){};
//        loadReviewPostIndex(postIndexMB.state['post_id']);
//        isSaved.defaultVal();
//        cekBookMark();
//            loadLocation(context, latitudeUser, longitudeUser);
//     }

//     return Scaffold(
//     body: RefreshIndicator(onRefresh: ()async{ _refresh(); }, child: SingleChildScrollView(child: 
//     BlocBuilder(
//       bloc: postIndexMB,
//       buildWhen: (previous, current) {
//         if(current != previous){
//           return true;
//         }else{
//           return false;
//         }
//       },
//       builder: (context, state){
//       return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     mainAxisAlignment: MainAxisAlignment.start,
//      children: [
//       Screenshot(controller: screenshotController, child: 
//         Container(color: WALightColor, child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [Stack(children: [
//             postIndexMB.state['img']!=null &&  postIndexMB.state['img'].length>0?
//             CachedNetworkImage(
//                   imageUrl: "${Url().urlPict}${postIndexMB.state['img'][0]['images_file']}",
//                   imageBuilder: (context, ImageProvider)=> Container(height: 0.3*MediaQuery.of(context).size.height, 
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(image: DecorationImage(image: NetworkImage("${Url().urlPict}${postIndexMB.state['img'][0]['images_file']}"), fit: BoxFit.fill)),
//                   ),
//                   placeholder: (context, url) => SizedBox(width: 0.03*MediaQuery.of(context).size.width, height: 0.03*MediaQuery.of(context).size.width,),
//                   errorWidget: (context, url, error) => Container(height: 0.3*MediaQuery.of(context).size.height, 
//                   width: MediaQuery.of(context).size.width,
//                   decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/img/default_post.jpg"), fit: BoxFit.fill)),
//                   ),
//               ):Container(height: 0.3*MediaQuery.of(context).size.height, 
//                   width: MediaQuery.of(context).size.width,
//                   decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/img/default_post.jpg"), fit: BoxFit.fill)),
//                   ),
//             BlocBuilder(
//               bloc: screenshotProcess,
//               buildWhen: (previous, current) {
//                 if(current!=previous){
//                   return true;
//                 }else{
//                   return false;
//                 }
//               },
//               builder: (context, state){return screenshotProcess.state == 0 ?Container(
//               margin: EdgeInsets.only(top: 0.03*MediaQuery.of(context).size.height),
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               height: 0.3*MediaQuery.of(context).size.height, 
//               width: MediaQuery.of(context).size.width,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                 IconButton(onPressed: (){
//                   Navigator.pop(context);
//                 }, icon: const Icon(Icons.arrow_back, color: WALightColor,)),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                   BlocBuilder(
//                   bloc: savedAll,
//                   buildWhen: (previous, current) {
//                     if(current!=previous){
//                       cekBookMark();
//                       print(isSaved.state);
//                       return true;
//                     }else{
//                       return false;
//                     }
//                   },
//                   builder: (context, state){return CircleAvatar(backgroundColor: WALightColor,child: IconButton(onPressed: ()async{
//                   if(userDetailMB.state.isNotEmpty){
//                     if(isSaved.state == 0){
//                       var data = await Api().addSaved(postIndexMB.state['post_id'], 'saved', DateTime.now().toString());
//                       if(data['res'] == true){
//                         AlertText(context, WAAccentColor, WALightColor, data['msg']);
//                           loadAllSaved('');
//                           cekBookMark();
//                       }else{
//                         AlertText(context, WADangerColor, WALightColor, data['msg']);
//                       }
//                     }else{
//                       ModalText(context, 'Informasi', 'Postingan sudah di Save', [
//                         IconsButton(onPressed: (){
//                           Navigator.pop(context);
//                         }, text: 'Kembali', color: WAInfoColor, textStyle: GoogleFonts.poppins(color:WALightColor, fontWeight:FontWeight.bold),)
//                       ]);
//                     }
//                   }else{
//                       ModalText(context, 'Informasi', 'Silakan login terlebih dahulu', []);
//                     }
//                 }, icon: Icon(LineIcons.bookmark, color: isSaved.state == 1?WAAccentColor:WADisableColor,)),);}),
//                 SizedBox(height: 0.01*MediaQuery.of(context).size.height,),
//                 CircleAvatar(backgroundColor: WALightColor,child: IconButton(onPressed: ()async{
//                   screenshotProcess.changeVal(1);
//                   Uint8List? imgCap = await screenshotController.capture();
//                   final tempDir = await getTemporaryDirectory();
//                   File file = await File('${tempDir.path}/image.png').create();
//                   file.writeAsBytesSync(imgCap!);
//                   List<XFile> imagePaths = [];
//                   imagePaths.add(XFile(file.path));
//                   screenshotProcess.defaultVal();
//                   ModalContainer(context, 'Share Sosial Media', 
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     color: Colors.white,
//                     alignment: Alignment.center,
//                     child: screenshotAndShare(context, 'https://www.google.com/maps/?q=${postIndexMB.state['venue']['venue_x_coordinat']},${postIndexMB.state['venue']['venue_y_coordinat']}', 'https://haitegal.id', imagePaths)
//                   ), [], barrierDismissible: false);
//                 }, icon: Icon(Icons.share, color: WAPrimaryColor1,)),),
//                 ],)
//               ],),
//             ):const SizedBox();})
//             ],),
//             Container(
//             width: MediaQuery.of(context).size.width,
//             padding: const EdgeInsets.only(left: 20,), 
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//               Text('${postIndexMB.state['post_title']}', style: GoogleFonts.montserrat(fontSize:30, color:WADarkColor, fontWeight: FontWeight.bold),),
//               postIndexMB.state['venue']!=null && postIndexMB.state['venue'].length >0?
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                 const Icon(Icons.location_on, color: WAPrimaryColor1,size: 25),
//                 const SizedBox(width:5,),
//                 SizedBox(width: 0.8*MediaQuery.of(context).size.width, 
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text('${postIndexMB.state['venue']['venue_addr']??''}', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.w400, color:WADarkColor),maxLines: 2,),
//                       Text('${postIndexMB.state['village']['village_nm']??''}, ${postIndexMB.state['district']['district_nm']??''}, ${postIndexMB.state['city']['city_nm']??''}', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.w400, color:WADarkColor),maxLines: 2,),
//                       // Text('${postIndexMB.state['district']['district_nm']??''}', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.w400, color:WADarkColor),maxLines: 2,),
//                       // Text('${postIndexMB.state['city']['city_nm']??''}', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.w400, color:WADarkColor),maxLines: 2,)
//                   ],),)
//               ],):const SizedBox(),
//               SizedBox(height:0.01*MediaQuery.of(context).size.height,),
//               postIndexMB.state['venue'] != null && postIndexMB.state['venue'].length >0  && latitudeUserCB.state != '' && longitudeUserCB.state != ''?
//               BlocBuilder(
//                 bloc:latitudeUserCB,
//                 buildWhen: (previous, current) {
//                   if(previous!=current){
//                     return true;
//                   }else{
//                     return false;
//                   }
//                 },
//                 builder: (context, state){return Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   const Icon(Icons.route, color: WAPrimaryColor1, size: 25,), const SizedBox(width: 5,),Text('${(calculateDistance(double.parse(latitudeUserCB.state), double.parse(longitudeUserCB.state), double.parse(postIndexMB.state['venue']['venue_x_coordinat'].toString()), double.parse(postIndexMB.state['venue']['venue_y_coordinat'].toString()))).toStringAsFixed(0)} km', style: GoogleFonts.roboto(fontSize:12, color:WADarkColor, fontWeight: FontWeight.normal),),],);})
//               :const SizedBox(),
//               SizedBox(height:0.03*MediaQuery.of(context).size.height,),
//               const Divider(thickness: 3, color: WASecondary,),
//               BlocBuilder(
//               bloc: screenshotProcess,
//               buildWhen: (previous, current) {
//                 if(current!=previous){
//                   return true;
//                 }else{
//                   return false;
//                 }
//               },
//               builder: (context, state){return 
//                   screenshotProcess.state == 0? 
//                   Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                   SizedBox(height:0.03*MediaQuery.of(context).size.height,),
//                   postIndexMB.state['event']!=null && postIndexMB.state['event'].length>0?
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                     Text('Events', style: GoogleFonts.montserrat(fontSize:16, fontWeight:FontWeight.w600, color:WADarkColor),),
//                     Column(children: List.generate(postIndexMB.state['event'].length, (index) => ListTile(
//                       leading: Text('${1+index}', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.w400, color:WADarkColor)),
//                       title: Text('${postIndexMB.state['event'][index]['event_location']}', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.w400, color:WADarkColor)),
//                       subtitle: Text('${date2(postIndexMB.state['event'][index]['event_start_date'])} - ${date2(postIndexMB.state['event'][index]['event_end_date'])}', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.w400, color:WADarkColor)),
//                       trailing: IconButton(icon: const Icon(Icons.calendar_month, color: WAPrimaryColor1,), onPressed: (){
//                         ModalContainer(context, 'Event Detail', Container(child: 
//                         Column(children: [
//                           CachedNetworkImage(
//                                       imageUrl: "${Url().urlPict}${postIndexMB.state['event'][index]['event_poster_img']}",
//                                       imageBuilder: (context, ImageProvider)=> Container(
//                                           margin: const EdgeInsets.symmetric(horizontal: 5),
//                                           height: 0.2*MediaQuery.of(context).size.height,
//                                           width: 0.8*MediaQuery.of(context).size.width, 
//                                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), 
//                                           image: DecorationImage(image: 
//                                             NetworkImage('${Url().urlPict}${postIndexMB.state['event'][index]['event_poster_img']}'??''),fit: BoxFit.cover)
//                                           ),
//                                           ),
//                                       placeholder: (context, url) => const SizedBox(),
//                                       errorWidget: (context, url, error) => Container(
//                                           margin: const EdgeInsets.symmetric(horizontal: 5),
//                                           height: 0.2*MediaQuery.of(context).size.height,
//                                           width: 0.8*MediaQuery.of(context).size.width, 
//                                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), 
//                                           image: const DecorationImage(image: 
//                                             AssetImage('assets/img/default_post.jpg'),fit: BoxFit.cover)
//                                           ),
//                                           ),
//                                   ),
//                                   SizedBox(height: 0.05*MediaQuery.of(context).size.height,),
//                               Text('${postIndexMB.state['event'][index]['event_location']??''}', style: GoogleFonts.roboto(fontSize:14, fontWeight:FontWeight.w400, color:WADarkColor),),
//                         ],),), []);
//                       },),
//                     )),),
//                     SizedBox(height:0.03*MediaQuery.of(context).size.height,),
//                   ],):const SizedBox(),
//                   BlocBuilder(
//                   bloc:costAll,
//                   buildWhen: (previous, current) {
//                       if(current!=previous){
//                         return true;
//                       }else{
//                         return false;
//                       }
//                     },
//                   builder: (context, state){return postIndexMB.state['cost']!=null && postIndexMB.state['cost'].length>0?
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                       Text('Biaya', style: GoogleFonts.montserrat(fontSize:16, fontWeight:FontWeight.w600, color:WADarkColor),),
//                       const Spacer(),
//                       costAll.state==0? GestureDetector(onTap: (){
//                         costAll.changeVal(1);
//                       }, child: Text('Lihat', style: GoogleFonts.montserrat(fontSize:12, fontWeight:FontWeight.w400, color:WAPrimaryColor1),),):
//                       GestureDetector(onTap: (){
//                         costAll.changeVal(0);
//                       }, child: Text('Tutup', style: GoogleFonts.montserrat(fontSize:12, fontWeight:FontWeight.w400, color:WAPrimaryColor1),),),
//                       SizedBox(width: 0.05*MediaQuery.of(context).size.width,)
//                     ],),
//                     costAll.state==1? Column(children: List.generate(postIndexMB.state['cost'].length, (index) => ListTile(
//                       title: Text(postIndexMB.state['cost'][index]['cost_name'], style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.w400, color:WADarkColor)),
//                       subtitle: Text('IDR ${rupiah(double.parse(postIndexMB.state['cost'][index]['cost_price'].toString()))}', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.w400, color:WADarkColor)),
//                     )),):const SizedBox(),
//                     SizedBox(height:0.03*MediaQuery.of(context).size.height,),
//                   ],):const SizedBox();}),
//                   BlocBuilder(
//                   bloc:venueHoursAll,
//                   buildWhen: (previous, current) {
//                       if(current!=previous){
//                         return true;
//                       }else{
//                         return false;
//                       }
//                     },
//                   builder: (context, state){return postIndexMB.state['venue_hours']!=null && postIndexMB.state['venue_hours'].length>0?
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                       Text('Jam Operasional', style: GoogleFonts.montserrat(fontSize:16, fontWeight:FontWeight.w600, color:WADarkColor),),
//                       const Spacer(),
//                       venueHoursAll.state==0? GestureDetector(onTap: (){
//                         venueHoursAll.changeVal(1);
//                       }, child: Text('Lihat', style: GoogleFonts.montserrat(fontSize:12, fontWeight:FontWeight.w400, color:WAPrimaryColor1),),):
//                       GestureDetector(onTap: (){
//                         venueHoursAll.changeVal(0);
//                       }, child: Text('Tutup', style: GoogleFonts.montserrat(fontSize:12, fontWeight:FontWeight.w400, color:WAPrimaryColor1),),),
//                       SizedBox(width: 0.05*MediaQuery.of(context).size.width,)
//                     ],),
//                     venueHoursAll.state==1? Column(children: List.generate(postIndexMB.state['venue_hours'].length, (index) => ListTile(
//                       leading: Text('${1+index}', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.w400, color:WADarkColor)),
//                       title: Text(dayCheck(postIndexMB.state['venue_hours'][index]['operational_day'].toString()), style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.w400, color:WADarkColor)),
//                       subtitle: Text('${postIndexMB.state['venue_hours'][index]['operational_open']} - ${postIndexMB.state['venue_hours'][index]['operational_closed']}', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.w400, color:WADarkColor)),
//                     )),):const SizedBox(),
//                     SizedBox(height:0.03*MediaQuery.of(context).size.height,),
//                   ],):const SizedBox();}),
//                   Text('Details', style: GoogleFonts.montserrat(fontSize:16, fontWeight:FontWeight.w600, color:WADarkColor),),
//                   SizedBox(height:0.01*MediaQuery.of(context).size.height,),
//                   Text('${postIndexMB.state['post_short']}', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.w400, color:WADarkColor), maxLines: 10,),
//                   // BlocBuilder(
//                   //   bloc: readAll,
//                   //   buildWhen: (previous, current) {
//                   //     if(current!=previous){
//                   //       return true;
//                   //     }else{
//                   //       return false;
//                   //     }
//                   //   },
//                   //   builder: (context, state){
//                   //     return Column(
//                   //       crossAxisAlignment: CrossAxisAlignment.start,
//                   //       mainAxisAlignment: MainAxisAlignment.center,
//                   //       children: [
//                   //       Text('${postIndexMB.state['post_short']}', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.w400, color:WADarkColor), maxLines: readAll.state==0?3:10,),
//                   //       readAll.state==0? GestureDetector(onTap: (){
//                   //         readAll.changeVal(1);
//                   //       }, child: Text('..Read more', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.w400, color:WAPrimaryColor1),),):
//                   //       GestureDetector(onTap: (){
//                   //         readAll.changeVal(0);
//                   //       }, child: Text('..Ringkasan', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.w400, color:WAPrimaryColor1),),),
//                   //       ],);
//                   // }),
//                   SizedBox(height:0.01*MediaQuery.of(context).size.height,),
//                   BlocBuilder(
//                     bloc: reviewPostAllLMB,
//                     buildWhen: (previous, current) {
//                       if(previous!=current){
//                         return true;
//                       }else{
//                         return false;
//                       }
//                     },
//                     builder: (context, state){return Container(
//                     margin: const EdgeInsets.only(right: 20),
//                     padding: const EdgeInsets.all(20),
//                     width: 0.85*MediaQuery.of(context).size.width,
//                     height: 0.25*MediaQuery.of(context).size.height,
//                     decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
//                         boxShadow: [
//                               BoxShadow(
//                                 color: WADarkColor.withOpacity(0.6),
//                                 blurRadius: 4,
//                                 blurStyle: BlurStyle.outer,
//                                 offset: const Offset(4, 8,), // Shadow position
//                               ),
//                             ],
//                     ),
//                     child:Column(children: [
//                       Row(children: [
//                           Text(averageReviewCB.state['average'].toString() == 'null'?'0':averageReviewCB.state['average'].toStringAsFixed(2), style: GoogleFonts.montserrat(fontSize:30, fontWeight:FontWeight.w700),),
//                           const SizedBox(width: 10,),
//                           Text('Review Summary',  style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.w400),)
//                         ],),
//                       SizedBox(height:0.02*MediaQuery.of(context).size.height,),
//                       Column(children: List.generate(5, (index) => Row(children: [
//                           Text('${1+index}',  style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.w400),),                
//                           const SizedBox(width: 10,),
//                           Container(width: (int.parse(reviewSummaryPostAllLMB.state[(1+index).toString()].toString()=='null'?'0':reviewSummaryPostAllLMB.state[(1+index).toString()].toString()))/10*MediaQuery.of(context).size.width, height: 0.01*MediaQuery.of(context).size.height,color: WAPrimaryColor1,)
//                         ],)),),
//                     ],)
//                   );}),
//                   SizedBox(height:0.05*MediaQuery.of(context).size.height,),
//                   Padding(padding: const EdgeInsets.only(right: 20), child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                     Text('Gallery', style: GoogleFonts.montserrat(fontSize:16, fontWeight:FontWeight.w600, color:WADarkColor),),
//                     Text('View All', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.w400, color:WAPrimaryColor1),),
//                   ],),),
//                   SizedBox(height:0.02*MediaQuery.of(context).size.height,),
//                   BlocBuilder(
//                     bloc: imgPostAllLMB,
//                     buildWhen: (previous, current) {
//                       if(previous!=current){
//                         return true;
//                       }else{
//                         return false;
//                       }
//                     },
//                     builder: (context, state){
//                     return
//                 postIndexMB.state['img'] !=null?
//                 SizedBox(
//                   height: 0.15*MediaQuery.of(context).size.height,
//                   width: 0.95*MediaQuery.of(context).size.width,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount:postIndexMB.state['img'].length,
//                     itemBuilder: (context, index){
//                       return postIndexMB.state['img'].length>0?
//                         CachedNetworkImage(
//                             imageUrl: "${Url().urlPict}${postIndexMB.state['img'][index]['images_file']}",
//                             imageBuilder: (context, ImageProvider)=> GestureDetector(onTap: (){
//                               ModalContainer(context, '', 
//                               transparentBackground: true,
//                               titleShow: false,
//                               Stack(children: [
//                                 Image.network("${Url().urlPict}${postIndexMB.state['img'][index]['images_file']}", fit: BoxFit.contain,),
//                                 Padding(padding: EdgeInsets.only(top: 0.01*MediaQuery.of(context).size.height,left: 0.7*MediaQuery.of(context).size.width), child: GestureDetector(onTap: (){
//                                   Navigator.pop(context);
//                                 }, child: CircleAvatar(radius: 10 ,backgroundColor: WALightColor,child: Icon(Icons.close,color: WAPrimaryColor1, size: 15,)),),)
//                               ],)
//                               , []);
//                             }, child: Container(
//                                   margin: const EdgeInsets.symmetric(horizontal: 5),
//                                   width: 0.3*MediaQuery.of(context).size.width,
//                                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
//                                   image: DecorationImage(image: NetworkImage("${Url().urlPict}${postIndexMB.state['img'][index]['images_file']}"), fit: BoxFit.fill)
//                                   ),
//                                   ),),
//                             placeholder: (context, url) => SizedBox(width: 0.03*MediaQuery.of(context).size.width, height: 0.03*MediaQuery.of(context).size.width),
//                             errorWidget: (context, url, error) => Container(
//                                   margin: const EdgeInsets.symmetric(horizontal: 5),
//                                   width: 0.3*MediaQuery.of(context).size.width,
//                                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
//                                   image: const DecorationImage(image: AssetImage("assets/img/default_post.jpg"), fit: BoxFit.fill)
//                                   ),
//                                   ),
//                         ):Container(
//                                   margin: const EdgeInsets.symmetric(horizontal: 5),
//                                   width: 0.3*MediaQuery.of(context).size.width,
//                                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
//                                   image: const DecorationImage(image: AssetImage("assets/img/default_post.jpg"), fit: BoxFit.fill)
//                                   ),
//                                   );})
//                 ):const SizedBox();
//               }),
//               SizedBox(height:0.03*MediaQuery.of(context).size.height,),
//               const Divider(thickness: 3, color: WASecondary,),],):const SizedBox();}
//             )
//             ],),),
//       ],),)),
//       SizedBox(height:0.03*MediaQuery.of(context).size.height,),
//       SizedBox(width: MediaQuery.of(context).size.width, height: 0.3*MediaQuery.of(context).size.height,
//         child: GoogleMap(
//             mapType: MapType.normal,
//             myLocationEnabled: true,
//             initialCameraPosition: kGooglePlex,
//             markers: Set<Marker>.of(markers.values),
//             onMapCreated: (GoogleMapController controller) {
//               _controllerGoogleMap.complete(controller);
//               newGoogleMapController = controller;

//               //for black theme google map
//               // blackThemeGoogleMap();
//             },
//           ),
//         ),
//       SizedBox(height:0.03*MediaQuery.of(context).size.height,),
//       Center(child: Text('Lokasi Terdekat', style: GoogleFonts.montserrat(fontSize:24, fontWeight: FontWeight.w400),),),
//       SizedBox(height:0.03*MediaQuery.of(context).size.height,),
//       BlocBuilder(
//         bloc: nearestCategory,
//         buildWhen: (previous, current) {
//           if(current!=previous){
//             return true;
//           }else{
//             return false;
//           }
//         },
//         builder: (context, state){
//         return Center(child: Container(
//               width: 0.9*MediaQuery.of(context).size.width, 
//               height: 0.08*MediaQuery.of(context).size.height, 
//               decoration: BoxDecoration(color: WASecondary, borderRadius: BorderRadius.circular(30)),
//               child: 
//               postIndexMB.state['category'] != [] && postIndexMB.state['category'].length > 0?
//               ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: postIndexMB.state['category'].length,
//                 itemBuilder: (context, index){
//                   return Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: TextButton(onPressed: (){
//                     nearestCategory.changeVal(postIndexMB.state['category'][index]);
//                     postIndexMB.state['venue']!=null&&postIndexMB.state['venue'].length>0? loadNearestPostIndex(postIndexMB.state['venue']['venue_x_coordinat'], postIndexMB.state['venue']['venue_y_coordinat'], nearestCategory.state['category_id']):(){};
//                   }, child: Text(postIndexMB.state['category'][index]['category_name']??'', style: GoogleFonts.poppins(color:nearestCategory.state['category_name'] == postIndexMB.state['category'][index]['category_name']? WADarkColor:WAPrimaryColor1, fontSize:16),)),);
//                 }):SizedBox(),
//         ),
//       );}),
//       SizedBox(height:0.03*MediaQuery.of(context).size.height,),
//       // BlocBuilder(
//       //   bloc: nearestPostAllLMB,
//       //   buildWhen:(previous, current) {
//       //           if(previous!=current){
//       //             return true;
//       //           }else{
//       //             return false;
//       //           }
//       //         },
//       //   builder: (context, state){
//       //   return Center(
//       //   child: BlocBuilder(
//       //         bloc: nearestAll,
//       //         buildWhen:(previous, current) {
//       //           if(previous!=current){
//       //             return true;
//       //           }else{
//       //             return false;
//       //           }
//       //         },
//       //         builder: (context, state){
//       //         return 
//       //         nearestPostAllLMB.state.listDataMap.isNotEmpty?
//       //         nearestAll.state == 0 ?
//       //         GestureDetector(
//       //           onTap: (){
//       //             nearestAll.changeVal(1);
//       //             print(nearestAll.state);
//       //           },
//       //           child: Text('View All', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.w400, color:WAPrimaryColor1)),
//       //         ):GestureDetector(
//       //           onTap: (){
//       //            nearestAll.defaultVal();
//       //             print(nearestAll.state);
//       //           },
//       //           child: Text('Hide Other', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.w400, color:WAPrimaryColor1)),
//       //         ):SizedBox();
//       //       }),);
//       // }),
//       SizedBox(height:0.02*MediaQuery.of(context).size.height,),
//       BlocBuilder(
//       bloc: nearestAll,
//        buildWhen: (previous, current) {
//         if(previous!=current){
//           return true;
//         }else{
//           return false;
//         }
//       },
//       builder: (context, state){
//       return BlocBuilder(
//       bloc: nearestPostAllLMB,
//       buildWhen: (previous, current) {
//         if(previous!=current){
//           return true;
//         }else{
//           return false;
//         }
//       },
//       builder: (context, state){return Padding(padding: const EdgeInsets.symmetric(horizontal: 15),
//       child: 
//       nearestPostAllLMB.state.listDataMap.isNotEmpty?
//       Column(
//         children: 
//         List.generate(nearestAll.state == 0?nearestPostAllLMB.state.listDataMap.length>4?4:(nearestPostAllLMB.state.listDataMap.length>1)&&(nearestPostAllLMB.state.listDataMap.length<4)? nearestPostAllLMB.state.listDataMap.length:1:nearestPostAllLMB.state.listDataMap.length, (index){
//           print(nearestPostAllLMB.state.listDataMap);
//         return GestureDetector(
//           onTap: (){
//             choosePostIndex(nearestPostAllLMB.state.listDataMap[index]['post']);
//             nearestPostAllLMB.state.listDataMap[index]['post']['venue']!=null&&nearestPostAllLMB.state.listDataMap[index]['post']['venue'].length>0? loadNearestPostIndex(nearestPostAllLMB.state.listDataMap[index]['post']['venue']['venue_x_coordinat'], nearestPostAllLMB.state.listDataMap[index]['post']['venue']['venue_y_coordinat'], ''):(){};
//             loadReviewPostIndex(nearestPostAllLMB.state.listDataMap[index]['post_id']);
//             Navigator.pushNamed(context, '/detail-post');
//           },
//           child:  Container(
//               margin: const EdgeInsets.only(top: 10, right: 10),
//             decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
//               border: Border.all(color: WASecondary), ),
//             width:MediaQuery.of(context).size.width,  
//             height: 0.2*MediaQuery.of(context).size.height,
//             child: Row(children: [
//               nearestPostAllLMB.state.listDataMap[index]['post']['img'] != null&&nearestPostAllLMB.state.listDataMap[index]['post']['img'].length>0?
//               CachedNetworkImage(
//                   imageUrl: "${Url().urlPict}${nearestPostAllLMB.state.listDataMap[index]['post']['img'][0]['images_file']}",
//                   imageBuilder: (context, ImageProvider)=>Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 5,),
//                   height: 0.2*MediaQuery.of(context).size.height,
//                   width: 0.3*MediaQuery.of(context).size.width, 
//                   decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
//                   image: DecorationImage(image: NetworkImage("${Url().urlPict}${nearestPostAllLMB.state.listDataMap[index]['post']['img'][0]['images_file']}"),fit: BoxFit.cover)),
//                   ),
//                   placeholder: (context, url) => SizedBox(width: 0.03*MediaQuery.of(context).size.width, height: 0.03*MediaQuery.of(context).size.width,),
//                   errorWidget: (context, url, error) => Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 5,),
//                   height: 0.2*MediaQuery.of(context).size.height,
//                   width: 0.3*MediaQuery.of(context).size.width, 
//                   decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
//                   image: DecorationImage(image: AssetImage('assets/img/default_post.jpg'),fit: BoxFit.cover)),
//                   ),
//               ):Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 5,),
//                   height: 0.2*MediaQuery.of(context).size.height,
//                   width: 0.3*MediaQuery.of(context).size.width, 
//                   decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
//                   image: DecorationImage(image: AssetImage('assets/img/default_post.jpg'),fit: BoxFit.cover)),
//                   ),
//               SizedBox(width: 0.03*MediaQuery.of(context).size.width,),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                 SizedBox(width: 0.5*MediaQuery.of(context).size.width, child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                 Text('${nearestPostAllLMB.state.listDataMap[index]['post']['post_title']}', style: GoogleFonts.montserrat(fontSize:16, color:WADarkColor, fontWeight: FontWeight.bold),maxLines: 2,),
//                 Text('${nearestPostAllLMB.state.listDataMap[index]['post']['venue']['venue_addr']}', style: GoogleFonts.roboto(fontSize:12, color:WADarkColor, fontWeight: FontWeight.normal), maxLines: 3,)
//                 ],),),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                   // Column(
//                   // crossAxisAlignment: CrossAxisAlignment.start,
//                   // children: [
//                   Row(children: [const Icon(Icons.location_on, color: WAPrimaryColor1, size: 15,), const SizedBox(width: 5,),Text('${(nearestPostAllLMB.state.listDataMap[index]['distance']/1000).toStringAsFixed(2)} km', style: GoogleFonts.roboto(fontSize:12, color:WADarkColor, fontWeight: FontWeight.normal),),],),
//                   // Row(children: List.generate(5, (index) => Icon(Icons.star, color: WAPrimaryColor1, size: 15,)),)
//                   // ],),
//                   SizedBox(width: 0.1*MediaQuery.of(context).size.width,),
//                   Row(
//                 mainAxisAlignment: MainAxisAlignment.end,  
//                 children: List.generate(5, (index2) => Icon(Icons.star, color: (index2+1) <=int.parse(nearestPostAllLMB.state.listDataMap[index]['post']['average_rating'].round().toString())?WAPrimaryColor1:WADisableColor, size: 18,)),),
//                   // Column(
//                   // crossAxisAlignment: CrossAxisAlignment.end,
//                   // children: [
//                   // Text("IDR 268", style: GoogleFonts.montserrat(fontSize:14, color:WADarkColor, fontWeight: FontWeight.bold),),
//                   // Text('/night', style: GoogleFonts.roboto(fontSize:10, color:WADarkColor, fontWeight: FontWeight.normal),)
//                   // ],),
//                 ],)
//               ],)
//               ],)
//       ),);
//       }),):Align(alignment: Alignment.center,child: Padding(padding: const EdgeInsets.only(top: 10), child: Text('Data tidak tersedia', style: GoogleFonts.montserrat(fontSize:12),),),),
//       );});
//       }),
//       SizedBox(height:0.05*MediaQuery.of(context).size.height,),
//       Padding(padding: const EdgeInsets.symmetric(horizontal: 30), child: 
//       Column(children: [
//         const Divider(thickness: 3, color: WASecondary,),
//         userDetailMB.state.isNotEmpty? 
//         Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//             SizedBox(height:0.03*MediaQuery.of(context).size.height,),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//               userDetailMB.state['user_img'] == ''?const CircleAvatar(radius: 30, backgroundImage: AssetImage('assets/img/profile_img.png')):CircleAvatar(radius: 30, backgroundImage: MemoryImage(base64Decode(userDetailMB.state['user_img']))),
//               SizedBox(width:0.03*MediaQuery.of(context).size.width,),
//               SizedBox(width: 0.45*MediaQuery.of(context).size.width, child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                 Text('${userDetailMB.state['user_name']}', style: GoogleFonts.montserrat(fontSize:14, fontWeight: FontWeight.w700),),
//                 Text(date2(DateTime.now().toString()), style: GoogleFonts.roboto(fontSize:12, fontWeight: FontWeight.w400),),
//               ],),),
//             ],),
//             SizedBox(height:0.05*MediaQuery.of(context).size.height,),
//             SizedBox(width: 0.8*MediaQuery.of(context).size.width, 
//             child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                 Text('Berikan Rating', style: GoogleFonts.roboto(fontSize:14, fontWeight: FontWeight.w400),),
//                 SizedBox(
//                 width: 0.3*MediaQuery.of(context).size.width,
//                 height:0.01*MediaQuery.of(context).size.height,),
//                 BlocBuilder(
//                   bloc: ratingCB,
//                   buildWhen: (previous, current) {
//                     if(current!=previous){
//                       return true;
//                     }else{
//                       return false;
//                     }
//                   },
//                   builder: (context, state){return Row(children: List.generate(5, (index) => GestureDetector(onTap: (){
//                     ratingCB.changeVal((index+1));
//                   }, child: Icon(Icons.star, color: (1+index) <= ratingCB.state?WAPrimaryColor1:WADisableColor, size: 20,),)),);})
//               ],),),
//             SizedBox(height:0.03*MediaQuery.of(context).size.height,),
//             SizedBox(width: 0.8*MediaQuery.of(context).size.width, 
//               child: 
//                 Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Deskripsi Ulasan', style: GoogleFonts.roboto(fontSize:14, fontWeight:FontWeight.w400),),
//                   TextField(decoration: InputDecoration(hintText: 'Berikan review Anda...', hintStyle: GoogleFonts.poppins(fontSize:12, color: WADisableColor)), controller: komentar, maxLength: 500, maxLines: 3,style:GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.w400)),],
//                 ),),
//             Center(child:  BlocBuilder(
//               bloc: idEditedComment,
//               buildWhen:(previous, current) {
//                 if(current!=previous){
//                   return true;
//                 }else{
//                   return false;
//                 }
//               },
//               builder: (context, state){
//               return  TextButton(onPressed: ()async{
//                 if(idEditedComment.state == 0){
//                   var data = await Api().addComment(postIndexMB.state['post_id'], komentar.text, ratingCB.state.toString(), 'active', DateTime.now().toString());
//                   if(data['res'] == true){
//                     AlertText(context, WAAccentColor, WALightColor, data['msg']);
//                       loadReviewPostIndex(postIndexMB.state['post_id'].toString());
//                       komentar.clear();
//                       ratingCB.defaultVal();
//                       idEditedComment.defaultVal();
//                   }else{
//                     AlertText(context, WADangerColor, WALightColor, data['msg']);
//                   }
//                 }else{
//                   var data = await Api().updateComment(idEditedComment.state.toString(),postIndexMB.state['post_id'], komentar.text, ratingCB.state.toString(), 'active', DateTime.now().toString());
//                   if(data['res'] == true){
//                     AlertText(context, WAAccentColor, WALightColor, data['msg']);
//                       loadReviewPostIndex(postIndexMB.state['post_id'].toString());
//                       komentar.clear();
//                       ratingCB.defaultVal();
//                       idEditedComment.defaultVal();
//                   }else{
//                     AlertText(context, WADangerColor, WALightColor, data['msg']);
//                   }
//                 }
//               }, child: Container(width: 0.4*MediaQuery.of(context).size.width, height: 0.05*MediaQuery.of(context).size.height, alignment: Alignment.center , decoration: BoxDecoration(color: WAPrimaryColor1, borderRadius: BorderRadius.circular(30)),child: Text(idEditedComment.state == 0?'Kirim':'Update', style: GoogleFonts.poppins(fontSize:14, fontWeight:FontWeight.bold, color:WALightColor),),));}),),
//             SizedBox(height:0.05*MediaQuery.of(context).size.height,),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Reviews (${reviewPostAllLMB.state.listDataMap.length})', style: GoogleFonts.montserrat(fontSize:16, fontWeight:FontWeight.w600),),
//                 BlocBuilder(
//                   bloc: reviewAll,
//                   buildWhen:(previous, current) {
//                     if(previous!=current){
//                       return true;
//                     }else{
//                       return false;
//                     }
//                   },
//                   builder: (context, state){
//                   return BlocBuilder(
//                     bloc: reviewPostAllLMB,
//                     buildWhen:(previous, current) {
//                       if(previous!=current){
//                         return true;
//                       }else{
//                         return false;
//                       }
//                     },
//                     builder: (context, state){
//                     return reviewPostAllLMB.state.listDataMap.isNotEmpty? reviewAll.state == 0 ?
//                           GestureDetector(
//                             onTap: (){
//                                 reviewAll.changeVal(1);
//                               print(reviewAll.state);
//                             },
//                             child: Text('View All', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.w400, color:WAPrimaryColor1)),
//                           ):GestureDetector(
//                             onTap: (){
//                             reviewAll.defaultVal();
//                               print(reviewAll.state);
//                             },
//                             child: Text('Hide Other', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.w400, color:WAPrimaryColor1)),
//                           ):SizedBox();
//                   })
//                   ;
//                 })
//             ],),
//             const Divider(thickness: 3, color: WASecondary,),
//           ],):const SizedBox(),
//         SizedBox(height: 0.01*MediaQuery.of(context).size.height,),
//        BlocBuilder(
//         bloc:reviewAll,
//         buildWhen: (previous, current) {
//           if(current!=previous){
//             return true;
//           }else{
//             return false;
//           }
//         },
//         builder: (context, state){
//           return  BlocBuilder(
//           bloc: reviewPostAllLMB,
//           buildWhen: (previous, current) {
//             if(current!=previous){
//               return true;
//             }else{
//               return false;
//             }
//           },
//           builder: (context, state){
//           return Column(children: List.generate(reviewPostAllLMB.state.listDataMap.isNotEmpty? reviewAll.state == 0? 1:reviewPostAllLMB.state.listDataMap.length:0, (index) => 
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//             SizedBox(height:0.01*MediaQuery.of(context).size.height,),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//               CachedNetworkImage(
//                   imageUrl: "${reviewPostAllLMB.state.listDataMap[index]['user_img']}",
//                   imageBuilder: (context, ImageProvider)=> CircleAvatar(radius: 30, backgroundImage: MemoryImage(base64Decode(reviewPostAllLMB.state.listDataMap[index]['user_img']))),
//                   placeholder: (context, url) => SizedBox(width: 0.03*MediaQuery.of(context).size.width, height: 0.03*MediaQuery.of(context).size.width,),
//                   errorWidget: (context, url, error) => const CircleAvatar(radius: 30, backgroundImage: AssetImage('assets/img/profile_img.png')),
//               ),
//               SizedBox(width:0.03*MediaQuery.of(context).size.width,),
//               SizedBox(width: 0.4*MediaQuery.of(context).size.width, child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                 Text('${reviewPostAllLMB.state.listDataMap[index]['user_name']}', style: GoogleFonts.montserrat(fontSize:14, fontWeight: FontWeight.w700),),
//                 Text(date2(reviewPostAllLMB.state.listDataMap[index]['comment_dttm']), style: GoogleFonts.roboto(fontSize:12, fontWeight: FontWeight.w400),),
//               ],),),
//               const Spacer(),
//               SizedBox(width: 0.25*MediaQuery.of(context).size.width, child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                 Text('Rating', style: GoogleFonts.roboto(fontSize:12, fontWeight: FontWeight.w400),),
//                 SizedBox(height:0.01*MediaQuery.of(context).size.height,),
//                 Row(
//                 mainAxisAlignment: MainAxisAlignment.end,  
//                 children: List.generate(5, (index2) => Icon(Icons.star, color: (index2+1) <=int.parse(reviewPostAllLMB.state.listDataMap[index]['comment_rating'])?WAPrimaryColor1:WADisableColor, size: 18,)),),
//                 SizedBox(height:0.03*MediaQuery.of(context).size.height,),
//                 reviewPostAllLMB.state.listDataMap[index]['user_id'] == userDetailMB.state['user_id']?
//                   SizedBox(height: 0.1*MediaQuery.of(context).size.height, child: 
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                     GestureDetector(onTap: ()async{
//                            ModalText(context, 'Peringatan', 'apakah anda yakin akan menghapus komentar ini?', [
//                             IconsButton(onPressed: ()async{
//                                var data = await Api().delComment(reviewPostAllLMB.state.listDataMap[index]['comment_id'].toString());
//                                 if(data['res'] == true){
//                                   AlertText(context, WAAccentColor, WALightColor, data['msg']);
//                                     loadReviewPostIndex(postIndexMB.state['post_id'].toString());
//                                 }else{
//                                   AlertText(context, WADangerColor, WALightColor, data['msg']);
//                                 }
//                                 Navigator.pop(context);
//                             }, text: 'Ya', textStyle: GoogleFonts.poppins(color:WALightColor), color: WAAccentColor,),
//                             IconsButton(onPressed: ()async{
//                                Navigator.pop(context);
//                             }, text: 'Tidak', textStyle: GoogleFonts.poppins(color:WALightColor), color: WADangerColor,)
//                            ]);
//                     },child: Text('Hapus', style: GoogleFonts.poppins(color:WADangerColor,  fontSize:12),),),
//                     GestureDetector(onTap: ()async{
//                       ratingCB.changeVal(int.parse(reviewPostAllLMB.state.listDataMap[index]['comment_rating']));
//                       komentar.text = reviewPostAllLMB.state.listDataMap[index]['comment_txt'];
//                       idEditedComment.changeVal(int.parse(reviewPostAllLMB.state.listDataMap[index]['comment_id']));
//                     },child: Text('Edit', style: GoogleFonts.poppins(color:WAPrimaryColor2, fontSize:12),),),
//                   ],),):const SizedBox()
//               ],),)
//             ],),
//             SizedBox(height:0.005*MediaQuery.of(context).size.height,),
//             reviewPostAllLMB.state.listDataMap[index]['comment_txt'] != '' ?Text('${reviewPostAllLMB.state.listDataMap[index]['comment_txt']}', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.w400), maxLines:reviewPostAllLMB.state.listDataMap[index]['comment_txt'] == ''?1:3 ,):SizedBox(),
//             const Divider(thickness: 3, color: WASecondary,),
//           ],)
//         ),);});
//         })
//       ],)
//       ,),
//       ],
//     ); }),))
//   ,);
//   }}