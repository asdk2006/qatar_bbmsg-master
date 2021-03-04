import 'dart:io';
import 'package:bm_social_qatar/backend/AppGet.dart';
import 'package:bm_social_qatar/backend/firebase_helper.dart';
import 'package:bm_social_qatar/features/sign_in/ui/pages/market_location_page.dart';
import 'package:bm_social_qatar/features/sign_in/ui/widgets/upload_file.dart';
import 'package:bm_social_qatar/services/connectvity_service.dart';
import 'package:bm_social_qatar/utils/custom_dialoug.dart';
import 'package:bm_social_qatar/values/colors.dart';
import 'package:bm_social_qatar/values/styles.dart';
import 'package:bm_social_qatar/widgets/TextField.dart';
import 'package:bm_social_qatar/widgets/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:string_validator/string_validator.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _MarketRegistrationPageState createState() => _MarketRegistrationPageState();
}

class _MarketRegistrationPageState extends State<RegistrationPage> {
  GlobalKey<FormState> marketRegFormKey = GlobalKey();
  final AppGet appGet = Get.find();
  String firstName;
  String secondName;
  String lastName;
  String phoneNumber;
  String email;
  String password;
  String password2;
  File profileImage;
  String imagePath;
  double lat;
  double lon;
  String bio;
  String userId;
  String userName;
  String city;
  String country;
  FocusNode myFocusNode;
  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
  }

  saveCountry(String country) {
    this.country = country;
  }

  saveBio(String value) {
    this.bio = value;
  }

  saveCity(String city) {
    this.city = city;
  }

  saveFirstName(String value) {
    this.firstName = value;
  }

  saveSecondName(String value) {
    this.secondName = value;
  }

  saveLastName(String value) {
    this.lastName = value;
  }

  savepassword(String value) {
    this.password = value;
  }

  savepassword2(String value) {
    this.password2 = value;
  }

  saveemail(String value) {
    this.email = value;
  }

  savephoneNumber(String value) {
    this.phoneNumber = value;
  }

  saveUserName(String value) {
    this.userName = value;
  }

  validateEmailFunction(String value) {
    if (value.isEmpty) {
      return translator.translate('null_error');
    } else if (!isEmail(value)) {
      return translator.translate('email_error');
    }
  }

  validatepasswordFunction(String value) {
    if (value.isEmpty) {
      return translator.translate('null_error');
    } else if (value.length < 8) {
      return translator.translate('password_error');
    }
  }

  nullValidation(String value) {
    if (value.isEmpty) {
      return translator.translate('null_error');
    }
  }

  testGetMaterial() {
    CustomDialougs.utils
        .showDialoug(messageKey: 'password are not matched', titleKey: 'alert');
  }

  saveForm() async {
    if (marketRegFormKey.currentState.validate()) {
      if (appGet.file != null) {
        if (appGet.positionIsMarkes.value == true) {
          marketRegFormKey.currentState.save();

          if (password == password2) {
            if (ConnectivityService.connectivityStatus !=
                ConnectivityStatus.Offline) {
              // print(firstName);
              registrationProcess(
                  fname: firstName,
                  lName: lastName,
                  mName: secondName,
                  bio: this.bio,
                  city: this.city,
                  country: this.country,
                  email: this.email,
                  lat: appGet.position.value.latitude,
                  lon: appGet.position.value.longitude,
                  password: this.password,
                  userName: this.userName,
                  phoneNumber: this.phoneNumber);
            } else {
              CustomDialougs.utils
                  .showDialoug(messageKey: 'network_error', titleKey: 'alert');
            }
          } else {
            CustomDialougs.utils.showDialoug(
                messageKey: 'password are not matched', titleKey: 'alert');
          }
        } else {
          CustomDialougs.utils.showDialoug(
              messageKey: 'market_location_error', titleKey: 'missing_element');
        }
        // Auth.authInstance.registerUsingEmailAndPassword(email, password);
      } else {
        CustomDialougs.utils
            .showDialoug(messageKey: 'file_error', titleKey: 'missing_element');
      }
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(translator.translate('register_appbar')),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        child: Form(
            key: marketRegFormKey,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    MyTextField(
                      hintTextKey: 'first_name',
                      nofLines: 1,
                      validateFunction: nullValidation,
                      saveFunction: saveFirstName,
                    ),
                    MyTextField(
                      hintTextKey: 'second_name',
                      nofLines: 1,
                      validateFunction: nullValidation,
                      saveFunction: saveSecondName,
                    ),
                    MyTextField(
                      hintTextKey: 'last_name',
                      nofLines: 1,
                      validateFunction: nullValidation,
                      saveFunction: saveLastName,
                    ),
                    MyTextField(
                      hintTextKey: 'user_name',
                      nofLines: 1,
                      validateFunction: nullValidation,
                      saveFunction: saveUserName,
                    ),
                    MyTextField(
                      hintTextKey: 'email',
                      nofLines: 1,
                      validateFunction: nullValidation,
                      saveFunction: saveemail,
                    ),
                    MyTextField(
                      hintTextKey: 'password',
                      nofLines: 1,
                      validateFunction: validatepasswordFunction,
                      saveFunction: savepassword,
                      textInputType: TextInputType.visiblePassword,
                    ),
                    MyTextField(
                      hintTextKey: 'rewrite_password',
                      nofLines: 1,
                      validateFunction: validatepasswordFunction,
                      saveFunction: savepassword2,
                      textInputType: TextInputType.visiblePassword,
                    ),
                    MyTextField(
                      hintTextKey: 'country',
                      nofLines: 1,
                      validateFunction: nullValidation,
                      saveFunction: saveCountry,
                      textInputType: TextInputType.emailAddress,
                    ),
                    MyTextField(
                      hintTextKey: 'city',
                      nofLines: 1,
                      validateFunction: nullValidation,
                      saveFunction: saveCity,
                      textInputType: TextInputType.emailAddress,
                    ),
                    MyTextField(
                      hintTextKey: 'bio',
                      nofLines: 1,
                      validateFunction: nullValidation,
                      saveFunction: saveBio,
                      textInputType: TextInputType.emailAddress,
                    ),
                    ListTile(
                        onTap: () async {
                          await Get.to(MarkertLocationCollecter());
                          myFocusNode.requestFocus();
                        },
                        leading: Icon(
                          Icons.location_on,
                          color: AppColors.primaryColor,
                        ),
                        title: Obx(() => appGet.poitinAsString.value.isEmpty
                            ? Text(translator.translate('company_location'))
                            : Text(appGet.poitinAsString.value))),
                    MyTextField(
                      focusNode: myFocusNode,
                      hintTextKey: 'tel_number',
                      nofLines: 1,
                      validateFunction: nullValidation,
                      saveFunction: savephoneNumber,
                      textInputType: TextInputType.phone,
                    ),
                    uploadFile(),
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    PrimaryButton(
                      buttonPressFun: saveForm,
                      textKey: 'register',
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
