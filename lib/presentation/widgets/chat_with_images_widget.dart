import 'package:arlex_getx/models/chat_with_images_model.dart';
import 'package:arlex_getx/presentation/widgets/item_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../constants/colors.dart';

class ChatWithImagesWidget extends StatelessWidget {
  final ChatWithImagesModel chatImageModel;
  const ChatWithImagesWidget({super.key, required this.chatImageModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (chatImageModel.role == "user")
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
                        child: Text(
                            chatImageModel.prompt ??
                                'Describe the following images',
                            style: TextStyle(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2))),
              ],
            ),
          ),
        if (chatImageModel.images != null && chatImageModel.images!.isNotEmpty)
          Container(
            height: 120.h,
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
            alignment: Alignment.centerLeft,
            child: Card(
              color: AppColors.homescreenBgColor,
              child: ListView.builder(
                itemBuilder: (context, index) => ItemImageView(
                  bytes: chatImageModel.images!.elementAt(index),
                ),
                itemCount: chatImageModel.images!.length,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
              ),
            ),
          ),
        if (chatImageModel.role == "loading")
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
              ),
              Lottie.asset('assets/lottie/ai.json', width: 200.w, height: 150.h)
            ],
          ),
        if (chatImageModel.role == "model")
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
                    data: chatImageModel.response ?? 'cannot generate data!'),
              )),
            ],
          ),
      ],
    );
  }
}
