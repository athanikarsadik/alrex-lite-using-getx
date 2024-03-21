import 'package:arlex_getx/controller/home_screen_controller.dart';
import 'package:arlex_getx/presentation/widgets/bottom_input_prompt_row.dart';
import 'package:arlex_getx/presentation/widgets/chat_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../constants/colors.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _homeScreenController = Get.find<HomeScreenController>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _homeScreenController.scrollToBottomChat());
    return Scaffold(
      backgroundColor: AppColors.homescreenBgColor,
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left:20.0.w,right: 20.0.w,top: 10.h,bottom: 20.h),
              margin: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r)),
              child: Align(
                alignment: Alignment.topCenter,
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: GetBuilder<HomeScreenController>(builder: (_) {
                    return ListView.builder(
                        itemCount: _homeScreenController.chats.length,
                        controller: _homeScreenController.chatScrollController,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final Content content =
                              _homeScreenController.chats[index];
                          return ChatItemWidget(
                            content: content,
                          );
                        });
                  }),
                ),
              ),
            ),
          ),
          Obx(
            () => _homeScreenController.streamingData.value
                ? Lottie.asset('assets/lottie/loading.json',
                    width: 120.w, height: 80.h)
                : BottomInputPromptWidget(
                    inputController: _homeScreenController.inputChatController,
                    inputBoxIndex: 0,
                  ),
          )
        ],
      ),
    );
  }
}
