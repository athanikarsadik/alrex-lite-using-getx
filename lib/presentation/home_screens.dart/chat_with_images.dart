import 'dart:typed_data';

import 'package:arlex_getx/models/chat_with_images_model.dart';
import 'package:arlex_getx/presentation/widgets/chat_with_images_widget.dart';
import 'package:arlex_getx/presentation/widgets/item_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import '../../constants/colors.dart';
import '../../controller/home_screen_controller.dart';
import '../widgets/bottom_input_prompt_row.dart';

class ChatWithImagesScreen extends StatelessWidget {
  ChatWithImagesScreen({super.key});

  final _homeScreenController = Get.find<HomeScreenController>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _homeScreenController.scrollToBottomImageChat());
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
                        itemCount: _homeScreenController.imageChats.length,
                        controller:
                            _homeScreenController.chatImagesScrollController,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final ChatWithImagesModel model =
                              _homeScreenController.imageChats[index];
                          return ChatWithImagesWidget(chatImageModel: model);
                        });
                  }),
                ),
              ),
            ),
          ),
          GetBuilder<HomeScreenController>(builder: (_) {
            return Obx(
              () => _homeScreenController.selectedImages.isNotEmpty
                  ? Container(
                      height: 120.h,
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      color: AppColors.secondaryColor,
                      alignment: Alignment.centerLeft,
                      child: Card(
                        // color: AppColors.secondaryColor,
                        child: ListView.builder(
                          itemBuilder: (context, index) => ItemImageView(
                            bytes: _homeScreenController.selectedImages
                                .elementAt(index),
                          ),
                          itemCount:
                              _homeScreenController.selectedImages.length,
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                        ),
                      ),
                    )
                  : SizedBox(),
            );
          }),
          Obx(
            () => _homeScreenController.streamingImageChat.value
                ? Lottie.asset('assets/lottie/loading.json',
                    width: 120.w, height: 80.h)
                : BottomInputPromptWidget(
                    inputController:
                        _homeScreenController.inputChatWithImgController,
                    inputBoxIndex: 2,
                    onPickImages: () {
                      final ImagePicker picker = ImagePicker();
                      picker.pickMultiImage().then((value) async {
                        final imagesBytes = <Uint8List>[];
                        for (final file in value) {
                          imagesBytes.add(await file.readAsBytes());
                        }

                        if (imagesBytes.isNotEmpty) {
                          _homeScreenController.selectedImages.value =
                              imagesBytes;
                        }
                      });
                      _homeScreenController.update();
                    },
                  ),
          )
        ],
      ),
    );
  }
}
