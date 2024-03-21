import 'dart:convert';
import 'dart:typed_data';

import 'package:arlex_getx/models/image_generation_model.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../constants/colors.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageGenerationItemWidget extends StatelessWidget {
  final ImageGenerationModel model;

  const ImageGenerationItemWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (model.role == "user")
          Padding(
            padding: EdgeInsets.only(bottom: 5.h, top: 5.h),
            child: Row(
              children: [
                Container(
                  width: 35.w,
                  height: 35.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: AppColors.blackColor),
                  child: const Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.all(10.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: const Color(0xFF7176ED)),
                        child: Text(model.prompt!,
                            style: TextStyle(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2))),
              ],
            ),
          )
        else if (model.role == "loading")
          Padding(
            padding: EdgeInsets.only(
                top: 10.h, bottom: 10.h, left: 20.w, right: 10.w),
            child: Container(
              width: 320.w,
              height: 320.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: AppColors.homescreenBgColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 280.w,
                      height: 280.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: AppColors.whiteColor),
                      child: Center(
                        child: Lottie.asset('assets/lottie/ai.json',
                            width: 200.w, height: 200.h),
                      )),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w, top: 5.h, right: 20.w),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svgs/Star.svg',
                          height: 20.h,
                          width: 20.w,
                          color: AppColors.secondaryColor,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          "Generating an Image..!",
                          style: TextStyle(color: Colors.black),
                        ),
                        Spacer(),
                        Icon(
                          Icons.download,
                          size: 20.sp,
                          color: AppColors.secondaryColor,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        else
          Padding(
            padding: EdgeInsets.only(
                top: 10.h, bottom: 10.h, left: 20.w, right: 10.w),
            child: Container(
              width: 320.w,
              height: 320.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: AppColors.homescreenBgColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 280.w,
                    height: 280.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: AppColors.whiteColor),
                    child: Image.memory(
                      Uint8List.fromList(base64.decode(model.imageB64!)),
                      fit: BoxFit.cover,
                      height: 280,
                      width: 280, // Adjust the height as needed
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w, top: 5.h, right: 20.w),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svgs/Star.svg',
                          height: 20.h,
                          width: 20.w,
                          color: AppColors.secondaryColor,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          "Here you go!",
                          style: TextStyle(color: Colors.black),
                        ),
                        Spacer(),
                        Icon(
                          Icons.download,
                          size: 20.sp,
                          color: AppColors.secondaryColor,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }
}
