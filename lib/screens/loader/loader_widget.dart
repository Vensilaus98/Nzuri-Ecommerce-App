import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../colors/colors.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            decoration: BoxDecoration(
                color: kLoaderBackgroundColor,
                boxShadow: [BoxShadow(color: kBoxShadowColor,blurRadius: 10,spreadRadius: 3)],
                borderRadius: BorderRadius.all(Radius.circular(4.w))),
            width: 20.w,
            height: 20.w,
            child: Padding(
              padding: EdgeInsets.all(5.w),
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            ))
      ],
    );
  }
}
