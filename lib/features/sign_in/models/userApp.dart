import 'dart:io';

class AppUser {
  String firstName;
  String secondName;
  String lastName;
  String userName;
  String phoneNumber;
  String email;
  String password;
  File profileImage;
  String imagePath;
  double lat;
  double lon;
  String userId;

  AppUser(
      {this.firstName,
      this.secondName,
      this.lastName,
      this.email,
      this.imagePath,
      this.lat,
      this.lon,
      this.password,
      this.phoneNumber,
      this.profileImage,
      this.userId,
      this.userName});
  AppUser.fromMap(Map map) {
    this.firstName = map['firstName'];
    this.secondName = map['secondName'];
    this.lastName = map['lastName'];
    this.email = map['email'];
    this.imagePath = map['imagePath'];
    this.lat = map['lat'];
    this.lon = map['lon'];
    this.phoneNumber = map['phoneNumber'];
    this.userId = map['userId'];
    this.userName = map['userName'];
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': this.firstName,
      'secondName': this.secondName,
      'lastName': this.lastName,
      'email': this.email,
      'imagePath': this.imagePath,
      'lat': this.lat,
      'lon': this.lon,
      'phoneNumber': this.phoneNumber,
      'userId': this.userId,
      'userName': this.userName,
    };
  }
}
