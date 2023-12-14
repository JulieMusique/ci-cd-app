import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_ui_food_delivery_app/utils/theme_provider.dart';
import 'package:provider/provider.dart';
 const sunset_orange = Color(0xFFFF4B3A);
 const concrete = Color(0xFFF2F2F2);
 const manatee = Color(0xFF9A9A9D);
 const vermilion = Color.fromARGB(255, 56, 110, 2);
 const vermilion_10 = Color.fromARGB(255, 89, 154, 23);
 const vermilion_100 = Color.fromARGB(255, 33, 64, 3);
 const silver = Color(0xFFBCBABA);
 const athens_gray = Color(0xFFF6F6F9);
 const black_05 = Color(0x0D000000);
 const athens_gray_one = Color(0xFFF4F4F8);
 const gallery = Color(0xFFEFEEEE);
 const black_50 = Color(0x80000000);
 const black_90 = Color(0xE6000000);
 const silver_one = Color(0xFFC4C4C4);
 const alabaster = Color(0xFFF9F9F9);
 const tahiti = Color(0xFFF47B0A);
 const french = Color(0xFFEB4796);
 const blue = Color(0xFF0038FF);
 
class AppColor{
  static const black = Colors.black;
   static const lighterGray = Color(0xffe0e0e0);
  static const lightGray = Color(0xffc0c1c3);
  static const placeholder = Color(0xFFB6B7B7);
  static const placeholderBg = Color(0xFFF2F2F2);
static const tertiary = Color(0xffff36b6b);
static const  white = Colors.white;
static const  light = Color(0xfff4f4f4);
static const grey = Color(0xffa3a3a3);
static const  darkGrey = Color(0xff414141);
static const  dark = Color(0xff2d2d2d);
static const  success = Color(0xff2FDB5F);
static const  warning = Color(0xffF1C75D);
static const  error = Color(0xffF77272);
static const  primaryLight = Color(0xff67E5CE);
  static const primary = Color(0xfffdc912);
static const  primaryDark = Color(0xff1EAE94);
static const secondaryLight = Color(0xffFAAC52);
  static const secondary = Color(0xff323335);
static const  secondaryDark = Color(0xffDF7B07);}
ThemeProvider themeProvider(BuildContext context) =>
    Provider.of<ThemeProvider>(context, listen: false);
Color bgPrimary(BuildContext context) =>
    themeProvider(context).isDark ? AppColor.dark : AppColor.white;