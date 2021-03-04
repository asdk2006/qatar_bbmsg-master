import 'dart:io';

import 'package:bm_social_qatar/backend/AppGet.dart';
import 'package:bm_social_qatar/features/sign_in/ui/pages/login_page_test.dart';
import 'package:bm_social_qatar/main.dart';
import 'package:bm_social_qatar/services/connectvity_service.dart';
import 'package:bm_social_qatar/services/shared_prefrences_helper.dart';
import 'package:bm_social_qatar/splach.dart';
import 'package:bm_social_qatar/utils/custom_dialoug.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;
DatabaseReference dbRef =
    FirebaseDatabase.instance.reference().child("userNames");
final AppGet appGet = Get.put(AppGet());
var logger = Logger();
String usersCollectionName = 'Users';
String followersCollectionName = 'Followers';
String bloclListCollectionName = 'BlockList';
String postsCollectionName = 'Posts';
String commentsListCollectionName = 'Comments';
String likesListCollectionName = 'Likes';

////////////////////////////////////////////////////////////////////////////////////////
registrationProcess({
  String fname,
  String mName,
  String lName,
  String bio,
  String email,
  String password,
  String country,
  String city,
  String phoneNumber,
  String userName,
  double lat,
  double lon,
}) async {
  appGet.pr.show();
  try {
    bool userIsExist = await userNameExistInRealtimeDb(userName: userName);

    if (userIsExist == true) {
      throw Exception('Username is used before');
    }
    String userId =
        await registerUsingEmailAndPassword(email: email, password: password);

    if (userId == null) {
      throw ('register_failed');
    } else {
      String imageUrl = await uploadImage(file: appGet.file, userId: userId);
      if (imageUrl == null) {
        throw ('Image has not been uploaded!');
      } else {
        bool isSuccess = await saveInFirestore(
            fname: fname,
            lName: lName,
            mName: mName,
            bio: bio,
            city: city,
            country: country,
            email: email,
            imageUrl: imageUrl,
            lat: lat,
            lon: lon,
            phoneNumber: phoneNumber,
            userId: userId,
            userName: userName);

        if (isSuccess == true) {
          getUserFromFirestore(userId: userId);
          getFollowdUsers(userId);
          getAllUsers();
          getProfileStatictics(appGet.userId);
          suggestFriends(appGet.userId);

          Get.offAll(HomePage1());
        }
        if (isSuccess == false) {
          throw ('Failed Save user in firestore');
        }
      }
    }
  } on Exception catch (e) {
    appGet.pr.hide();
    CustomDialougs.utils
        .showDialoug(messageKey: e.toString(), titleKey: 'alert');
  }
}

///////////////////////////////////////////////////////////////
getCurrentUser() {}
////////////////////////////////////////////////////////////////////////////////
saveUserNameInRealtimeDb({String userName}) async {
  dbRef.push().set({"userName": userName});
}

Future<bool> userNameExistInRealtimeDb({String userName}) async {
  DataSnapshot dataSnapshot =
      await dbRef.orderByChild("userName").equalTo(userName).once();

  bool result = dataSnapshot.value == null ? false : true;
  return result;
}

///////////////////////////////////////////////////////////////////////////////////
Future<Map> getUserFromFirestore({String userId}) async {
  DocumentSnapshot documentSnapshot =
      await firestore.collection(usersCollectionName).doc(userId).get();
  Map responce = documentSnapshot.data();
  print(responce);
  appGet.userMap.value = responce;

  return responce;
}

Future<Map> getPostUserFromFirestore({String userId}) async {
  DocumentSnapshot documentSnapshot =
      await firestore.collection(usersCollectionName).doc(userId).get();
  Map responce = documentSnapshot.data();

  return responce;
}

////////////////////////////////////////////////////////////////////////////////
updateImage(File file, String userId) async {
  String image = await uploadImage(file: file, userId: userId);

  firestore
      .collection(usersCollectionName)
      .doc(userId)
      .update({'imageUrl': image});
  getUserFromFirestore(userId: userId);
}

//////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
getProfileStatictics(String myUserId) async {
  Map statictics = {};
  List<Map<String, dynamic>> list1 = await getFollowdByUsers(myUserId);

  List<Map<String, dynamic>> list2 = await getFollowdUsers(myUserId);

  List<Map<String, dynamic>> list3 = await getMyPosts();

  statictics['myPosts'] = list3.length;
  statictics['myFollowers'] = list1.length;
  statictics['myFollows'] = list2.length;
  if (myUserId == appGet.userId) {
    appGet.myStatictics.value = statictics;
  } else {
    appGet.userStatictics.value = statictics;
  }
}

////////////////////////////////////////////////////////////////////////////////
Future<List<Map<String, dynamic>>> getAllUsers() async {
  QuerySnapshot querySnapshot =
      await firestore.collection(usersCollectionName).get();
  List<Map<String, dynamic>> list =
      querySnapshot.docs.map((e) => e.data()).toList();
  appGet.setAllUsers(list);
  return list;
}

////////////////////////////////////////////////////////////////////////////////
Future<String> uploadImage({File file, String userId}) async {
  try {
    DateTime dateTime = DateTime.now();

    StorageTaskSnapshot snapshot = await firebaseStorage
        .ref()
        .child('profileImages/$userId/$dateTime.png')
        .putFile(file)
        .onComplete;
    String imageUrl = await snapshot.ref.getDownloadURL();
    appGet.pr.hide();
    return imageUrl;
  } on Exception catch (e) {
    appGet.pr.hide();

    CustomDialougs.utils
        .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    return null;
  }
}

////////////////////////////////////////////////////////////////////////////////
Future<bool> saveInFirestore(
    {String fname,
    String mName,
    String lName,
    String email,
    String bio,
    String imageUrl,
    String country,
    String city,
    String phoneNumber,
    String userName,
    double lat,
    double lon,
    String userId}) async {
  try {
    await firestore.collection(usersCollectionName).doc(userId).set({
      'firstName': fname,
      'middleName': mName,
      'lastName': lName,
      'email': email,
      'bio': email,
      'imageUrl': imageUrl,
      'country': country,
      'city': city,
      'phoneNumber': phoneNumber,
      'userName': userName,
      'longitude': lon,
      'latitude': lat,
      'userId': userId
    });
    saveUserNameInRealtimeDb(userName: userName);
    appGet.pr.hide();
    return true;
  } on Exception catch (e) {
    appGet.pr.hide();
    CustomDialougs.utils
        .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    return false;
  }
}

////////////////////////////////////////////////////////////////////////////////

Future<String> saveAssetImage(Asset asset, String userId) async {
  try {
    DateTime dateTime = DateTime.now();

    ByteData byteData =
        await asset.getByteData(); // requestOriginal is being deprecated
    List<int> imageData = byteData.buffer.asUint8List();
    StorageTaskSnapshot snapshot = await firebaseStorage
        .ref()
        .child('posts/$userId/$dateTime.png')
        .putData(imageData)
        .onComplete;
    String imageUrl = await snapshot.ref.getDownloadURL();

    return imageUrl;
  } on Exception catch (e) {
    CustomDialougs.utils
        .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    return null;
  }
}

////////////////////////////////////////////////////////////////////////////////
Future<List<String>> uploadAllImages(
    List<Asset> assets, String marketName) async {
  List<String> urls = [];
  for (int i = 0; i < assets.length; i++) {
    String url = await saveAssetImage(assets[i], marketName);
    urls.add(url);
  }
  return urls;
}

////////////////////////////////////////////////////////////////////////////////
Future<String> registerUsingEmailAndPassword({
  String email,
  String password,
}) async {
  print(email);
  try {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);

    if (userCredential != null) {
      String userId = userCredential.user.uid;
      SPHelper.spHelper.setUserCredintials(userId: userId);

      return userId;
    } else {
      CustomDialougs.utils.showDialoug(messageKey: 'Failed', titleKey: 'alert');

      return null;
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      appGet.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: 'week_password', titleKey: 'alert');
    } else {
      appGet.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: 'user_email', titleKey: 'alert');
    }
    return null;
  } catch (e) {
    CustomDialougs.utils.showDialoug(messageKey: e, titleKey: 'alert');
    return null;
  }
}

////////////////////////////////////////////////////////////////////////////////
Future<Map> signInWithEmailAndPassword({
  String email,
  String password,
}) async {
  try {
    UserCredential userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    if (userCredential != null) {
      String userId = userCredential.user.uid;

      SPHelper.spHelper.setUserCredintials(userId: userId);

      Map map = await getUserFromFirestore(userId: userId);
      getFollowdUsers(userId);
      getAllUsers();
      getProfileStatictics(appGet.userId);
      suggestFriends(appGet.userId);
      Get.offAll(HomePage1());

      return map;
    } else {
      CustomDialougs.utils.showDialoug(messageKey: 'Failed', titleKey: 'alert');

      return null;
    }
  } on FirebaseAuthException catch (e) {
    appGet.pr.hide();
    if (e.code == 'user-not-found') {
      CustomDialougs.utils
          .showDialoug(messageKey: 'invalid_email', titleKey: 'alert');
    } else if (e.code == 'wrong-password') {
      CustomDialougs.utils
          .showDialoug(messageKey: 'invalid_password', titleKey: 'alert');
    }
    return null;
  } catch (e) {
    CustomDialougs.utils
        .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    return null;
  }
}

////////////////////////////////////////////////////////////////////////
signOut() async {
  await auth.signOut();
  SPHelper.spHelper.clearUserCredintials();
  appGet.clearVariables();
  Get.off(SplashScreen());
}

//////////////////////////////////////////////////////////////////////////
String getUser() {
  if (auth.currentUser != null) {
    return auth.currentUser.uid;
  } else {
    return null;
  }
}

////////////////////////////////////////////////////////////////////////
Future<bool> followUser(String myUserId, String otherUserId) async {
  try {
    FieldValue timestamp = FieldValue.serverTimestamp();

    await firestore
        .collection(usersCollectionName)
        .doc(myUserId)
        // .update({'follow':otherUserId});
        .collection(followersCollectionName)
        .doc(otherUserId)
        .set({
      'userId': otherUserId,
      'followTime': timestamp,
      'isBlocked': false
    });
    appGet.suggestedFriends.removeWhere((e) => e['userId'] == otherUserId);
    getFollowdUsers(myUserId);
    return true;
  } on Exception catch (e) {
    CustomDialougs.utils
        .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    return false;
  }
}
////////////////////////////////////////////////////////////////////////

unFollowUser(String myId, String userId) async {
  try {
    FieldValue timestamp = FieldValue.serverTimestamp();

    await firestore
        .collection(usersCollectionName)
        .doc(myId)
        .collection(followersCollectionName)
        .doc(userId)
        .delete();
    suggestFriends(appGet.userId);
    getFollowdUsers(myId);
    return true;
  } on Exception catch (e) {
    CustomDialougs.utils
        .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    return false;
  }
}

////////////////////////////////////////////////////////////////////////
Future<List<Map<String, dynamic>>> forLoop(
    QuerySnapshot querySnapshot, String myUserId) async {
  List<Map<String, dynamic>> users = [];
  for (QueryDocumentSnapshot element in querySnapshot.docs) {
    DocumentReference documentReference =
        firestore.collection(usersCollectionName).doc(element.id);
    DocumentSnapshot documentSnapshot = await firestore
        .collection(usersCollectionName)
        .doc(element.id)
        .collection('Following')
        .doc(myUserId)
        .get();

    if (documentSnapshot.data() != null) {
      DocumentSnapshot documentSnapshot2 = await documentReference.get();

      users.add(documentSnapshot2.data());
    }
  }
  return users;
}

Future<List<Map<String, dynamic>>> getFollowdByUsers(String myUserId) async {
  try {
    QuerySnapshot querySnapshot =
        await firestore.collection(usersCollectionName).get();
    List<Map<String, dynamic>> list = await forLoop(querySnapshot, myUserId);
    list.removeWhere((element) => element['userId'] == myUserId);
    if (myUserId == appGet.userId) {
      appGet.myFollowers.value = list;
    } else {
      appGet.userFollowers.value = list;
    }

    return list;
  } on Exception catch (e) {
    CustomDialougs.utils
        .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    return null;
  }
}

////////////////////////////////////////////////////////////////////////
Future<List<Map<String, dynamic>>> getFollowdUsers(String myUserId) async {
  try {
    List<Map<String, dynamic>> list = [];
    QuerySnapshot querySnapshot = await firestore
        .collection(usersCollectionName)
        .doc(myUserId)
        .collection('Following')
        .orderBy('followTime')
        .get();

    for (QueryDocumentSnapshot queryDocumentSnapshot in querySnapshot.docs) {
      String id = queryDocumentSnapshot.id.trim();
      DocumentSnapshot documentSnapshot2 =
          await firestore.collection(usersCollectionName).doc(id).get();

      list.add(documentSnapshot2.data());
    }
    list.removeWhere((element) => element['userId'] == myUserId);

    if (myUserId == appGet.userId) {
      appGet.myFollows.value = list;
      appGet.myStatictics['myFollows'] = list.length;
    } else {
      appGet.userFollows.value = list;
      appGet.userStatictics['myFollows'] = list.length;
    }

    return list;
  } on Exception catch (e) {
    CustomDialougs.utils
        .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    return null;
  }
}

////////////////////////////////////////////////////////////////////////////////
Future<bool> blockUser(String myUserId, String otherUserId) async {
  FieldValue timestamp = FieldValue.serverTimestamp();
  try {
    firestore
        .collection(usersCollectionName)
        .doc(myUserId)
        .collection(bloclListCollectionName)
        .doc(otherUserId)
        .update({
      'isBlocked': true,
      'blockedTime': timestamp,
    });
    return true;
  } on Exception catch (e) {
    CustomDialougs.utils
        .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    return false;
  }
}

////////////////////////////////////////////////////////////////////////////////
Future<List<QueryDocumentSnapshot>> getBlockedUsers(String myUserId) async {
  try {
    QuerySnapshot querySnapshot = await firestore
        .collection(usersCollectionName)
        .doc(myUserId)
        .collection(bloclListCollectionName)
        .where('isBlocked', isEqualTo: true)
        .orderBy('blockedTime')
        .get();
    return querySnapshot.docs;
  } on Exception catch (e) {
    CustomDialougs.utils
        .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    return null;
  }
}

////////////////////////////////////////////////////////////////////////////////
Future<bool> unBlockUser(String myUserId, String otherUserId) async {
  try {
    FieldValue timestamp = FieldValue.serverTimestamp();
    firestore
        .collection(usersCollectionName)
        .doc(myUserId)
        .collection(bloclListCollectionName)
        .doc(otherUserId)
        .update({'isBlocked': false, 'blockedTime': timestamp});
    return true;
  } on Exception catch (e) {
    CustomDialougs.utils
        .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    return false;
  }
}

///////////////////////////////////////////////////////////////////////////////////
Future<List<Map<String, dynamic>>> suggestFriends(String myId) async {
  QuerySnapshot querySnapshot =
      await firestore.collection(usersCollectionName).get();
  List<Map<String, dynamic>> docs =
      querySnapshot.docs.map((e) => e.data()).toList();

  QuerySnapshot querySnapshot2 = await firestore
      .collection(usersCollectionName)
      .doc(myId)
      .collection(followersCollectionName)
      .get();
  List<Map<String, dynamic>> docs2 =
      querySnapshot2.docs.map((e) => e.data()).toList();

  docs2.forEach((element) {
    String userId = element['userId'];
    docs.removeWhere((element) => element['userId'] == userId);
  });

  docs.removeWhere((element) => element['userId'] == myId);
  appGet.suggestedFriends.value = docs;
  return docs;
}

////////////////////////////////////////////////////////////////////////////////
Future<String> addNewPost({String content, List<Asset> assetImages}) async {
  try {
    FieldValue timestamp = FieldValue.serverTimestamp();
    List<String> images =
        await uploadAllImages(assetImages, appGet.userMap['userId']);
    DocumentReference documentReference =
        await firestore.collection(postsCollectionName).add({
      'content': content,
      'images': images,
      'userId': appGet.userMap['userId'],
      'likes': [],
      'createdDate': timestamp,
      'userInfo': appGet.userMap
    });
    if (documentReference != null) {
      return documentReference.id;
    } else {
      throw Exception('Post has not been uploaded');
    }
  } on Exception catch (e) {
    CustomDialougs.utils
        .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    return null;
  }
}

///////////////////
Future<String> uploadImagepost({File file}) async {
  try {
    DateTime dateTime = DateTime.now();

    StorageTaskSnapshot snapshot = await firebaseStorage
        .ref()
        .child('postImages/${appGet.userMap['userId']}/$dateTime.png')
        .putFile(file)
        .onComplete;
    String imageUrl = await snapshot.ref.getDownloadURL();
    appGet.pr.hide();
    return imageUrl;
  } on Exception catch (e) {
    appGet.pr.hide();
    CustomDialougs.utils
        .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    return null;
  }
}

////////////////////////////
Future<String> addNewPostonimage({String content, File images}) async {
  print("userId" + appGet.userMap['userId']);
  try {
    FieldValue timestamp = FieldValue.serverTimestamp();
    // List<String> images = await uploadAllImages(assetImages, userId);
    String imagesstr = await uploadImagepost(file: images);
    DocumentReference documentReference =
        await firestore.collection(postsCollectionName).add({
      'content': content,
      'images': imagesstr,
      'userId': appGet.userMap['userId'],
      'likes': [],
      'createdDate': timestamp
    });
    if (documentReference != null) {
      return documentReference.id;
    } else {
      throw Exception('Post has not been uploaded');
    }
  } catch (error) {
    print(error);
  }
}

///////////////////////////////////////////////////////////////////////
Future<List<Map<String, dynamic>>> getMyPosts() async {
  try {
    QuerySnapshot querySnapShot = await firestore
        .collection(postsCollectionName)
        .where('userId', isEqualTo: appGet.userMap['userId'])
        .orderBy('createdDate')
        .get();
    List<Map<String, dynamic>> myPosts =
        querySnapShot.docs.map((e) => e.data()).toList();

    List<dynamic> images = [];
    myPosts.forEach((element) {
      List<dynamic> postImages = element['images'];
      images.addAll(postImages);
    });

    if (appGet.userMap['userId'] == appGet.userId) {
      appGet.myImages.value = images;
      appGet.myPosts.value = myPosts;
    } else {
      appGet.userImages.value = images;
      appGet.userPosts.value = myPosts;
    }
    return myPosts;
  } on Exception catch (e) {
    CustomDialougs.utils
        .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    return null;
  }
}

///////////////////////////////////////////////////////////////////////////////////
Stream<QuerySnapshot> getAllPosts() {
  try {
    Stream<QuerySnapshot> stream = firestore
        .collection(postsCollectionName)
        .orderBy('createdDate')
        .snapshots();
    // print(stream.toString());
    return stream;
  } on Exception catch (e) {
    CustomDialougs.utils
        .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    return null;
  }
}

///////////////////////////////////////////////////////////////////////////////////
Future<bool> deletePost(String postId) async {
  //check user id
  try {
    firestore.collection(postsCollectionName).doc(postId).delete();
    return true;
  } on Exception catch (e) {
    CustomDialougs.utils
        .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    return false;
  }
}

///////////////////////////////////////////////////////////////////////////////////
updatePost(String content, String postId) async {
  //check user id
  try {
    firestore
        .collection(postsCollectionName)
        .doc(postId)
        .update({'content': content});
    return true;
  } on Exception catch (e) {
    CustomDialougs.utils
        .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    return false;
  }
}

//////////////////////////////////////////////////////////////////////////////////
Future<Stream<QuerySnapshot>> getPostsForFollowerd() async {
  try {
    QuerySnapshot querySnapshot = await firestore
        .collection(usersCollectionName)
        .doc(appGet.userMap['userId'])
        .collection(followersCollectionName)
        .get();
    List<String> list =
        querySnapshot.docs.map((e) => e.data()['userId']).toList();
    Stream<QuerySnapshot> stream = firestore
        .collection(postsCollectionName)
        .where('userId', arrayContains: list)
        .snapshots();
    return stream;
  } on Exception catch (e) {
    CustomDialougs.utils
        .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    return null;
  }
}

///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
Future<String> addCommentToPost(String postId, String comment) async {
  try {
    FieldValue timestamp = FieldValue.serverTimestamp();
    DocumentReference documentReference = await firestore
        .collection(postsCollectionName)
        .doc(postId)
        .collection(commentsListCollectionName)
        .add({
      'userId': appGet.userMap['userId'],
      'postId': postId,
      'comment': comment,
      'createdDate': timestamp,
      'likes': [],
      'userInfo': {
        'userName': appGet.userMap['userName'],
        'email': appGet.userMap['email'],
        'firstName': appGet.userMap['firstName'],
        'middleName': appGet.userMap['middleName'],
        'lastName': appGet.userMap['lastName'],
      }
    });
    return documentReference.id;
  } on Exception catch (e) {
    CustomDialougs.utils
        .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    return null;
  }
}

///////////////////////////////////////////////////////////////////////////////////
Stream<QuerySnapshot> getAllPostComments(String postId) {
  try {
    Stream<QuerySnapshot> stream = firestore
        .collection(postsCollectionName)
        .doc(postId)
        .collection(commentsListCollectionName)
        .orderBy('createdDate')
        .snapshots();
    return stream;
  } on Exception catch (e) {
    CustomDialougs.utils
        .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    return null;
  }
}

////////////////////////////////////////////////////////////////////////////////////
Future<Map> getOneComment({String commentId, String postId}) async {
  try {
    DocumentSnapshot documentSnapshot = await firestore
        .collection(postsCollectionName)
        .doc(postId)
        .collection(commentsListCollectionName)
        .doc(commentId)
        .get();
    return documentSnapshot.data();
  } on Exception catch (e) {
    CustomDialougs.utils
        .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    return null;
  }
}

///////////////////////////////////////////////////////////////////////////////////
Future<bool> deletePostComment(String postId, String commentId) async {
  try {
    Map<dynamic, dynamic> map =
        await getOneComment(commentId: commentId, postId: postId);
    String commentUserId = map['userId'];
    if (commentUserId == appGet.userMap['userId']) {
      firestore
          .collection(postsCollectionName)
          .doc(postId)
          .collection(commentsListCollectionName)
          .doc(commentId)
          .delete();
      return true;
    } else {
      CustomDialougs.utils.showDialoug(
          messageKey: 'you cant delete other users comments',
          titleKey: 'alert');
    }
  } on Exception catch (e) {
    CustomDialougs.utils
        .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    return false;
  }
}

///////////////////////////////////////////////////////////////////////////////////
updatePostComment(String postId, String commentId, String content) async {
  try {
    Map<dynamic, dynamic> map =
        await getOneComment(commentId: commentId, postId: postId);
    String commentUserId = map['userId'];
    if (commentUserId == appGet.userMap['userId']) {
      FieldValue timestamp = FieldValue.serverTimestamp();
      firestore
          .collection(postsCollectionName)
          .doc(postId)
          .collection(commentsListCollectionName)
          .doc(commentId)
          .update({'comment': content, 'createdDate': timestamp});
      return true;
    } else {
      CustomDialougs.utils.showDialoug(
          messageKey: 'you cant update other users comments',
          titleKey: 'alert');
    }
  } on Exception catch (e) {
    CustomDialougs.utils
        .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    return false;
  }
}

///////////////////////////////////////////////////////////////////////////////////
Future<bool> addLikeToPost(String postId, List likes) async {
  try {
    Map likesMap = {};
    if (likes.isEmpty ||
        !likes
            .any((element) => element['userId'] == appGet.userMap['userId'])) {
      likesMap['userId'] = appGet.userMap['userId'];
      likesMap['userName'] = appGet.userMap['userName'];
      likes.add(likesMap);

      firestore
          .collection(postsCollectionName)
          .doc(postId)
          .update({'likes': likes});
      return true;
    } else {
      likes.removeWhere(
          (element) => element['userId'] == appGet.userMap['userId']);
      firestore
          .collection(postsCollectionName)
          .doc(postId)
          .update({'likes': likes});
      return false;
    }
  } on Exception catch (e) {
    CustomDialougs.utils
        .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    return false;
  }
}

getLike(List likes) {
  if (!likes.any((element) => element['userId'] == appGet.userMap['userId'])) {
    return false;
  } else {
    return true;
  }
}

///////////////////////////////////////////////////////////////////////////////////
Future<bool> addLikeToComment(
    String postId, String commentId, List likes) async {
  try {
    Map likesMap = {};
    if (likes.isEmpty ||
        !likes
            .any((element) => element['userId'] == appGet.userMap['userId'])) {
      likesMap['userId'] = appGet.userMap['userId'];
      likesMap['userName'] = appGet.userMap['userName'];

      likes.add(likesMap);
      logger.e('shady');
      firestore
          .collection(postsCollectionName)
          .doc(postId)
          .collection(commentsListCollectionName)
          .doc(commentId)
          .update({'likes': likes});
    } else {
      likes.removeWhere(
          (element) => element['userId'] == appGet.userMap['userId']);
      firestore
          .collection(postsCollectionName)
          .doc(postId)
          .collection(commentsListCollectionName)
          .doc(commentId)
          .update({'likes': likes});
    }
  } on Exception catch (e) {
    CustomDialougs.utils
        .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    return false;
  }
}

///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
