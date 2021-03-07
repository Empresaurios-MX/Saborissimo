import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUtils {
  static const String NULL_VALUE = 'N/A';
  static const String USER_KEY = 'USER';
  static const String PASSWORD_KEY = 'PASSWORD';
  static const String TOKEN_KEY = 'TOKEN';
  static const String LOGGED_KEY = 'IS_LOGGED';

  static Future<SharedPreferences> getPreferences() async {
    return await SharedPreferences.getInstance();
  }

  static void getToken(Function onFinish) {
    String token = '';

    getPreferences().then((preferences) => {
          if (preferences.getString(PreferencesUtils.TOKEN_KEY) != null)
            token = preferences.getString(PreferencesUtils.TOKEN_KEY),
          onFinish(token),
        });
  }

  static void isUserLogged(Function onFinish) {
    bool logged = false;

    PreferencesUtils.getPreferences().then(
      (preferences) => {
        if (preferences.getBool(PreferencesUtils.LOGGED_KEY) ?? false)
          logged = true,
        onFinish(logged),
      },
    );
  }
}
