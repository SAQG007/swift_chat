import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swift_chat/config/globals.dart';

Future<void> getPackageInfo() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  appName = packageInfo.appName;
}

void setUserName(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(swiftChatUserName, name);
}

Future<String> getUserName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(swiftChatUserName) ?? "";
}
