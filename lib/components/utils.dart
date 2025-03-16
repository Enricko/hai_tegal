import 'dart:convert';
import 'dart:io';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hai_tegal/bloc/custom_bloc.dart';
import 'package:hai_tegal/components/colors.dart';
import 'package:hai_tegal/master/home_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

InputDecoration waInputDecoration(
    {IconData? prefixIcon,
    String? hint,
    Color? bgColor,
    Color? borderColor,
    Color? prefixIconColor,
    EdgeInsets? padding}) {
  return InputDecoration(
    contentPadding:
        padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
    counter: const Offstage(),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: borderColor ?? WAPrimaryColor1)),
    enabledBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide(color: WALightColor.withOpacity(0.2)),
    ),
    fillColor: bgColor ?? WAPrimaryColor1.withOpacity(0.04),
    hintText: hint,
    labelStyle: GoogleFonts.montserrat(fontSize:12, fontWeight: FontWeight.w400),
    prefixIcon:
        prefixIcon != null ? Icon(prefixIcon, color: prefixIconColor??WAPrimaryColor1) : null,
    hintStyle: GoogleFonts.montserrat(fontSize:12, fontWeight: FontWeight.w400),
    filled: true,
  );
}

Widget appTextField2(context, String label, TextEditingController controller,
    {TextFieldType? typeTextField,
    TextInputType? textInputType,
    String? hint,
    bool? obscure,
    IconData? icon,
    Color? iconColor,
    bool? isNumber,bool? enable, Function? onChange}) {
  //nb_utils
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(
        label,
        style: primaryTextStyle(size: 14, color: WADisableColor),
      ),
      SizedBox(
        height: 0.005 * MediaQuery.of(context).size.height,
      ),
      Material(
        elevation: 5.0,
              shadowColor: WADisableColor,
              borderRadius: BorderRadiusGeometry.lerp(BorderRadius.circular(30), BorderRadius.circular(30), 0.5),
        child: AppTextField(
        onChanged:(p0){onChange??{};return '';},
        enabled:enable??true ,
        decoration: waInputDecoration(
            hint: hint ?? '', bgColor: WALightColor, borderColor: WALightColor, prefixIconColor: iconColor),
        textFieldType: typeTextField ?? TextFieldType.OTHER,
        keyboardType: textInputType ?? TextInputType.text,
        suffixIconColor: iconColor??WAPrimaryColor1,
        textStyle: GoogleFonts.montserrat(fontSize:12, fontWeight: FontWeight.bold),
        isPassword: obscure ?? false,
        inputFormatters: [
          isNumber == true
              ? FilteringTextInputFormatter.digitsOnly
              : FilteringTextInputFormatter.deny('')
        ],
        controller: controller,
      ),),
    ],
  );
}

Future<void> ModalText(
    context, String title, String text, List<IconsButton> act) {
  return Dialogs.materialDialog(
      barrierDismissible: true,
      color: WALightColor,
      title: title,
      customView: Container(
        height: MediaQuery.of(context).size.height * 0.08,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(text,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: primaryTextStyle(color: Colors.black54, size: 16)),
      ),
      customViewPosition: CustomViewPosition.BEFORE_ACTION,
      context: context,
      actions: act);
}

Future<void> ModalContainer(
    context, String title, Widget component, List<IconsButton> act, {bool? barrierDismissible, bool? titleShow=true, bool? transparentBackground=false }) {
  return Dialogs.materialDialog(
      barrierDismissible: barrierDismissible??true,
      color: transparentBackground == true?Colors.transparent:WALightColor,
      title: titleShow == true?title:null,
      customView: component,
      customViewPosition: CustomViewPosition.BEFORE_ACTION,
      context: context,
      actions: act
      // [
      // IconsButton(
      //   onPressed: () {
      //     Navigator.pop(context);
      //   },
      //   text: 'Kembali',
      //   iconData: Icons.arrow_back,
      //   color: WAInfo1,
      //   textStyle: TextStyle(color: WALightColor),
      //   iconColor: WALightColor,
      // ),
      // ]
      );
}

void ModalContainerBottom(
    context, String title, Widget component, List<IconsButton> act) {
  return Dialogs.bottomMaterialDialog(
      barrierDismissible: true,
      color: WALightColor,
      title: title,
      customView: component,
      customViewPosition: CustomViewPosition.BEFORE_ACTION,
      context: context,
      actions: act
      // [
      // IconsButton(
      //   onPressed: () {
      //     Navigator.pop(context);
      //   },
      //   text: 'Kembali',
      //   iconData: Icons.arrow_back,
      //   color: WAInfo1,
      //   textStyle: TextStyle(color: WALightColor),
      //   iconColor: WALightColor,
      // ),
      // ]
      );
}

void AlertText(context, Color colorBackground, Color colorText, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: colorBackground,
      content: Text(
        text,
        style: primaryTextStyle(size: 14, color: colorText),
      )));
}

String removeBase64(String img) {
  if (img.contains('data:image/png;base64, ') == true) {
    var img64 = img.split('data:image/png;base64, ');
    String imgNew = img64[1].replaceAll(RegExp(r'\s+'), '');
    return imgNew;
  } else {
    return '';
  }
}

final ImagePicker _picker = ImagePicker();

CustomBloc _imgBloc = CustomBloc();

Widget uploadSinglePic(
  context,
  CustomBloc customBloc,
  String pathImg,
  bool base64, {
  String? label,
  bool? isGallery= false,
}) {
  XFile? image;
  
  Future<Uint8List> compress(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      // minHeight: 1920,
      // minWidth: 1080,
      quality: 60,
      rotate: 0,
    );
    print(list.length);
    print(result.length);
    return result;
  }

  Future getImageGallery(context) async {
    final XFile? imageFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    image = imageFile!;

    final bytes = File(image!.path).readAsBytesSync();
    final bytesCompress = await  compress(bytes);
    String img64 = base64Encode(bytesCompress);
    customBloc.changeVal(img64);
    print(img64);
    Navigator.pop(context);
  }

  Future getImageCamera(context) async {
    final XFile? imageFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    image = imageFile!;
    final bytes = File(image!.path).readAsBytesSync();
    final bytesCompress = await  compress(bytes);
    String img64 = base64Encode(bytesCompress);
    customBloc.changeVal(img64);
    print(img64);
    Navigator.pop(context);
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        label ?? '',
        style: primaryTextStyle(size: 14, color: WADisableColor),
      ),
      SizedBox(
        height: 0.01 * MediaQuery.of(context).size.height,
      ),
      BlocBuilder(
          bloc: customBloc,
          buildWhen: (previous, current) {
            if (previous != current) {
              return true;
            } else {
              return false;
            }
          },
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                ModalContainerBottom(
                    context,
                    label??'Pilih',
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              getImageCamera(context);
                            },
                            child: SizedBox(
                              width: 0.15 * MediaQuery.of(context).size.width,
                              child: Image.asset(
                                'assets/img/icon_camera.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 0.1 * MediaQuery.of(context).size.width,
                          ),
                         isGallery==true? GestureDetector(
                            onTap: () {
                              getImageGallery(context);
                            },
                            child: SizedBox(
                              width: 0.15 * MediaQuery.of(context).size.width,
                              child: Image.asset(
                                'assets/img/icon_gallery.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ):const SizedBox(),
                        ],
                      ),
                    ),
                    []);
              },
              child: customBloc.state != ''
                  ? Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              //     FileImage(
                              //   File(
                              //     _image!.path,
                              //   ),
                              // ),

                              MemoryImage(base64Decode(base64 == true
                                  ? removeBase64(customBloc.state)
                                  : customBloc.state)),
                          maxRadius: 0.15 * MediaQuery.of(context).size.width,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 0.20 * MediaQuery.of(context).size.width,
                            left: 0.22 * MediaQuery.of(context).size.width,
                          ),
                          child: const CircleAvatar(radius: 15, backgroundColor: WAPrimaryColor1,child: Icon(
                            Icons.camera_alt,
                            color: WALightColor,
                            size: 20,
                          ),),
                        )
                      ],
                    )
                  : Stack(
                      children: [
                        SizedBox(
                          width: 0.3 * MediaQuery.of(context).size.width,
                          height: 0.3 * MediaQuery.of(context).size.width,
                          child: Image.asset(
                            pathImg,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 0.20 * MediaQuery.of(context).size.width,
                            left: 0.22 * MediaQuery.of(context).size.width,
                          ),
                          child: const CircleAvatar(radius: 15, backgroundColor: WAPrimaryColor1,child: Icon(
                            Icons.camera_alt,
                            color: WALightColor,
                            size: 20,
                          ),),
                        )
                      ],
                    ),
            );
          }),
    ],
  );
}

String date2(String datex) {
  var date = datex.split(' ');
  var date2 = date[0].split('-');
  String tanggal = date2[2];
  String bulan = '';
  switch (date2[1]) {
    case '01':
      bulan = 'Januari';
      break;
    case '02':
      bulan = 'Februari';
      break;
    case '03':
      bulan = 'Maret';
      break;
    case '04':
      bulan = 'April';
      break;
    case '05':
      bulan = 'Mei';
      break;
    case '06':
      bulan = 'Juni';
      break;
    case '07':
      bulan = 'Juli';
      break;
    case '08':
      bulan = 'Agustus';
      break;
    case '09':
      bulan = 'September';
      break;
    case '10':
      bulan = 'Oktober';
      break;
    case '11':
      bulan = 'November';
      break;
    default:
      bulan = 'Desember';
      break;
  }
  String tahun = date2[0];
  return '$tanggal $bulan $tahun';
}

String dayCheck(String number){
  if(number == '1'){
    return 'Senin';
  }else if(number == '2') {
    return 'Selasa';
  }else if(number == '3') {
    return 'Rabu';
  }else if(number == '4') {
    return 'Kamis';
  }else if(number == '5') {
    return 'Jumat';
  }else if(number == '6') {
    return 'Sabtu';
  }else {
    return 'Minggu';
  }
}

String spaceBetweenWord(String sentences){
  var words = sentences.split(' ');
  String wordCheck = '';
  for(int i = 0; i < words.length; i++){
    if(i != 0){
      wordCheck+='\n${words[i]}';
    }else{
      wordCheck+=words[i];
    }
   
  }

  return wordCheck;

}

Widget screenshotAndShare(
  context,
   String text,
  String subject,
  List<XFile> imagePaths) {

// final controller = CropController(
//     aspectRatio: 0.2,
//     defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
//   );

  SnackBar getResultSnackBar(ShareResult result) {
    return SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Share result: ${result.status}"),
          if (result.status == ShareResultStatus.success)
            Text("Shared to: ${result.raw}")
        ],
      ),
    );
  }

  void onShareWithResult(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    // final scaffoldMessenger = ScaffoldMessenger.of(context);
    ShareResult shareResult;
    if (imagePaths.isNotEmpty) {
      final files = imagePaths;
      // for (var i = 0; i < imagePaths.length; i++) {
      //   files.add(XFile(imagePaths[i], name: imageNames[i]));
      // }
      shareResult = await Share.shareXFiles(files,
          text: text,
          subject: subject,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else {
      shareResult = await Share.shareWithResult(text,
          subject: subject,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
    // AlertText(context, WAPrimaryColor1, WALightColor, shareResult.raw);
    // scaffoldMessenger.showSnackBar(getResultSnackBar(shareResult));
  }

  return SizedBox(
     height: 0.4*MediaQuery.of(context).size.height, child: 
      SingleChildScrollView(child: 
      Column(children: [
        Image.file(File(imagePaths[0].path)),
        Row(children: [
          ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: WADangerColor,
                      backgroundColor:WADangerColor
                    ),
                    onPressed: (){Navigator.pop(context);},
                    child:Text('Kembali', style: GoogleFonts.aBeeZee(fontSize:14, fontWeight:FontWeight.bold, color:WALightColor),),
                  ),
          ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: WAPrimaryColor1,
                      backgroundColor:WAPrimaryColor1
                    ),
                    onPressed: text.isEmpty && imagePaths.isEmpty
                        ? null
                        : () => onShareWithResult(context),
                    child:Text('Share Now', style: GoogleFonts.aBeeZee(fontSize:14, fontWeight:FontWeight.bold, color:WALightColor),),
                  )
        ],)
      ],),)
      ,);
}


  String? _currentAddress;
  Position? _currentPosition;

  void loadLocation(context, CustomBloc lat, CustomBloc long)async{
    // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _getCurrentPosition(context, lat, long);
  }

  Future<void> _getCurrentPosition(context, CustomBloc lat, CustomBloc long) async {
  final hasPermission = await _handleLocationPermission(context);
  if (!hasPermission) return;
  await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high)
      .then((Position position) {
   _currentPosition = position;
   lat.changeVal(position.latitude.toString());
   long.changeVal(position.longitude.toString());
   loadLatLongUser(_currentPosition!.latitude.toString(), _currentPosition!.longitude.toString());
  }).catchError((e) {
    debugPrint(e);
  });
}
  
  
  Future<bool> _handleLocationPermission(context) async {
  bool serviceEnabled;
  LocationPermission permission;
  
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Location services are disabled. Please enable the services')));
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {   
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')));
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Location permissions are permanently denied, we cannot request permissions.')));
    return false;
  }
  return true;
}



Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 + 
          c(lat1 * p) * c(lat2 * p) * 
          (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  String rupiah(double harga) {
  MoneyFormatter fmf = MoneyFormatter(
      amount: harga,
      settings: MoneyFormatterSettings(
          symbol: 'IDR',
          thousandSeparator: '.',
          decimalSeparator: ',',
          symbolAndNumberSeparator: ' ',
          fractionDigits: 2,
          compactFormatType: CompactFormatType.short));
  return fmf.output.nonSymbol;
}