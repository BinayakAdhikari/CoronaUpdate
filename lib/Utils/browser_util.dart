import 'package:url_launcher/url_launcher.dart';

class BrowserUtil{
  BrowserUtil._();
  static Future<void> openBrowser(String url) async {
    String browserUrl = url;
    if (await canLaunch(browserUrl)) {
      await launch(browserUrl);
    } else {
      throw 'Could not launch $browserUrl';
    }
  }
}