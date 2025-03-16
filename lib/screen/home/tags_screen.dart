import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hai_tegal/components/colors.dart';
import 'package:hai_tegal/master/category_controller.dart';
import 'package:hai_tegal/master/post_controller.dart';
import 'package:hai_tegal/master/tags_controller.dart';
import 'package:hai_tegal/service/url.dart';

class TagsScreen extends StatelessWidget {
  TagsScreen({super.key});
  TextEditingController cariPost = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if(allTagsPost.state.listDataMap.isEmpty){
      loadTagPost('');
    }

    void _refresh(){
      loadTagPost(cariPost.text);
      loadPostTagGet(cariPost.text, '', postIndexMB.state['tags_id']);
      //  loadSubCategory('', categoryIndex.state['category_id']);
      //  loadPostAllCategory(context, '',categoryIndex.state['category_id'], '', '');
    }
    return Scaffold(
    body: RefreshIndicator(onRefresh: ()async{
      _refresh();
    }, 
    child: SingleChildScrollView(
      child: Stack(children: [
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
        ),
        Padding(padding: EdgeInsets.only(top: 0.05*MediaQuery.of(context).size.height), 
                child: IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: const Icon(Icons.arrow_back, color: WAPrimaryColor1,)),)
        ]),
        ),
        Padding(padding: const EdgeInsets.only(left: 20), 
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            SizedBox(height: 0.3*MediaQuery.of(context).size.height,),
            Text('Temukan tagar ${tagIndex.state['tags_name']}', style: GoogleFonts.poppins(fontSize:19, color:WALightColor, fontWeight:FontWeight.bold),),
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
                    loadPostTagGet(cariPost.text, '', postIndexMB.state['tags_id'].toString());
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
                  child: Center(child: Text('Temukan Tagar!', style: GoogleFonts.roboto(fontSize:16, color:WALightColor),),),
                  ),),)
            ],)),
            SizedBox(height: 0.03*MediaQuery.of(context).size.height,),
            BlocBuilder(
              bloc: postIndexMB,
              buildWhen:(previous, current) {
                  if(previous!=current){
                    return true;
                  }else{
                    return false;
                  }
              },
              builder: (context, state){
              return  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text('${tagIndex.state['tags_name']}', style: GoogleFonts.montserrat(fontSize:19, fontWeight:FontWeight.bold, color:WADarkColor)),
                  postTagGet.state.listDataMap.isNotEmpty?
                  GestureDetector(onTap: (){
                    postTagGet.removeAll();
                  }, child: Text('Hapus Pencarian', style: GoogleFonts.montserrat(fontSize:12, fontWeight:FontWeight.bold, color:WADangerColor),),):SizedBox(),
                  SizedBox(width: 0.01*MediaQuery.of(context).size.width,),
             ],);
            }),
              SizedBox(height: 0.03*MediaQuery.of(context).size.height,),
              BlocBuilder(
                bloc: postTagGet,
                buildWhen:(previous, current) {
                  if(previous!=current){
                    return true;
                  }else{
                    return false;
                  }
                },
                builder: (context, state){
                return 
                Column(children: [
                  postTagGet.state.listDataMap.isNotEmpty?
                SizedBox(height: 0.32*MediaQuery.of(context).size.height, child: 
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:postTagGet.state.listDataMap.length,
                  itemBuilder: (context, index){
                    return GestureDetector(onTap: (){
                       choosePostIndex(postTagGet.state.listDataMap[index]);
                      // loadImgPostIndex(wisataPostAllLMB.state.listDataMap[index]['post_id']);
                      loadNearestPostIndex(postTagGet.state.listDataMap[index]['venue']['venue_x_coordinat'], postTagGet.state.listDataMap[index]['venue']['venue_y_coordinat'],'');
                      loadReviewPostIndex(postTagGet.state.listDataMap[index]['post_id']);
                      Navigator.pushNamed(context, '/detail-post');
                    }, child: Stack(children: [
                      postTagGet.state.listDataMap[index]['img'].length>0?
                      CachedNetworkImage(
                            imageUrl: "${Url().urlPict}${postTagGet.state.listDataMap[index]['img'][0]['images_file']}",
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
                            image: DecorationImage(image: NetworkImage('${Url().urlPict}${postTagGet.state.listDataMap[index]['img'][0]['images_file']}'),fit: BoxFit.cover)),
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
                              Text('${postTagGet.state.listDataMap[index]['post_title']}', style: GoogleFonts.montserrat(fontSize:12, fontWeight:FontWeight.w700, color:WADarkColor),maxLines: 2,),
                              Text('${postTagGet.state.listDataMap[index]['post_short']}', style: GoogleFonts.roboto(fontSize:10, fontWeight:FontWeight.normal, color:WADarkColor), maxLines: 1,),
                              // Text('Keterangan event ke-${index}', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.normal, color:WADarkColor),),
                              ],),),
                        ],),);
                    }),):SizedBox(),
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
                    loadPostTagGet('', '', tagIndex.state['tags_id']);
                    Navigator.pushReplacementNamed(context, '/tags');
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
                ],);
              }),
            ],),
        )
      ],),),),);
  }
}