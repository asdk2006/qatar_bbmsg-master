import 'dart:io';

class AppUser {
  String userName;
  String email;
  String imagePath;
  String userId;

  AppUser({
    this.email,
    this.userName,
    this.imagePath,
    this.userId,
  });
  AppUser.fromMap(Map map) {
    this.userName = map['userName'];
    this.email = map['email'];
    this.userId = map['userId'];
    this.imagePath = map['imagePath'];
  }

  Map<String, dynamic> toJson() {
    return {
      'email': this.email,
      'imageFile': this.imagePath,
      'userName': this.userName,
      'userId': this.userId
    };
  }
}
