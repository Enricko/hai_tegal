import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hai_tegal/components/colors.dart';
import 'package:hai_tegal/components/utils.dart';
import 'package:hai_tegal/master/category_controller.dart';
import 'package:hai_tegal/master/post_controller.dart';
import 'package:hai_tegal/service/url.dart';
import 'package:line_icons/line_icons.dart';

import '../../service/api.dart';

class DetailCategoryScreen extends StatelessWidget {
  DetailCategoryScreen({super.key});
  TextEditingController cariLokasi = TextEditingController();

  void _refresh(){
     loadPostAllCategoryInner('', categoryIndex.state['category_id'], '', '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: ()async{_refresh();}, 
        child:  SafeArea(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
      height:MediaQuery.of(context).size.height, child: SingleChildScrollView(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      SizedBox(height: 0.05*MediaQuery.of(context).size.height,),
      Text('${categoryIndex.state['category_name']}', style: GoogleFonts.poppins(fontSize: 30, fontWeight:FontWeight.w700, color:WADarkColor),),
      SizedBox(height: 0.03*MediaQuery.of(context).size.height,),
      BlocBuilder(
        bloc: categoryIndex,
        buildWhen: (previous, current) {
          if(previous!= current){
            return true;
          }else{
            return false;
          }
        },
        builder: (context, state){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 0.01*MediaQuery.of(context).size.width),
          height: 0.1 *MediaQuery.of(context).size.height, 
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: subCategoryAll.state.listDataMap.length, // total number of items
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  chooseCategoryIndex(subCategoryAll.state.listDataMap[index]);
                  loadPostAllCategoryInner('', subCategoryAll.state.listDataMap[index]['category_id'], '', '');
                },
                child: Column(children: [
              Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: 0.16*MediaQuery.of(context).size.width,
              height: 0.13*MediaQuery.of(context).size.width,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: WAInfo2Color.withOpacity(0.3)),
              child: CachedNetworkImage(
                            imageUrl: "${Url().urlPict}${subCategoryAll.state.listDataMap[index]['category_avatar']}",
                            imageBuilder: (context, ImageProvider)=> Image.network("${Url().urlPict}${subCategoryAll.state.listDataMap[index]['category_avatar']}"),
                            placeholder: (context, url) => const SizedBox(),
                            errorWidget: (context, url, error) => const Icon(Icons.car_crash_sharp)
                        ),),
              const SizedBox(height: 3,),
              Text('${subCategoryAll.state.listDataMap[index]['category_name']}', style: GoogleFonts.sourceSans3(fontSize:14, fontWeight:FontWeight.bold, color: subCategoryAll.state.listDataMap[index]['category_id'] == categoryIndex.state['category_id']?WADarkColor:WAInfo2Color),maxLines: 2,)
            ],),);
            },
          ),);
      }),
      // SizedBox(height: 0.03*MediaQuery.of(context).size.height,),
      // Text('All', style: GoogleFonts.poppins(fontSize: 20, fontWeight:FontWeight.w700, color:WADarkColor),),
      // Row(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //   SizedBox(width: 0.7*MediaQuery.of(context).size.width, child: appTextField2(context, '', cariLokasi, hint: 'Cari lokasi yang kamu mau..',),),
      //   Container(
      //     margin: EdgeInsets.only(top: 0.03*MediaQuery.of(context).size.height),
      //     width: 0.15*MediaQuery.of(context).size.width, child: IconButton(onPressed: (){
      //       print(cariLokasi.text);
      //       print(categoryIndex.state);
      //       loadPostAllCategory(cariLokasi.text, categoryIndex.state['category_id'], '', '');
      //     }, icon: const Icon(LineIcons.search, weight: 25,)),)
      // ],),
      SizedBox(height: 0.03*MediaQuery.of(context).size.height,),
      BlocBuilder(
        bloc: postSearchAll,
        buildWhen: (previous, current) {
          if(previous!= current){
            return true;
          }else{
            return false;
          }
        },
        builder: (context, state){
        return 
        postSearchAll.state.listDataMap.isNotEmpty?
        SizedBox(width: 0.9*MediaQuery.of(context).size.width, 
        height: 0.73*MediaQuery.of(context).size.height,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // number of items in each row
              mainAxisSpacing: 0, // spacing between rows
              crossAxisSpacing: 0, // spacing between columns
            ),
            padding: const EdgeInsets.all(5.0), 
        itemCount: postSearchAll.state.listDataMap.length,
        itemBuilder: (context, index){
          return GestureDetector(onTap: (){
            choosePostIndex(postSearchAll.state.listDataMap[index]);
            // loadImgPostIndex(postSearchAll.state.listDataMap[index]['post_id']);
            loadNearestPostIndex(postSearchAll.state.listDataMap[index]['venue']['venue_x_coordinat'], postSearchAll.state.listDataMap[index]['venue']['venue_y_coordinat'], '');
            // loadReviewPostIndex(postSearchAll.state.listDataMap[index]['post_id']);
            Navigator.pushNamed(context, '/detail-post');
          }, child: Stack(children: [
            postSearchAll.state.listDataMap[index]['img'].length>0?
                      CachedNetworkImage(
                            imageUrl: "${Url().urlPict}${postSearchAll.state.listDataMap[index]['img'][0]['images_file']}",
                            imageBuilder: (context, ImageProvider)=> Container(
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
                            image: DecorationImage(image: NetworkImage("${Url().urlPict}${postSearchAll.state.listDataMap[index]['img'][0]['images_file']}"),fit: BoxFit.cover)),
                            ),
                            placeholder: (context, url) => SizedBox(width: 0.03*MediaQuery.of(context).size.width, height: 0.03*MediaQuery.of(context).size.width,),
                            errorWidget: (context, url, error) => Container(
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
                            image: const DecorationImage(image: AssetImage('assets/img/default_post.jpg'),fit: BoxFit.cover)),
                            ),
                        ):Container(
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
                            image: const DecorationImage(image: AssetImage('assets/img/default_post.jpg'),fit: BoxFit.cover)),
                            ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: EdgeInsets.only(left: 6, right: 5, top: 0.145*MediaQuery.of(context).size.height),
                        height: 0.06*MediaQuery.of(context).size.height,
                        width: 0.42*MediaQuery.of(context).size.width, 
                            decoration: const BoxDecoration(color: WALightColor,borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)), ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start, children: [ 
                              SizedBox(width: 0.35*MediaQuery.of(context).size.width, child: Text('${postSearchAll.state.listDataMap[index]['post_title']}', style: GoogleFonts.montserrat(fontSize:14, fontWeight:FontWeight.w700, color:WADarkColor,), maxLines: 1,overflow: TextOverflow.ellipsis),),
                              SizedBox(width: 0.35*MediaQuery.of(context).size.width, child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                postSearchAll.state.listDataMap[index]['venue'] != null && postSearchAll.state.listDataMap[index]['venue'].length >0  && latitudeUserCB.state != '' && longitudeUserCB.state != ''?
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.location_on, color: WAPrimaryColor1, size: 15,), const SizedBox(width: 5,),Text('${(calculateDistance(double.parse(latitudeUserCB.state), double.parse(longitudeUserCB.state), double.parse(postSearchAll.state.listDataMap[index]['venue']['venue_x_coordinat'].toString()), double.parse(postSearchAll.state.listDataMap[index]['venue']['venue_y_coordinat'].toString()))).toStringAsFixed(0)} km', style: GoogleFonts.roboto(fontSize:10, color:WADarkColor, fontWeight: FontWeight.normal),),],):const SizedBox(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('${postSearchAll.state.listDataMap[index]['total_review'] != 0? double.parse((int.parse(postSearchAll.state.listDataMap[index]['total_review'].toString())/int.parse(postSearchAll.state.listDataMap[index]['total_index'].toString())).toString()).toStringAsFixed(2):0}', style: GoogleFonts.poppins(fontSize:10, color: WADarkColor),),
                                    SizedBox(width: 5,),
                                    Icon(Icons.star, color: WAPrimaryColor1, size: 15,),
                                  ],)
                              ],) ,)  
                              ],),
                            ],),),
                        ],),)
                    ;})):Align(alignment: Alignment.center,child: Padding(padding: const EdgeInsets.only(top: 10), child: Text('Data tidak tersedia', style: GoogleFonts.montserrat(fontSize:12),),),);
      }),
    ],),),),)),),);
  }
}