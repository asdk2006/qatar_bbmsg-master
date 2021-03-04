import 'package:bm_social_qatar/backend/AppGet.dart';
import 'package:bm_social_qatar/backend/firebase_helper.dart';
import 'package:bm_social_qatar/features/sign_in/ui/pages/market_registration.dart';

import 'package:bm_social_qatar/services/connectvity_service.dart';
import 'package:bm_social_qatar/services/shared_prefrences_helper.dart';
import 'package:bm_social_qatar/utils/custom_dialoug.dart';
import 'package:bm_social_qatar/values/colors.dart';
import 'package:bm_social_qatar/widgets/TextField.dart';
import 'package:bm_social_qatar/widgets/empty_status_bar.dart';
import 'package:bm_social_qatar/widgets/primary_button.dart';

import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AppGet appGet = Get.put(AppGet());

  String userName;
  String password;
  saveUserName(String value) {
    this.userName = value;
  }

  savePassword(String value) {
    this.password = value;
  }

  validatepasswordFunction(String value) {
    if (value.isEmpty) {
      return translator.translate('null_error');
    } else if (value.length < 8) {
      return translator.translate('password_error');
    }
  }

  validateEmailFunction(String value) {
    final bool isValid = isEmail(value.trim());
    if (value.isEmpty) {
      return translator.translate("enter_your_username");
    } else if (!isNumeric(value) && !isValid) {
      return translator.translate("your_email_invalid");
    }
    return null;
  }

  AppGet signInGetx = Get.find();
  Widget _loginLabel(context) {
    return Container(
      margin: EdgeInsets.only(top: 25.h, bottom: 25.h),
      child: Text(
        translator.translate("login"),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.primaryText,
          fontWeight: FontWeight.w500,
          fontSize: 22,
        ),
      ),
    );
  }

  final GlobalKey<FormState> loginFormKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EmptyAppBar(),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 30.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  height: 250.h,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/logo.png"))),
                  child: Container()),
              Container(
                padding: EdgeInsets.only(left: 20.w, top: 25.h, right: 20.w),
                child: Form(
                  key: loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _loginLabel(context),
                      _userNameField(),
                      _passwordField(),
                    ],
                  ),
                ),
              ),
              _loginButton(),
              _registerButton(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkUsername() async {
    final mFormData = loginFormKey.currentState;
    if (!mFormData.validate()) {
      return;
    }

    mFormData.save();

    try {
      String username = this.userName.trim().toLowerCase();
      String password = this.password.trim();
      if (ConnectivityService.connectivityStatus !=
          ConnectivityStatus.Offline) {
        signInWithEmailAndPassword(email: username, password: password);
      } else {
        CustomDialougs.utils
            .showDialoug(messageKey: 'network_error', titleKey: 'alert');
      }
    } catch (e) {
      CustomDialougs.utils
          .showDialoug(messageKey: 'e.toString()', titleKey: 'alert');
    }
  }

  Widget _userNameField() {
    return MyTextField(
      hintTextKey: 'user_name',
      nofLines: 1,
      saveFunction: saveUserName,
      validateFunction: validateEmailFunction,
    );
  }

  Widget _passwordField() {
    return MyTextField(
      hintTextKey: 'password',
      nofLines: 1,
      saveFunction: savePassword,
      validateFunction: validatepasswordFunction,
    );
  }

  Widget _loginButton() {
    return Container(
      padding: EdgeInsets.only(left: 20.w, top: 15.h, right: 20.w),
      child: PrimaryButton(
        color: AppColors.primaryColor,
        textKey: 'login',
        buttonPressFun: checkUsername,
      ),
    );
  }

  registerButtonFunction() {
    FocusScope.of(context).unfocus();
    Get.to(RegistrationPage());
  }

  Widget _registerButton() {
    return Container(
      padding: EdgeInsets.only(left: 20.w, top: 15.h, right: 20.w),
      child: PrimaryButton(
        color: Colors.black.withOpacity(0.65),
        textKey: 'register',
        buttonPressFun: registerButtonFunction,
      ),
    );
  }
}
