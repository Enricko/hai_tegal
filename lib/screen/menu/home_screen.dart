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
import 'package:hai_tegal/master/tags_controller.dart';
import 'package:hai_tegal/screen.dart';
import 'package:hai_tegal/service/url.dart';
import 'package:hai_tegal/service/api.dart'; // Import for latitudeUserCB and longitudeUserCB
import 'package:line_icons/line_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  TextEditingController cariAllHome = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Initialize cache first if not already initialized
      await Api().initCache();

      // Load all data
      await loadAllHomeData();

      // Load location data
      if (mounted) {
        loadLocation(context, latitudeUser, longitudeUser);
      }
    } catch (e) {
      print('Error initializing home data: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshData() async {
    try {
      // Force refresh all data
      await loadAllHomeData(forceRefresh: true);
    } catch (e) {
      print('Error refreshing data: $e');
    }
  }

  @override
  bool get wantKeepAlive => true; // Keep the state when navigating away

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 0.08 * MediaQuery.of(context).size.height,
        child: BottomBarBubble(
          selectedIndex: 0,
          color: WAPrimaryColor1,
          items: [
            BottomBarItem(
              iconData: LineIcons.home,
              label: 'Home',
              labelTextStyle: GoogleFonts.montserrat(fontSize: 14),
            ),
            BottomBarItem(
              iconData: LineIcons.bell,
              label: 'Notification',
              labelTextStyle: GoogleFonts.montserrat(fontSize: 14),
            ),
            BottomBarItem(
              iconData: LineIcons.bookmark,
              label: 'Saved',
              labelTextStyle: GoogleFonts.montserrat(fontSize: 14),
            ),
            BottomBarItem(
              iconData: LineIcons.user,
              label: 'Account',
              labelTextStyle: GoogleFonts.montserrat(fontSize: 14),
            ),
          ],
          onSelect: (index) {
            if (index == 0) {
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            } else if (index == 1) {
              Navigator.pushNamedAndRemoveUntil(context, '/notifikasi', (route) => false);
            } else if (index == 2) {
              loadAllSaved('');
              Navigator.pushNamedAndRemoveUntil(context, '/saved', (route) => false);
            } else {
              Navigator.pushNamedAndRemoveUntil(context, '/account', (route) => false);
            }
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: BlocBuilder(
                  bloc: homeContentAll,
                  buildWhen: (previous, current) {
                    return previous != current;
                  },
                  builder: (context, state) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBannerSection(),
                          SizedBox(height: 0.05 * MediaQuery.of(context).size.height),
                          _buildSearchResultsSection(),
                          _buildCategoriesSection(),
                          SizedBox(height: 0.03 * MediaQuery.of(context).size.height),
                          _buildWisataSection(),
                          SizedBox(height: 0.05 * MediaQuery.of(context).size.height),
                          _buildJelajahSection(),
                          SizedBox(height: 0.05 * MediaQuery.of(context).size.height),
                          _buildKulinerSection(),
                          SizedBox(height: 0.05 * MediaQuery.of(context).size.height),
                          _buildEventSection(),
                          SizedBox(height: 0.05 * MediaQuery.of(context).size.height),
                          _buildTagsSection(),
                          SizedBox(height: 0.05 * MediaQuery.of(context).size.height),
                          _buildPenginapanSection(),
                          SizedBox(height: 0.1 * MediaQuery.of(context).size.height),
                        ],
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildBannerSection() {
    return SizedBox(
      height: 0.4 * MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          BlocBuilder(
            bloc: bannerAllLMB,
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) {
              return bannerAllLMB.state.listDataMap.isNotEmpty
                  ? CarouselCustomSlider(
                      initialPage: initPage.state,
                      isDisplayIndicator: false,
                      allowImplicitScrolling: true,
                      backgroundColor: WAPrimaryColor1,
                      doubleTapZoom: true,
                      clipBehaviorZoom: true,
                      autoPlay: true,
                      height: 0.4 * MediaQuery.of(context).size.height,
                      sliderList: List.generate(
                        bannerAllLMB.state.listDataMap.length,
                        (index) =>
                            "${Url().urlPict}${bannerAllLMB.state.listDataMap[index]['banner_file']}",
                      ),
                      fitPic: BoxFit.cover,
                    )
                  : CarouselCustomSlider(
                      isDisplayIndicator: false,
                      allowImplicitScrolling: true,
                      backgroundColor: WAPrimaryColor1,
                      doubleTapZoom: true,
                      clipBehaviorZoom: true,
                      autoPlay: false,
                      height: 0.4 * MediaQuery.of(context).size.height,
                      sliderList: sliderListImage,
                      fitPic: BoxFit.cover,
                    );
            },
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 0.06 * MediaQuery.of(context).size.height,
              left: 0.08 * MediaQuery.of(context).size.width,
              right: 0.08 * MediaQuery.of(context).size.width,
            ),
            child: Material(
              elevation: 20.0,
              shadowColor: WADarkColor,
              color: Colors.transparent,
              child: TextField(
                autofocus: false,
                controller: cariAllHome,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: WADarkColor,
                ),
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      loadHomeSearchPostAll(
                        context,
                        cariAllHome.text,
                        '',
                        '',
                        '0',
                      );
                      loadTagPost(cariAllHome.text);
                    },
                    child: const Icon(
                      Icons.search,
                      color: WASecondary,
                    ),
                  ),
                  border: InputBorder.none,
                  hintText: 'Mau jalan-jalan kemana hari ini ?',
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: WASecondary,
                  ),
                  filled: true,
                  fillColor: WALightColor,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 11,
                    horizontal: 20,
                  ),
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultsSection() {
    return BlocBuilder(
      bloc: homeSearchPostAll,
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return homeSearchPostAll.state.listDataMap.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pencarian Anda',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: WADarkColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            homeSearchPostAll.removeAll();
                          },
                          child: Text(
                            'Hapus Pencarian',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: WADangerColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.01 * MediaQuery.of(context).size.height),
                    SizedBox(
                      height: 0.32 * MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: homeSearchPostAll.state.listDataMap.length,
                        itemBuilder: (context, index) {
                          return _buildPostItem(
                            homeSearchPostAll.state.listDataMap[index],
                            index,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox();
      },
    );
  }

  Widget _buildCategoriesSection() {
    return BlocBuilder(
      bloc: categoryAllLMB,
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 0.05 * MediaQuery.of(context).size.width,
          ),
          height: 0.15 * MediaQuery.of(context).size.height,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoryAllLMB.state.listDataMap.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  loadSubCategory(
                    '',
                    categoryAllLMB.state.listDataMap[index]['category_id'],
                  );
                  chooseCategoryIndex(categoryAllLMB.state.listDataMap[index]);
                  loadPostNearestUser(categoryIndex.state['category_id']);
                  loadPostHighest(categoryIndex.state['category_id']);
                  loadPostFeatured();
                  Navigator.pushNamed(context, '/category');
                },
                child: SizedBox(
                  width: 0.2 * MediaQuery.of(context).size.width,
                  height: 0.2 * MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 0.16 * MediaQuery.of(context).size.width,
                        height: 0.15 * MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: WAInfo2Color.withOpacity(0.3),
                        ),
                        child: CachedNetworkImage(
                          imageUrl:
                              "${Url().urlPict}${categoryAllLMB.state.listDataMap[index]['category_avatar']}",
                          imageBuilder: (context, imageProvider) => Image.network(
                            "${Url().urlPict}${categoryAllLMB.state.listDataMap[index]['category_avatar']}",
                          ),
                          placeholder: (context, url) => const SizedBox(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.beach_access_sharp),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        spaceBetweenWord(categoryAllLMB.state.listDataMap[index]['category_name']),
                        style: GoogleFonts.sourceSans3(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: WAInfo2Color,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildWisataSection() {
    return BlocBuilder(
      bloc: wisataPostAllLMB,
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (homeContentAll.state.listDataMap.isEmpty ||
            wisataPostAllLMB.state.listDataMap.isEmpty) {
          return const SizedBox();
        }

        return Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                homeContentAll.state.listDataMap[0]['title_home'],
                style: GoogleFonts.montserrat(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: WADarkColor,
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 0.2 * MediaQuery.of(context).size.height,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: wisataPostAllLMB.state.listDataMap.length,
                  itemBuilder: (context, index) {
                    return _buildBannerPostItem(wisataPostAllLMB.state.listDataMap[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildJelajahSection() {
    return BlocBuilder(
      bloc: jelajahPostAllLMB,
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (homeContentAll.state.listDataMap.length < 2 ||
            jelajahPostAllLMB.state.listDataMap.isEmpty) {
          return const SizedBox();
        }

        return Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                homeContentAll.state.listDataMap[1]['title_home'],
                style: GoogleFonts.montserrat(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: WADarkColor,
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 0.3 * MediaQuery.of(context).size.height,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: jelajahPostAllLMB.state.listDataMap.length,
                  itemBuilder: (context, index) {
                    return _buildVerticalPostItem(jelajahPostAllLMB.state.listDataMap[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKulinerSection() {
    return BlocBuilder(
      bloc: kulinerPostAllLMB,
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (homeContentAll.state.listDataMap.length < 3) {
          return const SizedBox();
        }

        return Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                homeContentAll.state.listDataMap[2]['title_home'],
                style: GoogleFonts.montserrat(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: WADarkColor,
                ),
              ),
              const SizedBox(height: 5),
              kulinerPostAllLMB.state.listDataMap.isNotEmpty
                  ? SizedBox(
                      height: 0.25 * MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: kulinerPostAllLMB.state.listDataMap.length,
                        itemBuilder: (context, index) {
                          return _buildBannerPostItem(kulinerPostAllLMB.state.listDataMap[index]);
                        },
                      ),
                    )
                  : Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Data tidak tersedia',
                          style: GoogleFonts.montserrat(fontSize: 12),
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventSection() {
    return BlocBuilder(
      bloc: eventPostAllLMB,
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (homeContentAll.state.listDataMap.length < 4) {
          return const SizedBox();
        }

        return Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                homeContentAll.state.listDataMap[3]['title_home'],
                style: GoogleFonts.montserrat(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: WADarkColor,
                ),
              ),
              const SizedBox(height: 5),
              eventPostAllLMB.state.listDataMap.isNotEmpty
                  ? SizedBox(
                      height: 0.32 * MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: eventPostAllLMB.state.listDataMap.length,
                        itemBuilder: (context, index) {
                          return _buildEventPostItem(eventPostAllLMB.state.listDataMap[index]);
                        },
                      ),
                    )
                  : Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Data tidak tersedia',
                          style: GoogleFonts.montserrat(fontSize: 12),
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTagsSection() {
    return BlocBuilder(
      bloc: allTagsPost,
      buildWhen: (previous, current) => current != null,
      builder: (context, state) {
        return allTagsPost.state.listDataMap.isNotEmpty
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: 0.05 * MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 20),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: allTagsPost.state.listDataMap.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        tagIndex.changeVal(allTagsPost.state.listDataMap[index]);
                        Navigator.pushNamed(context, '/tags');
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        height: 0.03 * MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          border: Border.all(color: WATagColor, width: 1),
                          color: WALightColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 3),
                            Text(
                              '${allTagsPost.state.listDataMap[index]['tags_name']}',
                              style: GoogleFonts.sourceSans3(
                                fontSize: 14,
                                color: WATagColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 3),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            : const SizedBox();
      },
    );
  }

  Widget _buildPenginapanSection() {
    return BlocBuilder(
      bloc: penginapanPostAllLMB,
      buildWhen: (previous, current) => current != null,
      builder: (context, state) {
        if (homeContentAll.state.listDataMap.length < 5) {
          return const SizedBox();
        }

        return Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                homeContentAll.state.listDataMap[4]['title_home'],
                style: GoogleFonts.montserrat(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: WADarkColor,
                ),
              ),
              const SizedBox(height: 5),
              penginapanPostAllLMB.state.listDataMap.isNotEmpty
                  ? Column(
                      children: List.generate(
                        penginapanPostAllLMB.state.listDataMap.length,
                        (index) =>
                            _buildPenginapanItem(penginapanPostAllLMB.state.listDataMap[index]),
                      ),
                    )
                  : Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Data tidak tersedia',
                          style: GoogleFonts.montserrat(fontSize: 12),
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  // Helper methods to build repeated UI components
  Widget _buildPostItem(Map<String, dynamic> post, int index) {
    return GestureDetector(
      onTap: () {
        choosePostIndex(post);
        post['venue'] != null && post['venue'].length > 0
            ? loadNearestPostIndex(
                post['venue']['venue_x_coordinat'],
                post['venue']['venue_y_coordinat'],
                '',
              )
            : () {};
        loadReviewPostIndex(post['post_id']);
        Navigator.pushNamed(context, '/detail-post');
      },
      child: Stack(
        children: [
          post['img'].length > 0
              ? CachedNetworkImage(
                  imageUrl: "${Url().urlPict}${post['img'][0]['images_file']}",
                  imageBuilder: (context, imageProvider) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 0.25 * MediaQuery.of(context).size.height,
                    width: 0.4 * MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: WASecondary),
                      boxShadow: [
                        BoxShadow(
                          color: WADarkColor.withOpacity(0.6),
                          blurRadius: 2,
                          blurStyle: BlurStyle.inner,
                          offset: const Offset(4, 8),
                        ),
                      ],
                      image: DecorationImage(
                        image: NetworkImage('${Url().urlPict}${post['img'][0]['images_file']}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => SizedBox(
                    width: 0.03 * MediaQuery.of(context).size.width,
                    height: 0.03 * MediaQuery.of(context).size.width,
                  ),
                  errorWidget: (context, url, error) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 0.25 * MediaQuery.of(context).size.height,
                    width: 0.4 * MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: WASecondary),
                      boxShadow: [
                        BoxShadow(
                          color: WADarkColor.withOpacity(0.6),
                          blurRadius: 2,
                          blurStyle: BlurStyle.inner,
                          offset: const Offset(4, 8),
                        ),
                      ],
                      image: const DecorationImage(
                        image: AssetImage('assets/img/default_post.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: 0.25 * MediaQuery.of(context).size.height,
                  width: 0.4 * MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: WASecondary),
                    boxShadow: [
                      BoxShadow(
                        color: WADarkColor.withOpacity(0.6),
                        blurRadius: 2,
                        blurStyle: BlurStyle.inner,
                        offset: const Offset(4, 8),
                      ),
                    ],
                    image: const DecorationImage(
                      image: AssetImage('assets/img/default_post.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          Container(
            padding: const EdgeInsets.all(5),
            margin: EdgeInsets.only(
              left: 5,
              right: 5,
              top: 0.168 * MediaQuery.of(context).size.height,
            ),
            height: 0.08 * MediaQuery.of(context).size.height,
            width: 0.4 * MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: WALightColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${post['post_title']}',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: WADarkColor,
                  ),
                  maxLines: 2,
                ),
                Text(
                  '${post['post_short']}',
                  style: GoogleFonts.roboto(
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                    color: WADarkColor,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerPostItem(Map<String, dynamic> post) {
    return post['img'].length > 0
        ? GestureDetector(
            onTap: () {
              choosePostIndex(post);
              post['venue'] != null && post['venue'].length > 0
                  ? loadNearestPostIndex(
                      post['venue']['venue_x_coordinat'],
                      post['venue']['venue_y_coordinat'],
                      '',
                    )
                  : () {};
              loadReviewPostIndex(post['post_id']);
              Navigator.pushNamed(context, '/detail-post');
            },
            child: CachedNetworkImage(
              imageUrl: "${Url().urlPict}${post['img'][0]['images_file']}",
              imageBuilder: (context, imageProvider) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                height: 0.2 * MediaQuery.of(context).size.height,
                width: 0.8 * MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                    image: NetworkImage('${Url().urlPict}${post['img'][0]['images_file']}'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: Text(
                    '${post['post_title']}',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: WALightColor,
                    ),
                  ),
                ),
              ),
              placeholder: (context, url) => const SizedBox(),
              errorWidget: (context, url, error) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                height: 0.2 * MediaQuery.of(context).size.height,
                width: 0.8 * MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: const DecorationImage(
                    image: AssetImage('assets/img/default_post.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: Text(
                    '${post['post_title']}',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: WALightColor,
                    ),
                  ),
                ),
              ),
            ),
          )
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            height: 0.2 * MediaQuery.of(context).size.height,
            width: 0.8 * MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: const DecorationImage(
                image: AssetImage('assets/img/default_post.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Text(
                '${post['post_title']}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: WALightColor,
                ),
              ),
            ),
          );
  }

  Widget _buildVerticalPostItem(Map<String, dynamic> post) {
    return GestureDetector(
      onTap: () {
        choosePostIndex(post);
        post['venue'] != null && post['venue'].length > 0
            ? loadNearestPostIndex(
                post['venue']['venue_x_coordinat'],
                post['venue']['venue_y_coordinat'],
                '',
              )
            : () {};
        loadReviewPostIndex(post['post_id']);
        Navigator.pushNamed(context, '/detail-post');
      },
      child: post['img'] != null && post['img'].length > 0
          ? CachedNetworkImage(
              imageUrl: "${Url().urlPict}${post['img'][0]['images_file']}",
              imageBuilder: (context, imageProvider) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                height: 0.3 * MediaQuery.of(context).size.height,
                width: 0.4 * MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                    image: NetworkImage('${Url().urlPict}${post['img'][0]['images_file']}'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    top: 0.2 * MediaQuery.of(context).size.height,
                  ),
                  child: Text(
                    '${post['post_title']}',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: WALightColor,
                    ),
                  ),
                ),
              ),
              placeholder: (context, url) => const SizedBox(),
              errorWidget: (context, url, error) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                height: 0.3 * MediaQuery.of(context).size.height,
                width: 0.4 * MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: const DecorationImage(
                    image: AssetImage('assets/img/default_post.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    top: 0.2 * MediaQuery.of(context).size.height,
                  ),
                  child: Text(
                    '${post['post_title']}',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: WALightColor,
                    ),
                  ),
                ),
              ),
            )
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: 0.3 * MediaQuery.of(context).size.height,
              width: 0.4 * MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                image: const DecorationImage(
                  image: AssetImage('assets/img/default_post.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  top: 0.2 * MediaQuery.of(context).size.height,
                ),
                child: Text(
                  '${post['post_title']}',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: WALightColor,
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildEventPostItem(Map<String, dynamic> post) {
    return GestureDetector(
      onTap: () {
        choosePostIndex(post);
        post['venue'] != null && post['venue'].length > 0
            ? loadNearestPostIndex(
                post['venue']['venue_x_coordinat'],
                post['venue']['venue_y_coordinat'],
                '',
              )
            : () {};
        loadReviewPostIndex(post['post_id']);
        Navigator.pushNamed(context, '/detail-post');
      },
      child: Stack(
        children: [
          post['img'] != null && post['img'].length > 0
              ? CachedNetworkImage(
                  imageUrl: "${Url().urlPict}${post['img'][0]['images_file'] ?? ''}",
                  imageBuilder: (context, imageProvider) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 0.3 * MediaQuery.of(context).size.height,
                    width: 0.7 * MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: WASecondary),
                      boxShadow: [
                        BoxShadow(
                          color: WADarkColor.withOpacity(0.6),
                          blurRadius: 2,
                          blurStyle: BlurStyle.inner,
                          offset: const Offset(4, 8),
                        ),
                      ],
                      image: DecorationImage(
                        image: NetworkImage('${Url().urlPict}${post['img'][0]['images_file']}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => const SizedBox(),
                  errorWidget: (context, url, error) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 0.3 * MediaQuery.of(context).size.height,
                    width: 0.7 * MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: WASecondary),
                      boxShadow: [
                        BoxShadow(
                          color: WADarkColor.withOpacity(0.6),
                          blurRadius: 2,
                          blurStyle: BlurStyle.inner,
                          offset: const Offset(4, 8),
                        ),
                      ],
                      image: const DecorationImage(
                        image: AssetImage('assets/img/default_post.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: 0.3 * MediaQuery.of(context).size.height,
                  width: 0.7 * MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: WASecondary),
                    boxShadow: [
                      BoxShadow(
                        color: WADarkColor.withOpacity(0.6),
                        blurRadius: 2,
                        blurStyle: BlurStyle.inner,
                        offset: const Offset(4, 8),
                      ),
                    ],
                    image: const DecorationImage(
                      image: AssetImage('assets/img/default_post.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          Container(
            padding: const EdgeInsets.all(5),
            margin: EdgeInsets.only(
              left: 5,
              right: 5,
              top: 0.22 * MediaQuery.of(context).size.height,
            ),
            height: 0.08 * MediaQuery.of(context).size.height,
            width: 0.7 * MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: WALightColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${post['post_title']}',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: WADarkColor,
                  ),
                ),
                Text(
                  '${post['post_short']}',
                  maxLines: 1,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: WADarkColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPenginapanItem(Map<String, dynamic> post) {
    return GestureDetector(
      onTap: () {
        choosePostIndex(post);
        post['venue'] != null && post['venue'].length > 0
            ? loadNearestPostIndex(
                post['venue']['venue_x_coordinat'],
                post['venue']['venue_y_coordinat'],
                '',
              )
            : () {};
        loadReviewPostIndex(post['post_id']);
        Navigator.pushNamed(context, '/detail-post');
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10, right: 10),
        padding: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: WASecondary),
        ),
        width: MediaQuery.of(context).size.width,
        height: 0.2 * MediaQuery.of(context).size.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            post['img'] != null && post['img'].length > 0
                ? CachedNetworkImage(
                    imageUrl: "${Url().urlPict}${post['img'][0]['images_file'] ?? ''}",
                    imageBuilder: (context, imageProvider) => Container(
                      height: 0.2 * MediaQuery.of(context).size.height,
                      width: 0.3 * MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                        image: DecorationImage(
                          image: NetworkImage('${Url().urlPict}${post['img'][0]['images_file']}'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => const SizedBox(),
                    errorWidget: (context, url, error) => Container(
                      height: 0.2 * MediaQuery.of(context).size.height,
                      width: 0.3 * MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                        image: DecorationImage(
                          image: AssetImage('assets/img/default_post.jpg'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 0.2 * MediaQuery.of(context).size.height,
                    width: 0.3 * MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                      image: DecorationImage(
                        image: AssetImage('assets/img/default_post.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
            SizedBox(width: 0.03 * MediaQuery.of(context).size.width),
            SizedBox(
              width: 0.55 * MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${post['post_title']}',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: WADarkColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      post['venue'] != null
                          ? Text(
                              '${post['venue']['venue_addr'] ?? ''}',
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                color: WADarkColor,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          post['venue'] != null &&
                                  post['venue'].length > 0 &&
                                  latitudeUserCB.state != '' &&
                                  longitudeUserCB.state != ''
                              ? Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: WAPrimaryColor1,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '${(calculateDistance(
                                        double.parse(latitudeUserCB.state),
                                        double.parse(longitudeUserCB.state),
                                        double.parse(post['venue']['venue_x_coordinat'].toString()),
                                        double.parse(post['venue']['venue_y_coordinat'].toString()),
                                      )).toStringAsFixed(0)} km',
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        color: WADarkColor,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                Icons.star,
                                color: WAWarningColor,
                                size: 15,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${post['total_review'] != 0 ? double.parse((int.parse(post['total_review'].toString()) / int.parse(post['total_index'].toString())).toString()).toStringAsFixed(2) : 0}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: WADarkColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 0.01 * MediaQuery.of(context).size.height),
                          Text(
                            '${post['total_index']} reviews',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: WADisableColor,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 0.1 * MediaQuery.of(context).size.width),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            post['cost'].isNotEmpty
                                ? 'IDR${(int.parse(post['cost'][0]['cost_price'].toString()) / 1000).toStringAsFixed(0)} K'
                                : '-',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: WADarkColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${post['cost'].isNotEmpty ? post['cost'][0]['cost_name'] : ''}',
                            style: GoogleFonts.roboto(
                              fontSize: 10,
                              color: WADarkColor,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
