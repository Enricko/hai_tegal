import 'dart:convert';

class Url {
    var url = 'https://haitegal.id/api/';
  // var url = 'http://10.0.2.2/haitegal/api/';
    // var url = 'http://192.168.1.56/haitegal/api/';
  // var url = 'https://kasir.wingko0.com/api/';
    // var urlPict = 'http://192.168.1.56/haitegal/media/images/';
  // var urlPict = 'http://10.0.2.2/haitegal/media/images/';
    var urlPict = 'https://haitegal.id/media/images/';
  // var urlPict = 'https://kasir.wingko0.com/assets/img/';
  String basicAuth =
      'Basic ${base64.encode(utf8.encode('h41T394l:l4k@-l4k@'))}';

  getUrl() {
    return url;
  }

  getUrlPict() {
    return urlPict;
  }
}