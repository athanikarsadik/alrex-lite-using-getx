import 'package:arlex_getx/constants/colors.dart';
import 'package:arlex_getx/controller/home_screen_controller.dart';
import 'package:arlex_getx/helper/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});
  final controller = Get.find<HomeScreenController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290.w,
      decoration: BoxDecoration(
          color: AppColors.homescreenBgColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15.r),
              bottomRight: Radius.circular(15.r))),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
      child: Column(
        children: [
          SizedBox(
            height: 40.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  controller.clearAll();
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 170.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10.r)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/svgs/chat_icon.svg',
                        height: 20.h,
                        width: 20.w,
                        // color: Colors.black,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        "New Chat",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 40.h,
                width: 40.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r)),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/svgs/search.svg',
                    height: 20.h,
                    width: 20.w,
                    // color: Colors.black,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Divider(),
          Obx(
            () => Expanded(
                child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                itemCount: controller.drawerTitle.length,
                itemBuilder: (context, index) {
                  final model = controller.drawerTitle[index];
                  return Container(
                    width: 240.w,
                    height: 60.h,
                    padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4),
                    child: InkWell(
                      onTap: () async {
                        // print(index);
                        await controller.getChatHistoryByDocId(
                            docId: model.docId);
                        Navigator.of(context).pop();
                      },
                      child: Markdown(
                          shrinkWrap: true,
                          selectable: false,
                          softLineBreak: true,
                          physics: const NeverScrollableScrollPhysics(),
                          data: model.title),
                    ),
                  );
                },
              ),
            )),
          ),
          InkWell(
            onTap: () {
              controller.logout().then((value) {
                if (value) {
                  Get.offAllNamed(RouteHelper.loginScreen);
                }
              });
            },
            child: Container(
              // width: 170.w,
              height: 40.h,
              decoration: BoxDecoration(
                  color: AppColors.redColor,
                  borderRadius: BorderRadius.circular(10.r)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    "Logout",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15.sp),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
