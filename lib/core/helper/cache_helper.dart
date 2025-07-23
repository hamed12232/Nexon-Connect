import 'package:shared_preferences/shared_preferences.dart';

class CachHelper {
  SharedPreferences? sharedPreferences;
  static final CachHelper _instance = CachHelper._internal();
  factory CachHelper() => _instance;
  CachHelper._internal();

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<bool> saveData({required String key, required dynamic value}) async {
    if (value is String) return await sharedPreferences!.setString(key, value);
    if (value is int) return await sharedPreferences!.setInt(key, value);
    if (value is bool) return await sharedPreferences!.setBool(key, value);
    if (value is double) return await sharedPreferences!.setDouble(key, value);
    throw Exception("this type is not supported");
  }

  dynamic getData({required String key}) {
    return sharedPreferences!.get(key);
  }

  Future<bool> removeData({required String key}) async {
    return await sharedPreferences!.remove(key);
  }
}
