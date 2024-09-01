import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static late SharedPreferences instance;

  static Future<void> init() async {
    instance = await SharedPreferences.getInstance();
  }

  static bool checkIfExist({required String key}) {
    final result = instance.getString(key) ?? '';

    if (result.isEmpty) {
      return false;
    }

    return true;
  }

  static void clear() {
    instance.clear();
  }
}
