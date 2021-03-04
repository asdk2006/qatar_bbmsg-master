import 'package:auto_size_text/auto_size_text.dart';
import 'package:bm_social_qatar/values/colors.dart';
import 'package:bm_social_qatar/values/radii.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatelessWidget {
  Function buttonPressFun;
  String textKey;
  Color color;
  PrimaryButton(
      {this.buttonPressFun, this.textKey, this.color = AppColors.primaryColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      width: double.infinity,
      child: RaisedButton(
          color: this.color,
          child: AutoSizeText(
            translator.translate(textKey),
            style: TextStyle(color: Colors.white),
            maxLines: 1,
          ),
          shape: RoundedRectangleBorder(borderRadius: Radii.k8pxRadius),
          onPressed: () => buttonPressFun()),
    );
  }
}
