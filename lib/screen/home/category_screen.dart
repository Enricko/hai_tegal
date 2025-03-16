import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hai_tegal/components/colors.dart';
import 'package:hai_tegal/master/category_controller.dart';
import 'package:hai_tegal/master/post_controller.dart';
import 'package:hai_tegal/service/url.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key});
  TextEditingController cariPost = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if(subCategoryAll.state.listDataMap.isEmpty){
      loadSubCategory('', categoryIndex.state['category_id']);
    }

    if(postNearestAll.state.listDataMap.isEmpty){
      loadPostNearestUser(categoryIndex.state['category_id']);
      if(postNearestAll.state.listDataMap.isEmpty){
        loadPostNearestUser('');
      }
    }

    if(postHighestAll.state.listDataMap.isEmpty){
      loadPostHighest(categoryIndex.state['category_id']);
    }

    if(postFeaturedTripAll.state.listDataMap.isEmpty){
      loadPostFeatured();
    }

    void _refresh() async {
      await loadSubCategory('', categoryIndex.state['category_id']);
      await loadPostNearestUser(categoryIndex.state['category_id']);
      if(postNearestAll.state.listDataMap.isEmpty){
        await loadPostNearestUser('');
      }
      await loadPostHighest(categoryIndex.state['category_id']);
      await loadPostFeatured();
    }
    
    return Scaffold(
    body: RefreshIndicator(onRefresh: () async {
      _refresh();
    }, 
    child: Stack(children: [
        SizedBox(width: MediaQuery.of(context).size.width, 
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(children: [
            Stack(children: [
              Stack(children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                ),
                height: 350.0,
                child: CachedNetworkImage(
                                  imageUrl:'${Url().urlPict}${categoryIndex.state['category_image']}',
                                  imageBuilder: (context, ImageProvider)=> 
                                  Image.network('${Url().urlPict}${categoryIndex.state['category_image']}', fit: BoxFit.fill,),
                                  placeholder: (context, url) => SizedBox(width: 0.03*MediaQuery.of(context).size.width, height: 0.03*MediaQuery.of(context).size.width),
                                  errorWidget: (context, url, error) => Image.asset('assets/img/background_2.png', fit: BoxFit.fill,),
                              )
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
              Align(
                alignment: Alignment.center, 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 0.3*MediaQuery.of(context).size.height,),
                    Text('Temukan di ${categoryIndex.state['category_name']}', style: GoogleFonts.poppins(fontSize:19, color:WALightColor, fontWeight:FontWeight.bold),),
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
                            controller: cariPost,
                          ),),),
                          Padding(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10), 
                          child: GestureDetector(
                            onTap: () {
                              loadPostAllCategory(context, cariPost.text, '', '', '');
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
                            child: Center(child: Text('Yuk Jelajahi!', style: GoogleFonts.roboto(fontSize:16, color:WALightColor),),),
                            ),),)
                      ],)
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 0.05*MediaQuery.of(context).size.height), 
                child: IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: const Icon(Icons.arrow_back, color: WAPrimaryColor1,)),)
            ],),
            Padding(padding: const EdgeInsets.only(left: 20), 
              child: SingleChildScrollView(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  SizedBox(height: 0.03*MediaQuery.of(context).size.height,),
                  BlocBuilder(
                    bloc: postSearchAll,
                    buildWhen:(previous, current) {
                        if(previous!=current){
                          return true;
                        }else{
                          return false;
                        }
                    },
                    builder: (context, state){
                    return  
                    postSearchAll.state.listDataMap.isNotEmpty?
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Text('Penelusuran', style: GoogleFonts.montserrat(fontSize:19, fontWeight:FontWeight.bold, color:WADarkColor)),
                        GestureDetector(onTap: (){
                          postSearchAll.removeAll();
                        }, child: Text('Hapus Pencarian', style: GoogleFonts.montserrat(fontSize:12, fontWeight:FontWeight.bold, color:WADangerColor),),),
                        SizedBox(width: 0.01*MediaQuery.of(context).size.width,),
                  ],):SizedBox();
                  }),
                  SizedBox(height: 0.03*MediaQuery.of(context).size.height,),
                  BlocBuilder(
                        bloc: postSearchAll,
                        buildWhen:(previous, current) {
                          if(previous!=current){
                            return true;
                          }else{
                            return false;
                          }
                        },
                        builder: (context, state){
                        return 
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      postSearchAll.state.listDataMap.isNotEmpty?
                        SizedBox(height: 0.32*MediaQuery.of(context).size.height, child: 
                        ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:postSearchAll.state.listDataMap.length,
                          itemBuilder: (context, index){
                            return GestureDetector(onTap: (){
                              choosePostIndex(postSearchAll.state.listDataMap[index]);
                              // loadImgPostIndex(postHighestAll.state.listDataMap[index]['post_id']);
                              loadNearestPostIndex(postSearchAll.state.listDataMap[index]['venue']['venue_x_coordinat'], postSearchAll.state.listDataMap[index]['venue']['venue_y_coordinat'],'');
                              loadReviewPostIndex(postSearchAll.state.listDataMap[index]['post_id']);
                              Navigator.pushNamed(context, '/detail-post');
                            }, child: Stack(children: [
                              postSearchAll.state.listDataMap[index]['img'].length>0?
                              CachedNetworkImage(
                                    imageUrl: "${Url().urlPict}${postSearchAll.state.listDataMap[index]['img'][0]['images_file']}",
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
                                    image: DecorationImage(image: NetworkImage('${Url().urlPict}${postSearchAll.state.listDataMap[index]['img'][0]['images_file']}'),fit: BoxFit.cover)),
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
                                      Text('${postSearchAll.state.listDataMap[index]['post_title']}', style: GoogleFonts.montserrat(fontSize:12, fontWeight:FontWeight.w700, color:WADarkColor),maxLines: 2,),
                                      Text('${postSearchAll.state.listDataMap[index]['post_short']}', style: GoogleFonts.roboto(fontSize:10, fontWeight:FontWeight.normal, color:WADarkColor), maxLines: 1,),
                                      // Text('Keterangan event ke-${index}', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.normal, color:WADarkColor),),
                                      ],),),
                                ],),);
                  }),):SizedBox(),
                  BlocBuilder(
                    bloc: postNearestAll,
                    buildWhen:(previous, current) {
                        if(previous!=current){
                          return true;
                        }else{
                          return false;
                        }
                    },
                    builder: (context, state){
                      return postNearestAll.state.listDataMap.length>0? Text('Lokasi Terdekat', style: GoogleFonts.montserrat(fontSize:19, fontWeight:FontWeight.bold, color:WADarkColor)):Text('');}
                  ),
                  SizedBox(height: 0.03*MediaQuery.of(context).size.height,),
                  BlocBuilder(
                    bloc: postNearestAll,
                    buildWhen:(previous, current) {
                        if(previous!=current){
                          return true;
                        }else{
                          return false;
                        }
                    },
                    builder: (context, state){
                    return postNearestAll.state.listDataMap.isNotEmpty?
                      SizedBox(height: 0.28*MediaQuery.of(context).size.height, child: 
                      ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:postNearestAll.state.listDataMap.length,
                        itemBuilder: (context, index){
                          return GestureDetector(onTap: (){
                            choosePostIndex(postNearestAll.state.listDataMap[index]['post']);
                            // loadImgPostIndex(postHighestAll.state.listDataMap[index]['post']['post_id']);
                            loadNearestPostIndex(postNearestAll.state.listDataMap[index]['post']['venue']['venue_x_coordinat'], postNearestAll.state.listDataMap[index]['post']['venue']['venue_y_coordinat'],'');
                            loadReviewPostIndex(postNearestAll.state.listDataMap[index]['post']['post_id']);
                            Navigator.pushNamed(context, '/detail-post');
                          }, child: Stack(children: [
                            postNearestAll.state.listDataMap[index]['post']['img'].length>0?
                            CachedNetworkImage(
                                  imageUrl: "${Url().urlPict}${postNearestAll.state.listDataMap[index]['post']['img'][0]['images_file']}",
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
                                  image: DecorationImage(image: NetworkImage('${Url().urlPict}${postNearestAll.state.listDataMap[index]['post']['img'][0]['images_file']}'),fit: BoxFit.cover)),
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
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start, children: [ 
                                    Text('${postNearestAll.state.listDataMap[index]['post']['post_title']}', style: GoogleFonts.montserrat(fontSize:12, fontWeight:FontWeight.w700, color:WADarkColor),maxLines: 2,),
                                    Row(
                                      children: [
                                        5.width,
                                        Icon(Icons.location_on, color: WAPrimaryColor1, size: 15,),
                                        5.width,
                                        Text('${(postNearestAll.state.listDataMap[index]['distance']/1000).toStringAsFixed(2)} km', style: GoogleFonts.roboto(fontSize:10, fontWeight:FontWeight.normal, color:WADarkColor), maxLines: 1,),
                                      ],
                                    )
                                    // Text('Keterangan event ke-${index}', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.normal, color:WADarkColor),),
                                    ],),),
                              ],),);
                    }),):SizedBox();
                  }),
                  SizedBox(height: 0.01*MediaQuery.of(context).size.height),
                  Text('${categoryIndex.state['category_name']}', style: GoogleFonts.montserrat(fontSize:19, fontWeight:FontWeight.bold, color:WADarkColor)),
                  SizedBox(height: 0.03*MediaQuery.of(context).size.height),
                  BlocBuilder(
                        bloc: subCategoryAll,
                        buildWhen: (previous, current) {
                          if(previous!=current){
                            return true;
                          }else{
                            return false;
                          }
                        },
                        builder: (context, state){return Container(
                        padding: const EdgeInsets.only(right: 20),
                        height:  subCategoryAll.state.listDataMap.isNotEmpty?((subCategoryAll.state.listDataMap.length/4)+0.5)* 0.13*MediaQuery.of(context).size.height:0.05*MediaQuery.of(context).size.height, 
                        child: 
                        subCategoryAll.state.listDataMap.isNotEmpty?
                        GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, // number of items in each row
                            mainAxisSpacing: 0, // spacing between rows
                            crossAxisSpacing: 0, // spacing between columns
                          ),
                          padding: const EdgeInsets.all(1.0),
                          physics: NeverScrollableScrollPhysics(), // padding around the grid
                          itemCount: subCategoryAll.state.listDataMap.length, // total number of items
                          itemBuilder: (context, index) {
                            return GestureDetector(onTap: (){
                              chooseCategoryIndex(subCategoryAll.state.listDataMap[index]);
                              // loadPostAllCategoryInner('', categoryIndex.state['category_id'], '', '');
                              Navigator.pushNamed(context, '/detail-category');
                            }, child: SizedBox(height: 0.3*MediaQuery.of(context).size.height, 
                            child: Column(children: [
                            Container(
                            width: 0.16*MediaQuery.of(context).size.width,
                            height: 0.14*MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: WAInfo2Color.withOpacity(0.3)),
                            child:  CachedNetworkImage(
                                    imageUrl: "${Url().urlPict}${subCategoryAll.state.listDataMap[index]['category_avatar']}",
                                    imageBuilder: (context, ImageProvider)=> Image.network("${Url().urlPict}${subCategoryAll.state.listDataMap[index]['category_avatar']}"),
                                    placeholder: (context, url) => const SizedBox(),
                                    errorWidget: (context, url, error) => const Icon(Icons.beach_access)
                                ),),
                            const SizedBox(height: 3,),
                            Text('${subCategoryAll.state.listDataMap[index]['category_name']}', style: GoogleFonts.sourceSans3(fontSize:14, fontWeight:FontWeight.bold, color:WAInfo2Color),maxLines: 1,textAlign: TextAlign.center,),
                            const SizedBox(height: 1,),
                          ],),),);
                          },
                        ):Text('Sub Kategori tidak tersedia', style: GoogleFonts.poppins(fontSize:12, color:WADarkColor),),);}),
                        ],);
                  }),
                  SizedBox(height: 0.03*MediaQuery.of(context).size.height,),
                  BlocBuilder(
                    bloc: postHighestAll,
                    buildWhen: (previous, current) {
                          if(previous!=current){
                            return true;
                          }else{
                            return false;
                          }
                    },
                    builder: (context, state){return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Wisata yang Lagi Rame', style: GoogleFonts.montserrat(fontSize:19, fontWeight:FontWeight.bold, color:WADarkColor),),
                       SizedBox(height: 0.03*MediaQuery.of(context).size.height,),
                      SizedBox(height: 0.2*MediaQuery.of(context).size.height, child: 
                        ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: postHighestAll.state.listDataMap.length,
                          itemBuilder: (context, index){
                            // print('${Url().urlPict}${postHighestAll.state.listDataMap[index]['img'][0]['images_file']}'??'');
                            return 
                            postHighestAll.state.listDataMap[index]['img'].length >0?
                            GestureDetector(onTap: (){
                              choosePostIndex(postHighestAll.state.listDataMap[index]);
                              postHighestAll.state.listDataMap[index]['venue']!=null&&postHighestAll.state.listDataMap[index]['venue'].length>0? loadNearestPostIndex(postHighestAll.state.listDataMap[index]['venue']['venue_x_coordinat'], postHighestAll.state.listDataMap[index]['venue']['venue_y_coordinat'], ''):(){};
                              loadReviewPostIndex(postHighestAll.state.listDataMap[index]['post_id']);
                              Navigator.pushNamed(context, '/detail-post');
                            }, child: CachedNetworkImage(
                                    imageUrl: "${Url().urlPict}${postHighestAll.state.listDataMap[index]['img'][0]['images_file']}",
                                    imageBuilder: (context, ImageProvider)=> Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 5),
                                        height: 0.2*MediaQuery.of(context).size.height,
                                        width: 0.8*MediaQuery.of(context).size.width, 
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), 
                                        image: DecorationImage(image: 
                                          NetworkImage('${Url().urlPict}${postHighestAll.state.listDataMap[index]['img'][0]['images_file']}'??''),fit: BoxFit.cover)
                                        ),
                                        child: Padding(padding: const EdgeInsets.only(left: 20, top: 20), child: Text('${postHighestAll.state.listDataMap[index]['post_title']}', style: GoogleFonts.poppins(fontSize:18, fontWeight:FontWeight.w700, color:WALightColor),),),
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
                                        child: Padding(padding: const EdgeInsets.only(left: 20, top: 20), child: Text('${postHighestAll.state.listDataMap[index]['post_title']}', style: GoogleFonts.poppins(fontSize:18, fontWeight:FontWeight.w700, color:WALightColor),),),
                                        ),
                                )):Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 5),
                                        height: 0.2*MediaQuery.of(context).size.height,
                                        width: 0.8*MediaQuery.of(context).size.width, 
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), 
                                        image: const DecorationImage(image: 
                                          AssetImage('assets/img/default_post.jpg'),fit: BoxFit.cover)
                                        ),
                                        child: Padding(padding: const EdgeInsets.only(left: 20, top: 20), child: Text('${postHighestAll.state.listDataMap[index]['post_title']}', style: GoogleFonts.poppins(fontSize:18, fontWeight:FontWeight.w700, color:WALightColor),),),
                                        );
                            }),)
                    ],);}),
                  SizedBox(height: 0.03*MediaQuery.of(context).size.height,),
                  BlocBuilder(
                    bloc: postFeaturedTripAll,
                    buildWhen: (previous, current) {
                          if(previous!=current){
                            return true;
                          }else{
                            return false;
                          }
                    },
                    builder: (context, state){return  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Featured Trip', style: GoogleFonts.montserrat(fontSize:19, fontWeight:FontWeight.bold, color:WADarkColor),),
                       SizedBox(height: 0.03*MediaQuery.of(context).size.height,),
                      SizedBox(height: 0.2*MediaQuery.of(context).size.height, child: 
                        ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: postFeaturedTripAll.state.listDataMap.length,
                          itemBuilder: (context, index){
                            // print('${Url().urlPict}${postFeaturedTripAll.state.listDataMap[index]['img'][0]['images_file']}'??'');
                            return 
                            postFeaturedTripAll.state.listDataMap[index]['img'].length >0?
                            GestureDetector(onTap: (){
                              choosePostIndex(postFeaturedTripAll.state.listDataMap[index]);
                              postFeaturedTripAll.state.listDataMap[index]['venue']!=null&&postFeaturedTripAll.state.listDataMap[index]['venue'].length>0? loadNearestPostIndex(postFeaturedTripAll.state.listDataMap[index]['venue']['venue_x_coordinat'], postFeaturedTripAll.state.listDataMap[index]['venue']['venue_y_coordinat'], ''):(){};
                              loadReviewPostIndex(postFeaturedTripAll.state.listDataMap[index]['post_id']);
                              Navigator.pushNamed(context, '/detail-post');
                            }, child: CachedNetworkImage(
                                    imageUrl: "${Url().urlPict}${postFeaturedTripAll.state.listDataMap[index]['img'][0]['images_file']}",
                                    imageBuilder: (context, ImageProvider)=> Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 5),
                                        height: 0.2*MediaQuery.of(context).size.height,
                                        width: 0.8*MediaQuery.of(context).size.width, 
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), 
                                        image: DecorationImage(image: 
                                          NetworkImage('${Url().urlPict}${postFeaturedTripAll.state.listDataMap[index]['img'][0]['images_file']}'??''),fit: BoxFit.cover)
                                        ),
                                        child: Padding(padding: const EdgeInsets.only(left: 20, top: 20), child: Text('${postFeaturedTripAll.state.listDataMap[index]['post_title']}', style: GoogleFonts.poppins(fontSize:18, fontWeight:FontWeight.w700, color:WALightColor),),),
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
                                        child: Padding(padding: const EdgeInsets.only(left: 20, top: 20), child: Text('${postFeaturedTripAll.state.listDataMap[index]['post_title']}', style: GoogleFonts.poppins(fontSize:18, fontWeight:FontWeight.w700, color:WALightColor),),),
                                        ),
                                )):Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 5),
                                        height: 0.2*MediaQuery.of(context).size.height,
                                        width: 0.8*MediaQuery.of(context).size.width, 
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), 
                                        image: const DecorationImage(image: 
                                          AssetImage('assets/img/default_post.jpg'),fit: BoxFit.cover)
                                        ),
                                        child: Padding(padding: const EdgeInsets.only(left: 20, top: 20), child: Text('${postFeaturedTripAll.state.listDataMap[index]['post_title']}', style: GoogleFonts.poppins(fontSize:18, fontWeight:FontWeight.w700, color:WALightColor),),),
                                        );
                            }),)
                    ],);}),
                    // Text(datacat.state['category_name']??'Tidak muncul'),
                  50.height
                  ],),),
              )
          ],),)
        ),
      ],),),);
  }
}