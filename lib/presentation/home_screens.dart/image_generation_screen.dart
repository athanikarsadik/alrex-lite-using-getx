import 'package:arlex_getx/presentation/widgets/bottom_input_prompt_row.dart';
import 'package:arlex_getx/presentation/widgets/image_generation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../constants/colors.dart';
import '../../controller/home_screen_controller.dart';
import '../../models/image_generation_model.dart';

class ImageGenerationScreen extends StatelessWidget {
  ImageGenerationScreen({super.key});

  final _homeScreenController = Get.find<HomeScreenController>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _homeScreenController.scrollToBottomImageGen());
    return Scaffold(
      backgroundColor: AppColors.homescreenBgColor,
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                  left: 20.0.w, right: 20.0.w, top: 10.h, bottom: 20.h),
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
                        itemCount: _homeScreenController.generatedImages.length,
                        controller: _homeScreenController.imageGenerationScrollController,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final ImageGenerationModel imageModel =
                              _homeScreenController.generatedImages[index];
                          return ImageGenerationItemWidget(model: imageModel,);
                        });
                  }),
                ),
              ),
            ),
          ),
          Obx(
            () => _homeScreenController.generatingImages.value
                ? Lottie.asset('assets/lottie/loading.json',
                    width: 120.w, height: 80.h)
                : BottomInputPromptWidget(
                    inputController: _homeScreenController.inputImageGenController,
                    inputBoxIndex: 1,
                  ),
          )
        ],
      ),
    );
  }
}
