import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hai_tegal/bloc/count_bloc.dart';
import 'package:hai_tegal/components/colors.dart';
import 'package:hai_tegal/components/utils.dart';
import 'package:hai_tegal/master/account_contrroller.dart';
import 'package:hai_tegal/master/saved_controller.dart';
import 'package:hai_tegal/service/api.dart';
import 'package:line_icons/line_icons.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});


  @override
  Widget build(BuildContext context) {
    if(userDetailMB.state.isEmpty){
      login();
    }
    CountBloc isChange = CountBloc();
    usernameCont.text = userDetailMB.state['user_name']??'';
    emailCont.text = userDetailMB.state['user_email']??'';
    phoneCont.text = userDetailMB.state['user_phone']??'';
    dateBirth.changeVal(userDetailMB.state['user_date_birth'] ?? '0000-00-00');
    latitudeCB.changeVal(userDetailMB.state['user_latitude'] ?? '');
    longitudeCB.changeVal(userDetailMB.state['user_longitude'] ?? '');
    imgProfile.changeVal(userDetailMB.state['user_img'] ?? '');
    addressCont.text = userDetailMB.state['user_address']??'';



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
       appBar: AppBar(leading: IconButton(onPressed: (){Navigator.pushReplacementNamed(context, '/home');}, icon: const Icon(Icons.keyboard_backspace_outlined, color: WADarkColor,)),),
      body: SafeArea(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: 
      SingleChildScrollView(child: 
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Text('Edit Profile', style: GoogleFonts.poppins(fontSize:30, fontWeight:FontWeight.w700),),
          BlocBuilder(
            bloc: isChange,
            buildWhen: (previous, current) {
              if(current!=previous){
                return true;
              }else{
                return false;
              }
            },
            builder: (context, state){return isChange.state == 1?TextButton(onPressed: ()async{
            var data = await Api().changeProfile(emailCont.text, usernameCont.text, imgProfile.state, phoneCont.text, latitudeCB.state, longitudeCB.state, addressCont.text, dateBirth.state);
             
            if(data['res'] == true){
              AlertText(context, WAAccentColor, WALightColor, data['msg']);
              userDetailMB.changeVal(data['data']);
            }else{
              AlertText(context, WADangerColor, WALightColor, data['msg']);
            }


          }, child: Text('Simpan', style: GoogleFonts.montserrat(fontSize:16, fontWeight:FontWeight.bold, color:WADisableColor),)):const SizedBox();})
        
        ],),
        BlocBuilder(
          bloc: imgProfile,
          buildWhen: (previous, current) {
            if(current!=previous){
              isChange.changeVal(1);
              return true;
            }else{
              isChange.defaultVal();
              return false;
            }
          },
          builder: (context, state){
          return Align( alignment: Alignment.center,child: uploadSinglePic(context, imgProfile, 'assets/img/profile_img.png', false, isGallery: true),);
        }),
        SizedBox(height: 0.05*MediaQuery.of(context).size.height,),
        Row(children: [
          SizedBox(width: 0.35*MediaQuery.of(context).size.width,
          child: Text('Username', style: GoogleFonts.montserrat(fontSize:14, fontWeight:FontWeight.w500),),
          ),
          SizedBox(width: 0.5*MediaQuery.of(context).size.width,
          child: TextField(onChanged: (value) {
            if(value != userDetailMB.state['user_name']){
              isChange.changeVal(1);
            }else{
              isChange.defaultVal();
            }
          },controller: usernameCont,decoration: null, style: GoogleFonts.montserrat(fontSize:14, fontWeight:FontWeight.w500),),
          ),
        ],),
        Divider(height: 0.05*MediaQuery.of(context).size.height,),
        Row(children: [
          SizedBox(width: 0.35*MediaQuery.of(context).size.width,
          child: Text('Email', style: GoogleFonts.montserrat(fontSize:14, fontWeight:FontWeight.w500),),
          ),
          SizedBox(width: 0.5*MediaQuery.of(context).size.width,
          child: TextField(onChanged: (value) {
            if(value != userDetailMB.state['user_email']){
              isChange.changeVal(1);
            }else{
              isChange.defaultVal();
            }
          },controller: emailCont,decoration: null, style: GoogleFonts.montserrat(fontSize:14, fontWeight:FontWeight.w500),),
          ),
        ],),
         Divider(height: 0.05*MediaQuery.of(context).size.height,),
        Row(children: [
          SizedBox(width: 0.35*MediaQuery.of(context).size.width,
          child: Text('Phone', style: GoogleFonts.montserrat(fontSize:14, fontWeight:FontWeight.w500),),
          ),
          SizedBox(width: 0.5*MediaQuery.of(context).size.width,
          child: TextField(onChanged: (value) {
            if(value != userDetailMB.state['user_phone']){
              isChange.changeVal(1);
            }else{
              isChange.defaultVal();
            }
          },controller: phoneCont,decoration: null, style: GoogleFonts.montserrat(fontSize:14, fontWeight:FontWeight.w500),),
          ),
        ],),
         Divider(height: 0.05*MediaQuery.of(context).size.height,),
        Row(children: [
          SizedBox(width: 0.35*MediaQuery.of(context).size.width,
          child: Text('Date of Birth', style: GoogleFonts.montserrat(fontSize:14, fontWeight:FontWeight.w500),),
          ),
          SizedBox(width: 0.4*MediaQuery.of(context).size.width,
          child: BlocBuilder(
            buildWhen: (previous, current) {
              if(previous!=current){
                return true;
              }else{
                return false;
              }
            },
            bloc: dateBirth, 
            builder: (context, state){return Text(date2(dateBirth.state),  style: GoogleFonts.montserrat(fontSize:14, fontWeight:FontWeight.w500),);},),
          ),
          SizedBox(
            width: 0.1 * MediaQuery.of(context).size.width,
            child: IconButton(
                onPressed: () {
                  ModalContainer(
                      context,
                      'Pilih Tanggal Lahir',
                      Container(
                        color: WAPrimaryColor2,
                        width: 0.8 * MediaQuery.of(context).size.width,
                        height: 0.3 * MediaQuery.of(context).size.height,
                        child: DatePickerWidget(
                          looping: false, // default is not looping
                          firstDate:
                              DateTime(DateTime.now().year - 80, 1, 13),
                          lastDate: DateTime.now(),
                          dateFormat:
                              // "MM-dd(E)",
                              "dd/MMMM/yyyy",
                          // locale: DatePicker.localeFromString('th'),
                          onChange: (DateTime newDate, _) {
                            var tgl = newDate.toString().split(' ');
                            dateBirth.changeVal(tgl[0]);
                          },
                          pickerTheme: const DateTimePickerTheme(
                            backgroundColor: Colors.transparent,
                            itemTextStyle:
                                TextStyle(color: WALightColor, fontSize: 19),
                            dividerColor: WALightColor,
                          ),
                        ),
                      ),
                      [
                        IconsButton(
                          onPressed: () {
                            if (dateBirth.state == '') {
                              ModalText(
                                  context, 'Peringatan', 'Tanggal Belum Dipilih', [
                                IconsButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  text: 'Kembali',
                                  color: WAPrimaryColor2,
                                  textStyle: GoogleFonts.poppins(color:WALightColor)
                                ),
                                IconsButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  text: 'Batalkan',
                                  color: WADangerColor,
                                  textStyle: GoogleFonts.poppins(color:WALightColor)
                                )
                              ]);
                            } else {
                              if(dateBirth.state != userDetailMB.state['user_date_birth']){
                                isChange.changeVal(1);
                              }else{
                                isChange.defaultVal();
                              }
                              Navigator.pop(context);
                            }
                          },
                          text: 'Pilih Tanggal',
                          color: WAPrimaryColor2,
                          textStyle: GoogleFonts.poppins(color:WALightColor)
                        )
                      ]);
                },
                icon: const Icon(
                  Icons.calendar_today_rounded,
                  color: WAPrimaryColor2,
                  size: 25,
                )),
          ),
        ],),
         Divider(height: 0.05*MediaQuery.of(context).size.height,),
        Row(children: [
          SizedBox(width: 0.35*MediaQuery.of(context).size.width,
          child: Text('Address', style: GoogleFonts.montserrat(fontSize:14, fontWeight:FontWeight.w500),),
          ),
          SizedBox(width: 0.5*MediaQuery.of(context).size.width,
          child: TextField(onChanged: (value) {
            if(value != userDetailMB.state['user_address']){
              isChange.changeVal(1);
            }else{
              isChange.defaultVal();
            }
          },controller: addressCont,decoration: null, style: GoogleFonts.montserrat(fontSize:14, fontWeight:FontWeight.w500),),
          ),
        ],),
         Divider(height: 0.05*MediaQuery.of(context).size.height,),
         SizedBox(height: 0.05*MediaQuery.of(context).size.height,),
         Center(child:  GestureDetector(
            onTap: (){
             userDetailMB.removeVal();
             user.remove('email');
             user.remove('pass');
            },
            child: Container(width: 0.8*MediaQuery.of(context).size.width, height: 0.07*MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: WADangerColor, border: Border.all(color: WADangerColor), boxShadow: [
                    BoxShadow(
                      color: WALightColor.withOpacity(0.2),
                      blurRadius: 2,
                      blurStyle: BlurStyle.inner,
                      offset: const Offset(2, 4,), // Shadow position
                    ),
                  ]),
                  child: Center(child: Material(color: Colors.transparent, child: Text('Logout', style: GoogleFonts.roboto(fontSize:16, color:WALightColor, fontWeight: FontWeight.bold),),),),
                  ),),),
        SizedBox(height: 0.2*MediaQuery.of(context).size.height,),
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

      ],);})      ,),)),
    );
  }
}