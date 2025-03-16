import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_custom_slider/carousel_custom_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hai_tegal/components/colors.dart';
import 'package:hai_tegal/components/utils.dart';
import 'package:hai_tegal/master/category_controller.dart';
import 'package:hai_tegal/master/home_controller.dart';
import 'package:hai_tegal/master/post_controller.dart';
import 'package:hai_tegal/master/saved_controller.dart';
import 'package:hai_tegal/screen.dart';
import 'package:hai_tegal/service/url.dart';
import 'package:line_icons/line_icons.dart';

import '../../master/tags_controller.dart';
import '../../service/api.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  TextEditingController cariAllHome = TextEditingController();

  void loadUlang(){
  if(bannerAllLMB.state.listDataMap.isEmpty){
    loadBanner();
  }
  if(categoryAllLMB.state.listDataMap.isEmpty){
    loadCategory('', '0');
  }
  if(postAllLMB.state.listDataMap.isEmpty){
     loadPost('', '', '10', '0');
  }
  if(allTagsPost.state.listDataMap.isEmpty){
   loadTagPost('');
  }

  loadHome(); 


  if(homeContentAll.state.listDataMap.isNotEmpty){
    for(int i = 0; i < homeContentAll.state.listDataMap.length; i++){
      loadCategoryHome(homeListContent[i], homeContentAll.state.listDataMap[i]['limit_data'].toString(), homeContentAll.state.listDataMap[i]['category_id'].toString());
    }
  }

  }

  void loadAll(){
    // loadBanner();
  // loadBanner();
  loadCategory('', '0');
  loadPost('', '', '10', '0');
  loadTagPost('');
  loadEvent();
  for(int i = 0; i < homeContentAll.state.listDataMap.length; i++){
      loadCategoryHome(homeListContent[i], homeContentAll.state.listDataMap[i]['limit_data'].toString(), homeContentAll.state.listDataMap[i]['category_id'].toString());
    }
  }

  

  @override
  Widget build(BuildContext context) {
    loadAll();
    print(homeContentAll.state.listDataMap);
    print(penginapanPostAllLMB.state.listDataMap);
    loadLocation(context, latitudeUser, longitudeUser);
    return  Scaffold(
      bottomNavigationBar: SizedBox(height: 0.08*MediaQuery.of(context).size.height, child: BottomBarBubble(
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
      ),),
      body:
      RefreshIndicator(onRefresh: ()async{
        loadUlang();
      }, child: SizedBox(width: MediaQuery.of(context).size.width, height:  MediaQuery.of(context).size.height, 
      child: BlocBuilder(
        bloc: homeContentAll,
        buildWhen: (previous, current) {
                if(previous!=current){
                  return true;
                }else{
                  return false;
                }
              },
        builder: (context, state){
        return SingleChildScrollView(child: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 0.4*MediaQuery.of(context).size.height, child: 
          Stack(children: [
            BlocBuilder(
              bloc: bannerAllLMB,
              buildWhen: (previous, current) {
                if(previous!=current){
                  return true;
                }else{
                  return false;
                }
              },
              builder: (context, state){
              return 
              bannerAllLMB.state.listDataMap.isNotEmpty?
              CarouselCustomSlider(
              initialPage: initPage.state,
              isDisplayIndicator: false,
              allowImplicitScrolling: true,
              backgroundColor: WAPrimaryColor1,
                doubleTapZoom: true,
                clipBehaviorZoom: true,
                autoPlay: true,
                height: 0.4*MediaQuery.of(context).size.height,
                sliderList: List.generate(bannerAllLMB.state.listDataMap.length, (index) => "${Url().urlPict}${bannerAllLMB.state.listDataMap[index]['banner_file']}"),
                fitPic:BoxFit.cover
            ):CarouselCustomSlider(
              isDisplayIndicator: false,
              allowImplicitScrolling: true,
              backgroundColor: WAPrimaryColor1,
                doubleTapZoom: true,
                clipBehaviorZoom: true,
                autoPlay: false,
                height: 0.4*MediaQuery.of(context).size.height,
                sliderList: sliderListImage,
                fitPic:BoxFit.cover
            )
            ;}),
            // Padding(padding: EdgeInsets.only(top: 0.35*MediaQuery.of(context).size.height, left: 0.8*MediaQuery.of(context).size.width
            // ), child: 
            //   Row(children: List.generate(imgPostAllLMB.state.listDataMap.length, (index) => GestureDetector(onTap: (){ initPage.changeVal(index);}, 
            //   child: Padding(padding: EdgeInsets.symmetric(horizontal: 1), child: CircleAvatar(backgroundColor: index == initPage?WAPrimaryColor1:WASecondary, radius: 4,),),)),)
            // ,),
            Padding(
                padding: EdgeInsets.only(top:0.06*MediaQuery.of(context).size.height, left: 0.08*MediaQuery.of(context).size.width, right: 0.08*MediaQuery.of(context).size.width),
                child: Material(
                  elevation: 20.0,
                  shadowColor: WADarkColor,
                  color: Colors.transparent,
                  child: TextField(
                  autofocus: false,
                  controller: cariAllHome,
                  style: GoogleFonts.roboto(fontSize:16, fontWeight: FontWeight.w400, color:WADarkColor),
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(onTap: (){
                      loadHomeSearchPostAll(context,cariAllHome.text, '', '', '0');
                      loadTagPost(cariAllHome.text);
                    }, child: const Icon(Icons.search, color: WASecondary,),),
                    border: InputBorder.none,
                    hintText: 'Mau jalan-jalan kemana hari ini ?',
                    hintStyle: GoogleFonts.roboto(fontSize:14, fontWeight: FontWeight.w400, color:WASecondary),
                    filled: true,
                    fillColor: WALightColor,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 11, horizontal: 20),
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
          ],),),
          SizedBox(height: 0.05*MediaQuery.of(context).size.height,),
          BlocBuilder(
                bloc: homeSearchPostAll,
                buildWhen:(previous, current) {
                  if(previous!=current){
                    return true;
                  }else{
                    return false;
                  }
                },
                builder: (context, state){
                return 
                homeSearchPostAll.state.listDataMap.isNotEmpty?
                Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text('Pencarian Anda', style: GoogleFonts.montserrat(fontSize:16, fontWeight:FontWeight.bold, color:WADarkColor),),
                  GestureDetector(onTap: (){
                    homeSearchPostAll.removeAll();
                  }, child: Text('Hapus Pencarian', style: GoogleFonts.montserrat(fontSize:12, fontWeight:FontWeight.bold, color:WADangerColor),),)
                ],),
                SizedBox(height: 0.01*MediaQuery.of(context).size.height),
                SizedBox(height: 0.32*MediaQuery.of(context).size.height, child: 
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:homeSearchPostAll.state.listDataMap.length,
                  itemBuilder: (context, index){
                    return GestureDetector(onTap: (){
                       choosePostIndex(homeSearchPostAll.state.listDataMap[index]);
                      homeSearchPostAll.state.listDataMap[index]['venue']!=null&&homeSearchPostAll.state.listDataMap[index]['venue'].length>0? loadNearestPostIndex(homeSearchPostAll.state.listDataMap[index]['venue']['venue_x_coordinat'], homeSearchPostAll.state.listDataMap[index]['venue']['venue_y_coordinat'], ''):(){};
                      loadReviewPostIndex(homeSearchPostAll.state.listDataMap[index]['post_id']);
                      Navigator.pushNamed(context, '/detail-post');
                    }, child: Stack(children: [
                      homeSearchPostAll.state.listDataMap[index]['img'].length>0?
                      CachedNetworkImage(
                            imageUrl: "${Url().urlPict}${homeSearchPostAll.state.listDataMap[index]['img'][0]['images_file']}",
                            imageBuilder: (context, ImageProvider)=> Container(
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
                            image: DecorationImage(image: NetworkImage('${Url().urlPict}${homeSearchPostAll.state.listDataMap[index]['img'][0]['images_file']}'),fit: BoxFit.cover)),
                            ),
                            placeholder: (context, url) => SizedBox(width: 0.03*MediaQuery.of(context).size.width, height: 0.03*MediaQuery.of(context).size.width),
                            errorWidget: (context, url, error) => Container(
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
                            image: const DecorationImage(image: AssetImage('assets/img/default_post.jpg'),fit: BoxFit.cover)),
                            ),
                        ):Container(
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
                            image: const DecorationImage(image: AssetImage('assets/img/default_post.jpg'),fit: BoxFit.cover)),
                            ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: EdgeInsets.only(left: 5, right: 5, top:  0.168*MediaQuery.of(context).size.height),
                        height: 0.08*MediaQuery.of(context).size.height,
                        width: 0.4*MediaQuery.of(context).size.width, 
                            decoration: const BoxDecoration(color: WALightColor,borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)), ),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ 
                              Text('${homeSearchPostAll.state.listDataMap[index]['post_title']}', style: GoogleFonts.montserrat(fontSize:12, fontWeight:FontWeight.w700, color:WADarkColor),maxLines: 2,),
                              Text('${homeSearchPostAll.state.listDataMap[index]['post_short']}', style: GoogleFonts.roboto(fontSize:10, fontWeight:FontWeight.normal, color:WADarkColor), maxLines: 1,),
                              // Text('Keterangan event ke-${index}', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.normal, color:WADarkColor),),
                              ],),),
                        ],),);
                    }),)
                ],),):const SizedBox();
              }),
          BlocBuilder(
          bloc: categoryAllLMB,
          buildWhen: (previous, current) {
                if(previous!=current){
                  return true;
                }else{
                  return false;
                }
          },
          builder: (context, state){return Container(
          padding: EdgeInsets.symmetric(horizontal: 0.05*MediaQuery.of(context).size.width),
          height: 0.15 *MediaQuery.of(context).size.height, 
          // width: 0.8*MediaQuery.of(context).size.width,
          child:ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoryAllLMB.state.listDataMap.length,
            itemBuilder: (context, index){
            return GestureDetector(
              onTap: (){
              loadSubCategory('', categoryAllLMB.state.listDataMap[index]['category_id']);
              // loadPostAllCategoryInner('',categoryAllLMB.state.listDataMap[index]['category_id'], '', '');
              chooseCategoryIndex(categoryAllLMB.state.listDataMap[index]);
              loadPostNearestUser(categoryIndex.state['category_id']);
              loadPostHighest(categoryIndex.state['category_id']);
              loadPostFeatured();

              Navigator.pushNamed(context, '/category');},
              child: SizedBox(
              width: 0.2*MediaQuery.of(context).size.width,
              height: 0.2*MediaQuery.of(context).size.height,
              child: Column(children: [
              Container(
                alignment: Alignment.center,
              width: 0.16*MediaQuery.of(context).size.width,
              height: 0.15*MediaQuery.of(context).size.width,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: WAInfo2Color.withOpacity(0.3)),
              child: CachedNetworkImage(
                            imageUrl: "${Url().urlPict}${categoryAllLMB.state.listDataMap[index]['category_avatar']}",
                            imageBuilder: (context, ImageProvider)=> Image.network("${Url().urlPict}${categoryAllLMB.state.listDataMap[index]['category_avatar']}"),
                            placeholder: (context, url) => const SizedBox(),
                            errorWidget: (context, url, error) => const Icon(Icons.beach_access_sharp)
                        ),),
              const SizedBox(height: 3,),
              Text(spaceBetweenWord(categoryAllLMB.state.listDataMap[index]['category_name']), style: GoogleFonts.sourceSans3(fontSize:14, fontWeight:FontWeight.bold, color:WAInfo2Color), maxLines: 2, textAlign: TextAlign.center,)
            ],),),);
          })
          );}),
          // SelectableText(latitudeUser.state),
          // SelectableText(longitudeUser.state),
          SizedBox(height: 0.03*MediaQuery.of(context).size.height,),
          // GestureDetector(onTap: (){
          //   ModalContainer(context, 'Seluruh Kategori', SizedBox(
          //     height: 0.4 *MediaQuery.of(context).size.height, 
          //     width:MediaQuery.of(context).size.width, 
          //     child: GridView.builder(
          //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //         crossAxisCount: 3, // number of items in each row
          //         mainAxisSpacing: 0, // spacing between rows
          //         crossAxisSpacing: 0, // spacing between columns
          //       ),
          //       padding: const EdgeInsets.all(0), // padding around the grid
          //       itemCount: categoryAllLMB.state.listDataMap.length, // total number of items
          //       itemBuilder: (context, index) {
          //         return GestureDetector(
          //             onTap: (){
          //             chooseCategoryIndex(categoryAllLMB.state.listDataMap[index]);
          //             loadSubCategory('', categoryAllLMB.state.listDataMap[index]['category_id']);
          //             loadPostAllCategory('',categoryAllLMB.state.listDataMap[index]['category_id'], '', '');
          //             Navigator.pushNamed(context, '/category');},
          //             child: Column(children: [
          //             Container(
          //             alignment: Alignment.center,
          //             width: 0.16*MediaQuery.of(context).size.width,
          //             height: 0.16*MediaQuery.of(context).size.width,
          //             decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: WAInfo2Color.withOpacity(0.3)),
          //             child:  CachedNetworkImage(
          //                   imageUrl: "${Url().urlPict}${categoryAllLMB.state.listDataMap[index]['category_avatar']}",
          //                   imageBuilder: (context, ImageProvider)=> Image.network("${Url().urlPict}${categoryAllLMB.state.listDataMap[index]['category_avatar']}"),
          //                   placeholder: (context, url) => const SizedBox(),
          //                   errorWidget: (context, url, error) => const Icon(Icons.beach_access)
          //             ),),
          //             const SizedBox(height: 3,),
          //             Text(categoryAllLMB.state.listDataMap[index]['category_name'], style: GoogleFonts.sourceSans3(fontSize:14, fontWeight:FontWeight.bold, color:WAInfo2Color), maxLines: 2, textAlign: TextAlign.center,),
          //             const SizedBox(height: 5,),
          //           ],),);
          //       },
          //     ),), []);
          //  }, child: Center(child:  Text('Cari lebih Banyak?', style: GoogleFonts.sourceSans3(fontSize:14, fontWeight:FontWeight.w600, color:WADangerColor,decoration: TextDecoration.underline, decorationColor:WADangerColor),),),),
          SizedBox(height: 0.03*MediaQuery.of(context).size.height,),
          BlocBuilder(
            bloc: wisataPostAllLMB,
            buildWhen: (previous, current) {
                  if(previous!=current){
                    return true;
                  }else{
                    return false;
                  }
            },
            builder: (context, state){return Padding(padding: const EdgeInsets.only(left: 20), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(homeContentAll.state.listDataMap[0]['title_home'], style: GoogleFonts.montserrat(fontSize:19, fontWeight:FontWeight.bold, color:WADarkColor),),
              const SizedBox(height: 5,),
              SizedBox(height: 0.2*MediaQuery.of(context).size.height, child: 
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: wisataPostAllLMB.state.listDataMap.length,
                  itemBuilder: (context, index){
                    // print('${Url().urlPict}${wisataPostAllLMB.state.listDataMap[index]['img'][0]['images_file']}'??'');
                    return 
                    wisataPostAllLMB.state.listDataMap[index]['img'].length >0?
                    GestureDetector(onTap: (){
                      choosePostIndex(wisataPostAllLMB.state.listDataMap[index]);
                      wisataPostAllLMB.state.listDataMap[index]['venue']!=null&&wisataPostAllLMB.state.listDataMap[index]['venue'].length>0? loadNearestPostIndex(wisataPostAllLMB.state.listDataMap[index]['venue']['venue_x_coordinat'], wisataPostAllLMB.state.listDataMap[index]['venue']['venue_y_coordinat'], ''):(){};
                      loadReviewPostIndex(wisataPostAllLMB.state.listDataMap[index]['post_id']);
                      Navigator.pushNamed(context, '/detail-post');
                    }, child: CachedNetworkImage(
                            imageUrl: "${Url().urlPict}${wisataPostAllLMB.state.listDataMap[index]['img'][0]['images_file']}",
                            imageBuilder: (context, ImageProvider)=> Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                height: 0.2*MediaQuery.of(context).size.height,
                                width: 0.8*MediaQuery.of(context).size.width, 
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), 
                                image: DecorationImage(image: 
                                  NetworkImage('${Url().urlPict}${wisataPostAllLMB.state.listDataMap[index]['img'][0]['images_file']}'??''),fit: BoxFit.cover)
                                ),
                                child: Padding(padding: const EdgeInsets.only(left: 20, top: 20), child: Text('${wisataPostAllLMB.state.listDataMap[index]['post_title']}', style: GoogleFonts.poppins(fontSize:18, fontWeight:FontWeight.w700, color:WALightColor),),),
                                ),
                            placeholder: (context, url) => const SizedBox(),
                            errorWidget: (context, url, error) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                height: 0.2*MediaQuery.of(context).size.height,
                                width: 0.8*MediaQuery.of(context).size.width, 
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), 
                                image: const DecorationImage(image: 
                                  AssetImage('assets/img/default_post.jpg'),fit: BoxFit.cover)
                                ),
                                child: Padding(padding: const EdgeInsets.only(left: 20, top: 20), child: Text('${wisataPostAllLMB.state.listDataMap[index]['post_title']}', style: GoogleFonts.poppins(fontSize:18, fontWeight:FontWeight.w700, color:WALightColor),),),
                                ),
                        )):Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                height: 0.2*MediaQuery.of(context).size.height,
                                width: 0.8*MediaQuery.of(context).size.width, 
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), 
                                image: const DecorationImage(image: 
                                  AssetImage('assets/img/default_post.jpg'),fit: BoxFit.cover)
                                ),
                                child: Padding(padding: const EdgeInsets.only(left: 20, top: 20), child: Text('${wisataPostAllLMB.state.listDataMap[index]['post_title']}', style: GoogleFonts.poppins(fontSize:18, fontWeight:FontWeight.w700, color:WALightColor),),),
                                );
                    }),)
            ],),);}),
          SizedBox(height: 0.05*MediaQuery.of(context).size.height,),
          BlocBuilder(
            bloc: jelajahPostAllLMB,
            buildWhen: (previous, current) {
                  if(previous!=current){
                    return true;
                  }else{
                    return false;
                  }
            },
            builder: (context, state){return Padding(padding: const EdgeInsets.only(left: 20), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(homeContentAll.state.listDataMap[1]['title_home'], style: GoogleFonts.montserrat(fontSize:19, fontWeight:FontWeight.bold, color:WADarkColor),),
              const SizedBox(height: 5,),
              SizedBox(height: 0.3*MediaQuery.of(context).size.height, child: 
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: jelajahPostAllLMB.state.listDataMap.length,
                  itemBuilder: (context, index){return 
                  GestureDetector(onTap: (){
                      choosePostIndex(jelajahPostAllLMB.state.listDataMap[index]);
                      jelajahPostAllLMB.state.listDataMap[index]['venue']!=null&&jelajahPostAllLMB.state.listDataMap[index]['venue'].length>0? loadNearestPostIndex(jelajahPostAllLMB.state.listDataMap[index]['venue']['venue_x_coordinat'], jelajahPostAllLMB.state.listDataMap[index]['venue']['venue_y_coordinat'], ''):(){};
                      loadReviewPostIndex(jelajahPostAllLMB.state.listDataMap[index]['post_id']);
                      Navigator.pushNamed(context, '/detail-post');
                    },child: 
                      jelajahPostAllLMB.state.listDataMap[index]['img'] !=  null && jelajahPostAllLMB.state.listDataMap[index]['img'].length >0?
                      CachedNetworkImage(
                            imageUrl: "${Url().urlPict}${jelajahPostAllLMB.state.listDataMap[index]['img'][0]['images_file']}",
                            imageBuilder: (context, ImageProvider)=> Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                height: 0.3*MediaQuery.of(context).size.height,
                                width: 0.4*MediaQuery.of(context).size.width, 
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), 
                                image: DecorationImage(image: NetworkImage('${Url().urlPict}${jelajahPostAllLMB.state.listDataMap[index]['img'][0]['images_file']}'??''),fit: BoxFit.cover)),
                                child: Padding(padding: EdgeInsets.only(left: 20, top:  0.2*MediaQuery.of(context).size.height), child: Text('${jelajahPostAllLMB.state.listDataMap[index]['post_title']}', style: GoogleFonts.montserrat(fontSize:18, fontWeight:FontWeight.w700, color:WALightColor),),),
                                ),
                            placeholder: (context, url) => const SizedBox(),
                            errorWidget: (context, url, error) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            height: 0.3*MediaQuery.of(context).size.height,
                            width: 0.4*MediaQuery.of(context).size.width, 
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), 
                            image: const DecorationImage(image: AssetImage('assets/img/default_post.jpg'),fit: BoxFit.cover)),
                            child: Padding(padding: EdgeInsets.only(left: 20, top:  0.2*MediaQuery.of(context).size.height), child: Text('${jelajahPostAllLMB.state.listDataMap[index]['post_title']}', style: GoogleFonts.montserrat(fontSize:18, fontWeight:FontWeight.w700, color:WALightColor),),),
                            )
                            ):Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 5),
                                      height: 0.3*MediaQuery.of(context).size.height,
                                      width: 0.4*MediaQuery.of(context).size.width, 
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), 
                                      image: const DecorationImage(image: AssetImage('assets/img/default_post.jpg'),fit: BoxFit.cover)),
                                      child: Padding(padding: EdgeInsets.only(left: 20, top:  0.2*MediaQuery.of(context).size.height), child: Text('${jelajahPostAllLMB.state.listDataMap[index]['post_title']}', style: GoogleFonts.montserrat(fontSize:18, fontWeight:FontWeight.w700, color:WALightColor),),),
                            ),
                  );
                    }),)
            ],),);}),
          SizedBox(height: 0.05*MediaQuery.of(context).size.height,),
          BlocBuilder(
            bloc: kulinerPostAllLMB,
            buildWhen: (previous, current) {
                  if(previous!=current){
                    return true;
                  }else{
                    return false;
                  }
            },
            builder: (context, state){return Padding(padding: const EdgeInsets.only(left: 20), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(homeContentAll.state.listDataMap[2]['title_home'], style: GoogleFonts.montserrat(fontSize:19, fontWeight:FontWeight.bold, color:WADarkColor),),
              const SizedBox(height: 5,),
               kulinerPostAllLMB.state.listDataMap.isNotEmpty?
              SizedBox(height: 0.25*MediaQuery.of(context).size.height, child: 
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: kulinerPostAllLMB.state.listDataMap.length,
                  itemBuilder: (context, index){
                  return GestureDetector(onTap: (){
                    print(kulinerPostAllLMB.state.listDataMap[index]);
                    choosePostIndex(kulinerPostAllLMB.state.listDataMap[index]);
                      kulinerPostAllLMB.state.listDataMap[index]['venue']!=null&&kulinerPostAllLMB.state.listDataMap[index]['venue'].length>0?loadNearestPostIndex(kulinerPostAllLMB.state.listDataMap[index]['venue']['venue_x_coordinat']??0, kulinerPostAllLMB.state.listDataMap[index]['venue']['venue_y_coordinat']??0,''):(){};
                      loadReviewPostIndex(kulinerPostAllLMB.state.listDataMap[index]['post_id']);
                      Navigator.pushNamed(context, '/detail-post');
                    },
                      child: kulinerPostAllLMB.state.listDataMap[index]['img'].length >0?
                  CachedNetworkImage(
                            imageUrl: "${Url().urlPict}${kulinerPostAllLMB.state.listDataMap[index]['img'][0]['images_file']}",
                            imageBuilder: (context, ImageProvider)=> Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              height: 0.25*MediaQuery.of(context).size.height,
                              width: 0.8*MediaQuery.of(context).size.width, 
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), 
                              image: DecorationImage(image: NetworkImage('${Url().urlPict}${kulinerPostAllLMB.state.listDataMap[index]['img'][0]['images_file']}'??''),fit: BoxFit.cover)),
                              child: Padding(padding: const EdgeInsets.only(left: 20, top: 20), child: Text('${kulinerPostAllLMB.state.listDataMap[index]['post_title']}', style: GoogleFonts.montserrat(fontSize:18, fontWeight:FontWeight.w700, color:WALightColor),),),
                              ),
                            placeholder: (context, url) => const SizedBox(),
                            errorWidget: (context, url, error) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              height: 0.25*MediaQuery.of(context).size.height,
                              width: 0.8*MediaQuery.of(context).size.width, 
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), 
                              image: const DecorationImage(image: AssetImage('assets/img/default_post.jpg'),fit: BoxFit.cover)),
                              child: Padding(padding: const EdgeInsets.only(left: 20, top: 20), child: Text('${kulinerPostAllLMB.state.listDataMap[index]['post_title']}', style: GoogleFonts.montserrat(fontSize:18, fontWeight:FontWeight.w700, color:WALightColor),),),
                              )
                  ):Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              height: 0.25*MediaQuery.of(context).size.height,
                              width: 0.8*MediaQuery.of(context).size.width, 
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), 
                              image: const DecorationImage(image: AssetImage('assets/img/default_post.jpg'),fit: BoxFit.cover)),
                              child: Padding(padding: const EdgeInsets.only(left: 20, top: 20), child: Text('${kulinerPostAllLMB.state.listDataMap[index]['post_title']}', style: GoogleFonts.montserrat(fontSize:18, fontWeight:FontWeight.w700, color:WALightColor),),),
                              ),
                  );
                    }),): Align(alignment: Alignment.center,child: Padding(padding: const EdgeInsets.only(top: 10), child: Text('Data tidak tersedia', style: GoogleFonts.montserrat(fontSize:12),),),)
            ],),);}),
          SizedBox(height: 0.05*MediaQuery.of(context).size.height,),
          BlocBuilder(
            bloc: eventPostAllLMB,
            buildWhen: (previous, current) {
                  if(previous!=current){
                    return true;
                  }else{
                    return false;
                  }
            },
            builder: (context, state){return Padding(padding: const EdgeInsets.only(left: 20), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(homeContentAll.state.listDataMap[3]['title_home'], style: GoogleFonts.montserrat(fontSize:19, fontWeight:FontWeight.bold, color:WADarkColor),),
              const SizedBox(height: 5,),
               eventPostAllLMB.state.listDataMap.isNotEmpty?
              SizedBox(height: 0.32*MediaQuery.of(context).size.height, child: 
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: eventPostAllLMB.state.listDataMap.length,
                  itemBuilder: (context, index){
                    return GestureDetector(onTap:(){
                      choosePostIndex(eventPostAllLMB.state.listDataMap[index]);
                      eventPostAllLMB.state.listDataMap[index]['venue']!=null&&eventPostAllLMB.state.listDataMap[index]['venue'].length>0? loadNearestPostIndex(eventPostAllLMB.state.listDataMap[index]['venue']['venue_x_coordinat'], eventPostAllLMB.state.listDataMap[index]['venue']['venue_y_coordinat'], ''):(){};
                      loadReviewPostIndex(eventPostAllLMB.state.listDataMap[index]['post_id']);
                      Navigator.pushNamed(context, '/detail-post');
                    },
                    child: Stack(children: [
                      eventPostAllLMB.state.listDataMap[index]['img'] != null && eventPostAllLMB.state.listDataMap[index]['img'].length >0?
                      CachedNetworkImage(
                            imageUrl: "${Url().urlPict}${eventPostAllLMB.state.listDataMap[index]['img'][0]['images_file']??''}",
                            imageBuilder: (context, ImageProvider)=> Container(
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
                            image: DecorationImage(image: NetworkImage('${Url().urlPict}${eventPostAllLMB.state.listDataMap[index]['img'][0]['images_file']}'),fit: BoxFit.cover)),
                            ),
                            placeholder: (context, url) => const SizedBox(),
                            errorWidget: (context, url, error) => Container(
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
                        image: const DecorationImage(image: AssetImage('assets/img/default_post.jpg'),fit: BoxFit.cover)),
                        )
                      ):Container(
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
                        image: const DecorationImage(image: AssetImage('assets/img/default_post.jpg'),fit: BoxFit.cover)),
                        ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: EdgeInsets.only(left: 5, right: 5, top:  0.22*MediaQuery.of(context).size.height),
                        height: 0.08*MediaQuery.of(context).size.height,
                        width: 0.7*MediaQuery.of(context).size.width, 
                            decoration: const BoxDecoration(color: WALightColor,borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)), ),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ 
                              Text('${eventPostAllLMB.state.listDataMap[index]['post_title']}', style: GoogleFonts.montserrat(fontSize:18, fontWeight:FontWeight.w700, color:WADarkColor),),
                              Text('${eventPostAllLMB.state.listDataMap[index]['post_short']}',maxLines: 1, style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.normal, color:WADarkColor),),
                              // Text('Keterangan event ke-${index}', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.normal, color:WADarkColor),),
                              ],),),
                        ],),
                    );
                    }),):
            Align(alignment: Alignment.center,child: Padding(padding: const EdgeInsets.only(top: 10), child: Text('Data tidak tersedia', style: GoogleFonts.montserrat(fontSize:12),),),)
            ],),);}),
          SizedBox(height: 0.05*MediaQuery.of(context).size.height,),
          BlocBuilder(
              bloc: allTagsPost,
              buildWhen: (previous, current) {
                if(current!=null){
                  return true;
                }else{
                  return false;
                }
              },
              builder: (context, state){
            return 
            allTagsPost.state.listDataMap.isNotEmpty?
            Container(
            width: MediaQuery.of(context).size.width,
            height: 0.05*MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 20), 
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: allTagsPost.state.listDataMap.length,
              itemBuilder: (context, index){return GestureDetector(onTap: (){
                // loadHomeSearchPostAll(context,'${allTagsPost.state.listDataMap[index]['tags_name']}', '', '', '0');
                tagIndex.changeVal(allTagsPost.state.listDataMap[index]);
                Navigator.pushNamed(context, '/tags');
              }, child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        height: 0.03*MediaQuery.of(context).size.height, 
                      decoration: BoxDecoration(border: Border.all(color: WATagColor, width: 1), color: WALightColor, borderRadius: BorderRadius.circular(30)),
                        child: 
                          Row(children: [
                            // Icon(LineIcons.home, size: 18, color: WATagColor,), 
                            const SizedBox(width: 3,),
                            Text('${allTagsPost.state.listDataMap[index]['tags_name']}', style: GoogleFonts.sourceSans3(fontSize:14, color:WATagColor, fontWeight: FontWeight.bold),),
                             const SizedBox(width: 3,),
                          ],)),);}),)
            :const SizedBox();}),
          SizedBox(height: 0.05*MediaQuery.of(context).size.height,),
          BlocBuilder(
            bloc: penginapanPostAllLMB,
            buildWhen: (previous, current) {
                if(current!=null){
                  return true;
                }else{
                  return false;
                }
              },
            builder: (context, state){
            return Padding(padding: const EdgeInsets.only(left: 20), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(homeContentAll.state.listDataMap[4]['title_home'], style: GoogleFonts.montserrat(fontSize:19, fontWeight:FontWeight.bold, color:WADarkColor),),
              const SizedBox(height: 5,),
              penginapanPostAllLMB.state.listDataMap.isNotEmpty?
              Column(
                children: List.generate(penginapanPostAllLMB.state.listDataMap.length, (index) => GestureDetector(
                  onTap: (){
                      choosePostIndex(penginapanPostAllLMB.state.listDataMap[index]);
                      penginapanPostAllLMB.state.listDataMap[index]['venue']!=null&&penginapanPostAllLMB.state.listDataMap[index]['venue'].length>0? loadNearestPostIndex(penginapanPostAllLMB.state.listDataMap[index]['venue']['venue_x_coordinat'], penginapanPostAllLMB.state.listDataMap[index]['venue']['venue_y_coordinat'],''):(){};
                      loadReviewPostIndex(penginapanPostAllLMB.state.listDataMap[index]['post_id']);
                      Navigator.pushNamed(context, '/detail-post');
                  }, 
                  child: Container(
                      margin: const EdgeInsets.only(top: 10, right: 10),
                      padding: EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: WASecondary), ),
                    width:MediaQuery.of(context).size.width,  
                    height: 0.2*MediaQuery.of(context).size.height,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      penginapanPostAllLMB.state.listDataMap[index]['img'] != null && penginapanPostAllLMB.state.listDataMap[index]['img'].length >0?
                      CachedNetworkImage(
                            imageUrl: "${Url().urlPict}${penginapanPostAllLMB.state.listDataMap[index]['img'][0]['images_file']??''}",
                            imageBuilder: (context, ImageProvider)=> Container(
                            // margin: const EdgeInsets.symmetric(horizontal: 5,),
                            height: 0.2*MediaQuery.of(context).size.height,
                            width: 0.3*MediaQuery.of(context).size.width, 
                            decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                            image: DecorationImage(image: NetworkImage('${Url().urlPict}${penginapanPostAllLMB.state.listDataMap[index]['img'][0]['images_file']}'),fit: BoxFit.fill)),
                            ),
                            placeholder: (context, url) => const SizedBox(),
                            errorWidget: (context, url, error) => Container(
                          // margin: const EdgeInsets.symmetric(horizontal: 5,),
                          height: 0.2*MediaQuery.of(context).size.height,
                          width: 0.3*MediaQuery.of(context).size.width, 
                          decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                          image: DecorationImage(image: AssetImage('assets/img/default_post.jpg'),fit: BoxFit.fill)),
                          )
                      ):Container(
                          // margin: const EdgeInsets.symmetric(horizontal: 5,),
                          height: 0.2*MediaQuery.of(context).size.height,
                          width: 0.3*MediaQuery.of(context).size.width, 
                          decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                          image: DecorationImage(image: AssetImage('assets/img/default_post.jpg'),fit: BoxFit.fill)),
                          ),
                      SizedBox(width: 0.03*MediaQuery.of(context).size.width,),
                      SizedBox(width: 0.55*MediaQuery.of(context).size.width, child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text('${penginapanPostAllLMB.state.listDataMap[index]['post_title']}', style: GoogleFonts.montserrat(fontSize:16, color:WADarkColor, fontWeight: FontWeight.bold),),
                        Text('${penginapanPostAllLMB.state.listDataMap[index]['venue']['venue_addr']}', style: GoogleFonts.roboto(fontSize:12, color:WADarkColor, fontWeight: FontWeight.normal),)
                        ],),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          penginapanPostAllLMB.state.listDataMap[index]['venue']!=null&&penginapanPostAllLMB.state.listDataMap[index]['venue'].length>0 && latitudeUserCB.state != '' && longitudeUserCB.state != ''?
                          Row(children: [const Icon(Icons.location_on, color: WAPrimaryColor1, size: 15,), const SizedBox(width: 5,),Text('${(calculateDistance(double.parse(latitudeUserCB.state), double.parse(longitudeUserCB.state), double.parse(penginapanPostAllLMB.state.listDataMap[index]['venue']['venue_x_coordinat'].toString()), double.parse(penginapanPostAllLMB.state.listDataMap[index]['venue']['venue_y_coordinat'].toString()))).toStringAsFixed(0)} km', style: GoogleFonts.roboto(fontSize:12, color:WADarkColor, fontWeight: FontWeight.normal),),],):const SizedBox(),
                          Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(Icons.star, color: WAWarningColor, size: 15,),
                                    SizedBox(width: 5,),
                                    Text('${penginapanPostAllLMB.state.listDataMap[index]['total_review'] != 0? double.parse((int.parse(penginapanPostAllLMB.state.listDataMap[index]['total_review'].toString())/int.parse(penginapanPostAllLMB.state.listDataMap[index]['total_index'].toString())).toString()).toStringAsFixed(2):0}', style: GoogleFonts.poppins(fontSize:12, color: WADarkColor),),
                                    // SizedBox(width: 5,),
                                    // Row(children: List.generate(3, (index) => Icon(Icons.star, color: WAWarningColor, size: 15,)),),
                          ],),
                          SizedBox(height: 0.01*MediaQuery.of(context).size.height,),
                          // penginapanPostAllLMB.state.listDataMap[index]['average_rating'] > 0?Row(children: List.generate(5, (index) => Icon(Icons.star, color: (1+index) <= ((penginapanPostAllLMB.state.listDataMap[index]['average_rating']).truncate())?WAPrimaryColor1:WADisableColor, size: 15,)),):Row(children: List.generate(5, (index) => Icon(Icons.star, color: WADisableColor, size: 15,)),),
                          Text('${penginapanPostAllLMB.state.listDataMap[index]['total_index']} reviews', style: GoogleFonts.roboto(fontSize:12, color:WADisableColor, fontWeight: FontWeight.normal),)
                          ],),
                          SizedBox(width: 0.1*MediaQuery.of(context).size.width,),
                          Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                          Text(penginapanPostAllLMB.state.listDataMap[index]['cost'].isNotEmpty?'IDR${(int.parse(penginapanPostAllLMB.state.listDataMap[index]['cost'][0]['cost_price'].toString())/1000).toStringAsFixed(0)} K':'-', style: GoogleFonts.montserrat(fontSize:14, color:WADarkColor, fontWeight: FontWeight.bold),),
                          Text('${penginapanPostAllLMB.state.listDataMap[index]['cost'].isNotEmpty?penginapanPostAllLMB.state.listDataMap[index]['cost'][0]['cost_name']:''}', style: GoogleFonts.roboto(fontSize:10, color:WADarkColor, fontWeight: FontWeight.normal),)
                          ],),
                        ],)
                      ],),)
                      
                      ],)
                    
                    )),),):
                    Align(alignment: Alignment.center,child: Padding(padding: const EdgeInsets.only(top: 10), child: Text('Data tidak tersedia', style: GoogleFonts.montserrat(fontSize:12),),),)
            ],),);
          }),
          SizedBox(height: 0.1*MediaQuery.of(context).size.height,),
        ],),
      );
      },)
    )));
  }
}