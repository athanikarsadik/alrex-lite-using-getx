import 'package:arlex_getx/constants/colors.dart';
import 'package:arlex_getx/models/chat_with_doc_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatWithDocWidget extends StatelessWidget {
  final ChatWithDocModel model;
  const ChatWithDocWidget({super.key, required this.model});

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
                        child: Text(model.prompt,
                            style: TextStyle(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2))),
              ],
            ),
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5.w, top: 15.h),
                child: Icon(Icons.copy_all_outlined, size: 25.sp),
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                child: Markdown(
                    shrinkWrap: true,
                    selectable: true,
                    softLineBreak: true,
                    physics: const NeverScrollableScrollPhysics(),
                    data: model.response ?? 'cannot generate data!'),
              )),
            ],
          ),
      ],
    );
  }
}
