import 'package:bm_social_qatar/backend/firebase_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SPHelper {
  SPHelper._();

  static final SPHelper spHelper = SPHelper._();
  SharedPreferences prefs;

  Future<SharedPreferences> initSharedPreferences() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    return prefs;
  }

////////////////////////////////////////////////////////////////////////////////
  ///language
  setLanguage(String lan) async {
    prefs = await spHelper.initSharedPreferences();
    prefs.setString('language', lan);
  }

  Future<String> getLanguage() async {
    prefs = await spHelper.initSharedPreferences();
    String language = prefs.getString('language');
    return language;
  }

//////////////////////////////////////////////////////////////////////////////////
  ///terms and conditions
  Future<bool> showTermAndCondition() async {
    prefs = await spHelper.initSharedPreferences();
    bool showTermCondition = prefs.getBool('showTermCondition');
    return showTermCondition != null ? showTermCondition : true;
  }

  setShowTermAndCondition(bool value) async {
    prefs = await spHelper.initSharedPreferences();
    prefs.setBool('showTermCondition', value);
  }

  /////////////////////////////////////////////////////////////////////////
  ///first time
  Future<bool> checkIfFirstTime() async {
    prefs = await spHelper.initSharedPreferences();
    bool isFirstTime = prefs.getBool('isFirstTime');
    if (isFirstTime == null) {
      setIsNotFirstTime();
      return true;
    } else {
      return false;
    }
  }

  setIsNotFirstTime() async {
    prefs = await spHelper.initSharedPreferences();
    prefs.setBool('isFirstTime', false);
  }

//////////////////////////////////////////////////////////////////////////
  ///security
  Future<String> getUserCredintial() async {
    prefs = await spHelper.initSharedPreferences();
    String userId = prefs.getString('userId');
    if (userId != null) {
      appGet.setUserId(userId);
    }
    return userId;
  }

//////////////////////////////////////////////////////////////////////////////////
  setUserCredintials({String userId}) async {
    prefs = await spHelper.initSharedPreferences();
    prefs.setString('userId', userId);
  }

///////////////////////////////////////////////////////////////////////////////////
  clearUserCredintials() async {
    prefs = await spHelper.initSharedPreferences();
    prefs.remove('userId');
  }
}
