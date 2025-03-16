import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:hai_tegal/bloc/custom_bloc.dart';
import 'package:hai_tegal/master/account_contrroller.dart';
import 'package:hai_tegal/service/local_storage.dart';
import 'package:hai_tegal/service/url.dart';
import 'package:http/http.dart' as http;

CustomBloc latitudeUserCB = CustomBloc();
CustomBloc longitudeUserCB = CustomBloc();
GetStorage user = LocalStorage().user;
class Api {
  var url = Url().getUrl();

  Future doRegister(email, username, password, phone, img, userMobileDateBirth) async {
    Map<String, String> headers = {
      'authorization': Url().basicAuth,
    };

    Map<String, String> body = {
      "user_email": email, 
      "user_name": username,
      "user_pass":password,
      "user_img":img,
      "user_phone":phone,
      "user_latitude":"",
      "user_longitude":"",
      "user_address":"",
      "user_date_birth":userMobileDateBirth??'0000-00-00',
      
    };

    final dataRes = await http.post(Uri.parse(url + 'auth/register'),
        headers: headers, body: body);

    var data = json.decode(dataRes.body);
    // if (data['res'] == true) {
    //   user.write('username', data['data']['username']);
    //   user.write('pass', password);
    // }

    print(data);
    return data;
  }

  Future doLogin(email, password) async {
    Map<String, String> headers = {
      'authorization': Url().basicAuth,
    };

    Map<String, String> body = {"user_email": email, "user_pass": password};
    final dataLogin = await http.post(Uri.parse(url + 'auth/login'),
        headers: headers, body: body);

    var data = json.decode(dataLogin.body);
    if (data['res'] == true) {
      user.write('email', email);
      user.write('pass', password);
    }
    print('${user.read('email')}');
    print('${user.read('pass')}');
    print(data);
    return data;
  }

  Future getBannerAll()async{
     Map<String, String> headers = {
      'authorization': Url().basicAuth,
    };

    // Map<String, String> body = {"key": key, "parent_category":parentCategory};
    final dataLogin = await http.get(Uri.parse(url + 'banner/all'),
        headers: headers);

    var data = json.decode(dataLogin.body);

    print(data);
    return data;
  }

  Future getHomeAll()async{
     Map<String, String> headers = {
      'authorization': Url().basicAuth,
    };

    // Map<String, String> body = {"key": key, "parent_category":parentCategory};
    final dataLogin = await http.get(Uri.parse(url + 'home'),
        headers: headers);

    var data = json.decode(dataLogin.body);

    print(data);
    return data;
  }

  Future getBoardingAll()async{
     Map<String, String> headers = {
      'authorization': Url().basicAuth,
    };

    // Map<String, String> body = {"key": key, "parent_category":parentCategory};
    final dataLogin = await http.get(Uri.parse(url + 'boarding'),
        headers: headers);

    var data = json.decode(dataLogin.body);

    print(data);
    return data;
  }


  Future getCategory(key, parentCategory)async{
     Map<String, String> headers = {
      'authorization': Url().basicAuth,
    };

    Map<String, String> body = {"key": key, "parent_category":parentCategory};
    final dataLogin = await http.post(Uri.parse(url + 'post/category'),
        headers: headers, body: body);

    var data = json.decode(dataLogin.body);

    print(data);
    return data;
  }

  Future getPost(key, category, limit, postId)async{
     Map<String, String> headers = {
      'authorization': Url().basicAuth,
    };

    Map<String, String> body = {"key": key, "category": category, "limit": limit, "post_id": postId };
    final dataLogin = await http.post(Uri.parse(url + 'post/post'),
        headers: headers, body: body);

    var data = json.decode(dataLogin.body);

    print(data);
    return data;
  }

  Future getTagAll(key)async{
     Map<String, String> headers = {
      'authorization': Url().basicAuth,
    };

    Map<String, String> body = {"key": key };
    final dataLogin = await http.post(Uri.parse(url + 'post/posttags'),
        headers: headers, body: body);

    var data = json.decode(dataLogin.body);

    print(data);
    return data;
  }


  Future getTag(key, postId, tagsId)async{
     Map<String, String> headers = {
      'authorization': Url().basicAuth,
    };

    Map<String, String> body = {"key": key,"post_id": postId, "tags_id": tagsId };
    final dataLogin = await http.post(Uri.parse(url + 'post/tags'),
        headers: headers, body: body);

    var data = json.decode(dataLogin.body);

    print(data);
    return data;
  }

  Future getNearest(lat, long, cat, radius)async{
     Map<String, String> headers = {
      'authorization': Url().basicAuth,
    };

    Map<String, String> body = {"latitude": lat.toString(), "longitude": long.toString(), "category_id": cat, "radius": radius.toString()};
    final dataLogin = await http.post(Uri.parse(url + 'post/nearest'),
        headers: headers, body: body);

    var data = json.decode(dataLogin.body);

    print(data);
    return data;
  }

    Future getHighest(cat)async{
     Map<String, String> headers = {
      'authorization': Url().basicAuth,
    };

    Map<String, String> body = {"category_id": cat};
    final dataLogin = await http.post(Uri.parse(url + 'post/highest'),
        headers: headers, body: body);

    var data = json.decode(dataLogin.body);

    print(data);
    return data;
  }

  Future getImgPost(key, postId, limit, categoryId)async{
     Map<String, String> headers = {
      'authorization': Url().basicAuth,
    };

    Map<String, String> body = {"key": key, "post_id": postId, "limit": limit, "category_id": categoryId};
    final dataLogin = await http.post(Uri.parse(url + 'post/img'),
        headers: headers, body: body);

    var data = json.decode(dataLogin.body);

    print(data);
    return data;
  }

  Future getVenuePost(key, postId)async{
     Map<String, String> headers = {
      'authorization': Url().basicAuth,
    };

    Map<String, String> body = {"key": key, "post_id": postId};
    final dataLogin = await http.post(Uri.parse(url + 'post/venue'),
        headers: headers, body: body);

    var data = json.decode(dataLogin.body);

    print(data);
    return data;
  }

  Future getEventPost(key, postId, startDate, endDate)async{
     Map<String, String> headers = {
      'authorization': Url().basicAuth,
    };

    Map<String, String> body = {"key": key, "post_id": postId, "start_date": startDate, "end_date": endDate};
    final dataLogin = await http.post(Uri.parse(url + 'post/event'),
        headers: headers, body: body);

    var data = json.decode(dataLogin.body);

    print(data);
    return data;
  }

  Future getSaved(key)async{
     Map<String, String> headers = {
      'authorization': Url().basicAuth,
    };

    Map<String, String> body = {"key": key, "user_id": '${userDetailMB.state['user_id']}' };
    final dataLogin = await http.post(Uri.parse(url + 'post/saved'),
        headers: headers, body: body);

    var data = json.decode(dataLogin.body);

    print(data);
    return data;
  }

  Future addSaved(postId, postSavedStatus, postSavedDttm )async{
     Map<String, String> headers = {
      'authorization': Url().basicAuth,
    };

    Map<String, String> body = {"post_id": postId, "post_saved_status": postSavedStatus, "post_saved_dttm": postSavedDttm, "user_id": '${userDetailMB.state['user_id']}'};
    final dataLogin = await http.post(Uri.parse(url + 'post/addSaved'),
        headers: headers, body: body);

    var data = json.decode(dataLogin.body);

    print(data);
    return data;
  }

  Future delSaved(postSavedId)async{
     Map<String, String> headers = {
      'authorization': Url().basicAuth,
    };

    Map<String, String> body = {"post_saved_id": postSavedId };
    final dataLogin = await http.post(Uri.parse(url + 'post/delSaved'),
        headers: headers, body: body);

    var data = json.decode(dataLogin.body);

    print(data);
    return data;
  }

  Future getComment(postId)async{
     Map<String, String> headers = {
      'authorization': Url().basicAuth,
    };

    Map<String, String> body = {"post_id": postId };
    final dataLogin = await http.post(Uri.parse(url + 'comment/all/'),
        headers: headers, body: body);

    var data = json.decode(dataLogin.body);

    print(data);
    return data;
  }

  Future addComment(postId, commentTxt, commentRating, commentStatus, commentDttm)async{
     Map<String, String> headers = {
      'authorization': Url().basicAuth,
    };

    Map<String, String> body = {"post_id": postId, "comment_txt":commentTxt, "comment_rating":commentRating, "comment_status":commentStatus, "comment_dttm":commentDttm,  "user_id":'${userDetailMB.state['user_id']}'};
    final dataLogin = await http.post(Uri.parse(url + 'comment/addComment/'),
        headers: headers, body: body);

    var data = json.decode(dataLogin.body);

    print(data);
    return data;
  }

  Future updateComment(commentId, postId, commentTxt, commentRating, commentStatus, commentDttm)async{
     Map<String, String> headers = {
      'authorization': Url().basicAuth,
    };

    Map<String, String> body = {"comment_id": commentId,"post_id": postId, "comment_txt":commentTxt, "comment_rating":commentRating, "comment_status":commentStatus, "comment_dttm":commentDttm,  "user_id":'${userDetailMB.state['user_id']}'  };
    final dataLogin = await http.post(Uri.parse(url + 'comment/updateComment/'),
        headers: headers, body: body);

    var data = json.decode(dataLogin.body);

    print(data);
    return data;
  }

  Future delComment(commentId)async{
     Map<String, String> headers = {
      'authorization': Url().basicAuth,
    };

    Map<String, String> body = {"comment_id": commentId };
    final dataLogin = await http.post(Uri.parse(url + 'comment/delComment/'),
        headers: headers, body: body);

    var data = json.decode(dataLogin.body);

    print(data);
    return data;
  }


  void logout() {
    user.remove('username');
    user.remove('pass');
  }

  Future changeProfile(email, username, img, phone, lat, long, address, dateBirth) async {
    Map<String, String> headers = {
      'authorization': Url().basicAuth,
    };

    Map<String, String> body = {
      "user_email": email, 
      "user_name": username,
      "user_pass":'${user.read('pass')}',
      "user_img":img??'',
      "user_phone":phone??'',
      "user_latitude":long??'',
      "user_longitude":lat??'',
      "user_address":address??'',
      "user_date_birth":dateBirth??'0000-00-00',
      "user_id":userDetailMB.state['user_id'].toString(),
    };

    final dataLogin = await http.post(Uri.parse(url + 'auth/update'),
        headers: headers, body: body);

    var data = json.decode(dataLogin.body);

    print(data);
    return data;
  }

  Future resetPass(password) async {
    Map<String, String> headers = {
      'authorization': Url().basicAuth,
    };
    Map<String, String> body = {
      'user_id': userDetailMB.state['user_id'],
      'password': password,
    };

    final dataLogin = await http.post(Uri.parse(url + 'auth/changePass'),
        headers: headers, body: body);

    var data = json.decode(dataLogin.body);

    print(data);
    return data;
  }


}