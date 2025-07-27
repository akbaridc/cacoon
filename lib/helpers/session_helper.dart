import 'package:shared_preferences/shared_preferences.dart';

class SessionHelper {
  static const isLogin = "IS_LOGIN";

  static const id = "ID";
  static const nik = "NIK";
  static const email = "EMAIL";
  static const name = "NAME";
  static const phoneNumber = "PHONE_NUMBER";
  static const accessToken = "ACCESS_TOKEN";
  static const avatarImage = "AVATAR_IMAGE";
  static const postTitle = "POST_TITLE";

  static Future<bool> checkIsLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLogin) ?? false;
  }

  static Future<int> getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(id) ?? 0;
  }

  static Future<String> getNIK() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(nik) ?? "";
  }

  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(email) ?? '';
  }

  static Future<String> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(name) ?? '';
  }

  static Future<String> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(phoneNumber) ?? '';
  }

  static Future<String> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(accessToken)!;
  }

  static Future<String> getAvatarImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(avatarImage) ?? "";
  }

  static Future<String> getPostTitle() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(postTitle) ?? "";
  }

  static Future<bool> saveLoginSession(
    int idValue,
    String nikValue,
    String emailValue,
    String nameValue,
    String accessTokenValue,
    String? avatarImageValue,
    String? postTitleValue,

  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(id, idValue);
    await prefs.setString(nik, nikValue);
    await prefs.setString(email, emailValue);
    await prefs.setString(name, nameValue);
    await prefs.setString(accessToken, accessTokenValue);
    await prefs.setString(avatarImage, avatarImageValue ?? "");
    await prefs.setString(postTitle, postTitleValue ?? "");
    return prefs.setBool(isLogin, true);
  }

  static Future<bool> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isLogin, false);
    await prefs.setString(accessToken, "");
    return prefs.clear();
  }
}