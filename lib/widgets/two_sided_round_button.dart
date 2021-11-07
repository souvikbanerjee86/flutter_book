import 'package:book_tracker/constants/constants.dart';
import 'package:flutter/material.dart';

class TwoSidedRoundedButton extends StatelessWidget {
  final String? text;
  final double radius;
  final VoidCallback press;
  final Color color;

  const TwoSidedRoundedButton(
      {Key? key,
      required this.text,
      this.radius = 30,
      required this.press,
      this.color = kBlackColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            bottomRight: Radius.circular(radius),
          ),
          color: this.color,
        ),
        child: Text(
          text.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
