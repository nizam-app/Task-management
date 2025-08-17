import 'package:Task_Management/core/constants/color_control/all_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
  filled: true,
  fillColor: AllColor.yellow50,
  contentPadding: EdgeInsets.symmetric(vertical: 16.h,horizontal: 20.w),
  // prefixIconColor: Colors.grey,
  hintStyle: TextStyle(color: AllColor.textHintColor, fontSize: 14.sp,fontWeight: FontWeight.w400,),
  suffixIconColor: Colors.grey,
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(50),
    borderSide: BorderSide(color: AllColor.textBorderColor, width: 0.5.sp),
  ),
enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(50),
    borderSide: BorderSide(color: AllColor.textBorderColor, width: 0.5.sp),
  ),);
