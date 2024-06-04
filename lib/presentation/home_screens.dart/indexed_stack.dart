import 'package:arlex_getx/constants/colors.dart';
import 'package:arlex_getx/controller/home_screen_controller.dart';
import 'package:arlex_getx/presentation/home_screens.dart/chat_with_doc_screen.dart';
import 'package:arlex_getx/presentation/home_screens.dart/chat_with_images.dart';
import 'package:arlex_getx/presentation/home_screens.dart/home_screen.dart';
import 'package:arlex_getx/presentation/home_screens.dart/image_generation_screen.dart';
import 'package:arlex_getx/presentation/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SectionItem {
  final int index;
  final String title;
  final Widget widget;

  SectionItem(this.index, this.title, this.widget);
}

class IndexedStackScreen extends StatefulWidget {
  const IndexedStackScreen({super.key});

  @override
  State<IndexedStackScreen> createState() => _IndexedStackScreenState();
}

class _IndexedStackScreenState extends State<IndexedStackScreen> {
  int _selectedItem = 0;

  final _sections = <SectionItem>[
    SectionItem(0, 'Wisnolect', HomeScreen()),
    SectionItem(1, 'Generate AI Images', ImageGenerationScreen()),
    SectionItem(2, 'Chat with Images', ChatWithImagesScreen()),
    SectionItem(3, 'Chat With Doc', ChatWithDocScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.homescreenBgColor,
        centerTitle: true,
        leading: Builder(builder: (context) {
          return InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: SvgPicture.asset(
                'assets/svgs/left_bar.svg',
                height: 20.h,
                width: 20.w,
                // color: Colors.black,
              ),
            ),
          );
        }),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              height: 30.h,
              decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(30.r)),
              child: Row(
                children: [
                  Text(
                    _sections[_selectedItem].title,
                    style: TextStyle(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  SvgPicture.asset(
                    "assets/svgs/magic_stick.svg",
                    width: 15.w,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          InkWell(
              onTap: () async {
                Get.find<HomeScreenController>().saveToFirebase();
              },
              child: GetBuilder(
                  init: Get.find<HomeScreenController>(),
                  builder: (controller) {
                    return Icon(
                      Icons.add_to_drive_sharp,
                      size: 25.sp,
                      color: controller.chats.isEmpty
                          ? Colors.grey.shade300
                          : Colors.black,
                    );
                  })
              /* SvgPicture.asset(
              'assets/svgs/edit_icon.svg',
              height: 25.h,
              width: 25.w,
              color: Colors.black,
            ),*/
              ),
          SizedBox(
            width: 10.w,
          ),
          PopupMenuButton<int>(
            color: AppColors.secondaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            // initialValue: _selectedItem,
            onSelected: (value) => setState(() => _selectedItem = value),
            itemBuilder: (context) => _sections.map((e) {
              return PopupMenuItem<int>(
                  value: e.index,
                  child: Text(
                    e.title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ));
            }).toList(),
            child: const Icon(Icons.more_vert_rounded),
          ),
          SizedBox(
            width: 10.w,
          )
        ],
      ),
      body: IndexedStack(
        index: _selectedItem,
        children: _sections.map((e) => e.widget).toList(),
      ),
    );
  }
}
