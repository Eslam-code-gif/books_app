import 'package:flutter/material.dart';
import 'package:books_app/const/colors.dart';

abstract class AppStyles{
  static const TextStyle heading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    fontFamily: 'Bungee',
    color: AppColors.primaryColor,
  );
  static const TextStyle title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    fontFamily: 'Bungee',
    color: AppColors.primaryText,
  );
  static const TextStyle subTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w300,
    fontFamily: 'Bungee',
    color: AppColors.primaryColor,
  );
  static const TextStyle subTitleBlack = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w300,
    fontFamily: 'Bungee',
    color: AppColors.secondaryColor,
  );
}