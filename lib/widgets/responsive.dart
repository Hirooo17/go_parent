import 'package:flutter/material.dart';

class Responsive extends StatelessWidget{
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,

  });
  
  
  static bool isMobile(BuildContext context) => MediaQuery.sizeOf(context).width < 900;
  static bool isTablet(BuildContext context) => MediaQuery.sizeOf(context).width < 1280 && MediaQuery.sizeOf(context).width >= 900;
  static bool isDesktop(BuildContext context) => MediaQuery.sizeOf(context).width >= 1280;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    if(size.width >= 1280){
      return desktop;
    }else if(size.width >= 900 && tablet != null){
      return tablet!;
    }else{
      return mobile;
    }
  }
}