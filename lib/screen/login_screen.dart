import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hai_tegal/components/colors.dart';
import 'package:hai_tegal/components/utils.dart';
import 'package:hai_tegal/master/account_contrroller.dart';
import 'package:hai_tegal/master/saved_controller.dart';
import 'package:hai_tegal/service/api.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:nb_utils/nb_utils.dart';

class LoginScreen extends StatelessWidget {
 LoginScreen({super.key});
  TextEditingController mail = TextEditingController();
  TextEditingController pass = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.keyboard_backspace_outlined, color: WADarkColor,)),),
      body: SafeArea(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: 
      SingleChildScrollView(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text('Log in', style: GoogleFonts.poppins(fontSize:30, fontWeight:FontWeight.w700),),
        SizedBox(height: 0.05*MediaQuery.of(context).size.height,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          GestureDetector(
            onTap: (){
             ModalText(context, 'Informasi', 'Fitur will be coming soon', [
              IconsButton(onPressed: (){Navigator.pop(context);}, text: 'Kembali', textStyle: GoogleFonts.poppins(fontSize:14, color:WALightColor), color: WAPrimaryColor1,)
             ]);
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
                  child: Center(child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    Image.asset('assets/img/google.png'),
                    Material(color: Colors.transparent, child: Text('Google', style: GoogleFonts.montserrat(fontSize:15, color:WADarkColor, fontWeight: FontWeight.w700),),)],),),
                  ),),
          GestureDetector(
            onTap: (){
             ModalText(context, 'Informasi', 'Fitur will be coming soon', [
              IconsButton(onPressed: (){Navigator.pop(context);}, text: 'Kembali', textStyle: GoogleFonts.poppins(fontSize:14, color:WALightColor), color: WAPrimaryColor1,)
             ]);
            },
            child: Container(width: 0.4*MediaQuery.of(context).size.width, height: 0.07*MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: WAInfoColor, border: Border.all(color: WASecondary), boxShadow: [
                    BoxShadow(
                      color: WADarkColor.withOpacity(0.2),
                      blurRadius: 2,
                      blurStyle: BlurStyle.inner,
                      offset: const Offset(2, 4,), // Shadow position
                    ),
                  ]),
                  child: Center(child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    Image.asset('assets/img/facebook.png'),
                    Material(color: WAInfoColor, child: Text('Facebook', style: GoogleFonts.montserrat(fontSize:15, color:WALightColor, fontWeight: FontWeight.w700),),)],),),
                  ),)
        ],),
      SizedBox(height: 0.05*MediaQuery.of(context).size.height,),
      Align(alignment: Alignment.topCenter,child: Text('Or log in using',style: GoogleFonts.roboto(fontSize:12, color:WADarkColor, fontWeight: FontWeight.w400), ),),
      SizedBox(height: 0.05*MediaQuery.of(context).size.height,),
      appTextField2(context, '', mail, hint: 'Mail',),
      appTextField2(context, '', pass, hint: 'Password', textInputType: TextInputType.visiblePassword, typeTextField: TextFieldType.PASSWORD,iconColor: WAPrimaryColor1 ),
      SizedBox(height: 0.03*MediaQuery.of(context).size.height,),
      Align(alignment: Alignment.centerRight, child: Text('Forgot your password?', style: GoogleFonts.roboto(fontSize:12, fontWeight:FontWeight.w400), textAlign: TextAlign.right,),),
      SizedBox(height: 0.03*MediaQuery.of(context).size.height,),
      Align(
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: ()async{
            var data = await Api().doLogin(mail.text, pass.text);
            ModalContainer(context, '', Container(child: const CircularProgressIndicator() ,), []);
            if(data['res'] == true){
              AlertText(context, WAAccentColor, WALightColor, data['msg']);
                Navigator.pop(context);
                userDetailMB.changeVal(data['data']);
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            }else{
              Navigator.pop(context);
              AlertText(context, WADangerColor, WALightColor, data['msg']);
            }
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
                  child: Center(child: Text('Log In', style: GoogleFonts.roboto(fontSize:16, color:WALightColor, fontWeight: FontWeight.bold),),),
                  ),),)
      ],),),)),
    );
  }
}