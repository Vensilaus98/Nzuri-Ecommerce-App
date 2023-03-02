import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../colors/colors.dart';
import '../../../strings/home_screen_strings.dart';
import '../../my_cart_screen/my_cart_screen.dart';

class TopBarWidget extends StatelessWidget {
  const TopBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appBarTitle,
              style: GoogleFonts.robotoSlab(color: kTextColor, fontSize: 14.sp),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              username,
              style: GoogleFonts.robotoSlab(
                  color: kPrimaryColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
        // Add Notification icon
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyCartScreen()));
          },
          child: Icon(
            Icons.shopping_bag_outlined,
            size: 8.w,
            color: kIconsColor,
          ),
        )
      ],
    );
  }
}
