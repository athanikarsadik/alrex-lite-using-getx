import 'dart:io';
import 'package:arlex_getx/presentation/widgets/chat_with_doc_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../constants/colors.dart';
import '../../controller/home_screen_controller.dart';
import '../../models/chat_with_doc_model.dart';
import '../widgets/bottom_input_prompt_row.dart';
import '../widgets/item_doc_view.dart';

class ChatWithDocScreen extends StatelessWidget {
  ChatWithDocScreen({super.key});
  final _homeScreenController = Get.find<HomeScreenController>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _homeScreenController.scrollToBottomDocChat());
    return Scaffold(
      backgroundColor: AppColors.homescreenBgColor,
      body: Column(
        children: [
          GetBuilder<HomeScreenController>(builder: (_) {
            return Obx(
              () => _homeScreenController.selectedDocuments.isNotEmpty
                  ? Container(
                      height: 100.h,
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      color: AppColors.homescreenBgColor,
                      alignment: Alignment.centerLeft,
                      child: Card(
                        color: const Color(0xFF7176ED),
                        child: ListView.builder(
                          itemBuilder: (context, index) => ItemDocView(
                            file: _homeScreenController.selectedDocuments
                                .elementAt(index),
                          ),
                          itemCount:
                              _homeScreenController.selectedDocuments.length,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                        ),
                      ),
                    )
                  : const SizedBox(),
            );
          }),
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
                        itemCount: _homeScreenController.docChats.length,
                        controller:
                            _homeScreenController.chatDocScrollController,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final ChatWithDocModel model =
                              _homeScreenController.docChats[index];
                          return ChatWithDocWidget(model: model,);
                        });
                  }),
                ),
              ),
            ),
          ),
          Obx(
            () => _homeScreenController.streamingDocChat.value
                ? Lottie.asset('assets/lottie/loading.json',
                    width: 120.w, height: 80.h)
                : BottomInputPromptWidget(
                    inputController:
                        _homeScreenController.inputDocController,
                    inputBoxIndex: 3,
                    getChatWithDocCallback: ()async{
                      _homeScreenController.chatwithDocGetRespose();
                    },
                    onPickImages: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        allowMultiple: true,
                        type: FileType.custom,
                        allowedExtensions: [
                          'pdf',
                          // 'doc',
                          // 'docx',
                          // 'ppt',
                          // 'pptx'
                        ],
                      );
                      if (result != null) {
                        // Not sure if I should only get file path or complete data (this was in package documentation)
                        List<File> files =
                            result.paths.map((path) => File(path!)).toList();
                        _homeScreenController.selectedDocuments.value = files;
                        await _homeScreenController.uploadDocs();
                      } else {
                        // User canceled the picker
                      }
                      _homeScreenController.update();
                    },
                  ),
          )
        ],
      ),
    );
  }
}
