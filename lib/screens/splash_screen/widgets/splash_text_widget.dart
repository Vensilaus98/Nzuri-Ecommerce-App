import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../colors/colors.dart';
import '../../../strings/splash_screen_strings.dart';

class SplashTextWidget extends StatelessWidget {
  const SplashTextWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          splashText,
          style: GoogleFonts.robotoSlab(
              color: kPrimaryColor,
              fontSize: 25.sp,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 5,
        ),
        Icon(
          Icons.shopping_bag_outlined,
          size: 10.w,
          color: kPrimaryColor,
        )
      ],
    ));
  }
}