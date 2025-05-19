import 'package:flutter/material.dart';

String uri = 'http://172.20.10.3:3000';

class GlobalVariables {
  // COLORS
  static const appBarGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 55, 101, 94),
      Color.fromARGB(255, 55, 101, 94),
    ],
    stops: [0.5, 1.0],
  );

  static const secondaryColor = Color.fromRGBO(9, 84, 105, 1);
  static const backgroundColor = Colors.white;
  static const Color greyBackgroundCOlor = Color(0xffebecee);
  static var selectedNavBarColor = Colors.cyan[800]!;
  static const unselectedNavBarColor = Colors.black87;

  static const List<String> carouselImages = [
    'https://images-eu.ssl-images-amazon.com/images/G/31/img21/Wireless/WLA/TS/D37847648_Accessories_savingdays_Jan22_Cat_PC_1500.jpg',
    'https://images-eu.ssl-images-amazon.com/images/G/31/img2021/Vday/bwl/English.jpg',
    'https://images-eu.ssl-images-amazon.com/images/G/31/img22/Wireless/AdvantagePrime/BAU/14thJan/D37196025_IN_WL_AdvantageJustforPrime_Jan_Mob_ingress-banner_1242x450.jpg',
    'https://images-na.ssl-images-amazon.com/images/G/31/Symbol/2020/00NEW/1242_450Banners/PL31_copy._CB432483346_.jpg',
    'https://images-na.ssl-images-amazon.com/images/G/31/img21/shoes/September/SSW/pc-header._CB641971330_.jpg',
  ];
  static const List<Map<String, String>> categoryImages = [
    {'title': 'cat1', 'image': 'assets/images/topc1.png'},
    {'title': 'cat2', 'image': 'assets/images/topc2.png'},
    {'title': 'cat3', 'image': 'assets/images/topc3.png'},
    {'title': 'cat4', 'image': 'assets/images/topc4.png'},
  ];
}
