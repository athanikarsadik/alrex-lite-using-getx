import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemImageView extends StatelessWidget {
  final Uint8List bytes;
  const ItemImageView({super.key, required this.bytes});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.sp),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Image.memory(
          bytes,
          width: 110.w,
          height: 110.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}