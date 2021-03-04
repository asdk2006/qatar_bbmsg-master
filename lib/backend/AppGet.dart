import 'dart:io';

import 'package:bm_social_qatar/utils/ProgressDialogUtils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class AppGet {
  var suggestedFriends = [].obs;
  var myImages = [].obs;
  var userMap = {}.obs;
  var allUsers = <Map<String, dynamic>>[].obs;
  var myStatictics = {}.obs;
  var myFollowers = <Map<String, dynamic>>[].obs;
  var myPosts = <Map<String, dynamic>>[].obs;
  var myFollows = <Map<String, dynamic>>[].obs;

  var userImages = [].obs;
  var userStatictics = {}.obs;
  var userFollowers = <Map<String, dynamic>>[].obs;
  var userPosts = <Map<String, dynamic>>[].obs;
  var userFollows = <Map<String, dynamic>>[].obs;

  var followedUsers = <Map<String, dynamic>>[].obs;
  setAllUsers(List<Map<String, dynamic>> list) {
    this.allUsers.value = list;
  }

  setFollowedUsers(List<Map<String, dynamic>> list) {
    this.followedUsers.value = list;
  }

  String userId;
  setUserId(String value) {
    this.userId = value;
  }

  setUserMap(Map map) {
    this.userMap.value = map;
  }

  clearVariables() {
    userMap.value = {};
    suggestedFriends.value = [];
    myImages.value = [];
    userId = '';
    allUsers.value = <Map<String, dynamic>>[];
    myStatictics.value = {};
    myFollowers.value = <Map<String, dynamic>>[];
    myPosts.value = <Map<String, dynamic>>[];
    myFollows.value = <Map<String, dynamic>>[];
    userImages.value = [];
    userStatictics.value = {};
    userFollowers.value = <Map<String, dynamic>>[];
    userPosts.value = <Map<String, dynamic>>[];
    userFollows.value = <Map<String, dynamic>>[];
    followedUsers.value = <Map<String, dynamic>>[];
  }

  var pr = ProgressDialogUtils.createProgressDialog(Get.context);
  var fileName = translator.translate('market_logo').obs;
  var isBusy = false.obs;

  File file;
  String imagePath;

  ////////////////////////////////////////////////////////////////
  ///position functions

  var position = Position(latitude: 24.4539, longitude: 54.3773).obs;
  var poitinAsString = ''.obs;
  var positionIsMarkes = false.obs;

  Future<Position> setCurrentLocation() async {
    this.position.value = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setPositionString(position.value.latitude, position.value.longitude);
    return position.value;
  }

  setPositionString(double latitude, double longitude) {
    this.poitinAsString.value =
        '${latitude.toStringAsFixed(3)} - ${longitude.toStringAsFixed(3)}';
  }

  setPositionValue(Position position) {
    this.position.value = position;
    setPositionString(position.latitude, position.longitude);
  }
}
