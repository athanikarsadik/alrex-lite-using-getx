import 'package:arlex_getx/controller/home_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';

class BottomInputPromptWidget extends StatelessWidget {
  final int inputBoxIndex;
  final TextEditingController inputController;
  final VoidCallback? onPickImages,getChatWithDocCallback;
  const BottomInputPromptWidget(
      {super.key,
      this.onPickImages,
      required this.inputController,
      this.getChatWithDocCallback,
      required this.inputBoxIndex});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: 20.0.w, right: 20.0.w, top: 10.h, bottom: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5.r,
                  blurRadius: 7.r,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: TextFormField(
              minLines: 1,
              maxLines: 3,
              autofocus: false,
              controller: inputController,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15.h),
                  suffixIcon: inputBoxIndex == 2
                      ? InkWell(
                          onTap: onPickImages,
                          child: Icon(
                            Icons.image,
                            color: Colors.black,
                            size: 30.sp,
                          ),
                        )
                      : inputBoxIndex == 3
                          ? InkWell(
                              onTap: onPickImages,
                              child: Icon(
                                Icons.drive_folder_upload_rounded,
                                color: Colors.black,
                                size: 30.sp,
                              ),
                            )
                          : SizedBox(),
                  hintText: "How can I help you?",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none),
            ),
          )),
          SizedBox(
            width: 10.w,
          ),
          GestureDetector(
            onTap: () {
              switch (inputBoxIndex) {
                case 0:
                  Get.find<HomeScreenController>().chatbotGetResponse();
                  break;
                case 1:
                  Get.find<HomeScreenController>().imageGenGetResponse();
                  break;
                case 2:
                  Get.find<HomeScreenController>().imagechatResponse();
                  break;
                case 3:
                  Get.find<HomeScreenController>().chatwithDocGetRespose();
                  break;

              }
            },
            child: Container(
              width: 55.w,
              height: 55.h,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5.r,
                    blurRadius: 7.r,
                    offset: Offset(0, 3),
                  ),
                ],
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: inputBoxIndex == 1
                  ? Padding(
                      padding: EdgeInsets.all(10.0.sp),
                      child: SvgPicture.asset(
                        'assets/svgs/Star.svg',
                      ),
                    )
                  : Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20.sp,
                    ),
            ),
          )
        ],
      ),
    );
  }
}
