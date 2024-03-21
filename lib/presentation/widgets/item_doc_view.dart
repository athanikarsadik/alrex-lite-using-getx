import 'dart:io';
import 'package:arlex_getx/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemDocView extends StatelessWidget {
  final File file;
  const ItemDocView({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.sp),
      width: 100.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Card(
          elevation: 0,
          color: const Color(0xFF4148EF),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.folder,size: 30.sp,color: AppColors.whiteColor,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(file.path.split('/').last, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white),),
              )
            ],
          ),
        )
      ),
    );
  }
}