import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../colors/colors.dart';
import '../home_screen/home_screen.dart';
import 'widgets/splash_text_widget.dart';

void main() {
  runApp(const MySplashScreen());
}

class MySplashScreen extends StatelessWidget {
  const MySplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: ((context, orientation, deviceType) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        );
      }),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //Call the homescreen after the splash screen
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5),(() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyHomeScreen()))));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
      width: 100.w,
      height: 100.h,
      decoration: BoxDecoration(color: kBackgroundColor),
      child: const SplashTextWidget(),
    )));
  }
}
