import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomShapeWidget extends StatelessWidget {
  const CustomShapeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipPath(
          clipper: CustomClipperShape(),
          child: Container(
            width: 300.w,
            height: 600.h,
            decoration: BoxDecoration(
              color: Colors.blue, // Change color as needed
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Center(
              child: Text(
                'Your Content',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomClipperShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 80.h);
    path.quadraticBezierTo(220.w, size.height - 420.h, size.width - 80.w, 0);
    path.lineTo(size.width - 80.w, 0);
    path.lineTo(0, 0); // Line to top-left corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
