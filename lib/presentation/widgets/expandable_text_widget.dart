import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/colors.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String text;
  const ExpandableTextWidget({Key? key, required this.text}) : super(key: key);

  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  late String firstHalf;
  late String secondHalf;

  bool hiddenText = true;
  double textHeight = 40.h;

  @override
  void initState() {
    super.initState();
    if (widget.text.length > textHeight) {
      firstHalf = widget.text.substring(0, textHeight.toInt());
      secondHalf =
          widget.text.substring(textHeight.toInt(), widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty
          ? smallText(color: AppColors.whiteColor, text: firstHalf)
          : Column(
              children: [
                smallText(
                    color: AppColors.whiteColor,
                    text: hiddenText
                        ? ("$firstHalf...")
                        : (firstHalf + secondHalf)),
                InkWell(
                  onTap: () {
                    setState(() {
                      hiddenText = !hiddenText;
                    });
                  },
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    smallText(
                        text: hiddenText ? "Show More" : "Show Less",
                        color: Colors.green.shade200),
                    Icon(
                        hiddenText
                            ? Icons.arrow_drop_down_rounded
                            : Icons.arrow_drop_up_rounded,
                        color: Colors.green.shade200)
                  ]),
                )
              ],
            ),
    );
  }

  Widget smallText({required String text, required Color color}) {
    return Text(
      text,
      softWrap: true,
      textAlign: TextAlign.left,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w500,
      ),
      // overflow: TextOverflow.ellipsis,
    );
  }
}
