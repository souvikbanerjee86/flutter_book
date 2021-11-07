import 'package:book_tracker/constants/constants.dart';
import 'package:flutter/material.dart';

class BookRating extends StatelessWidget {
  final double? score;
  const BookRating({Key? key, this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0xFD3D3D3).withOpacity(0.5),
              offset: Offset(3, 7),
              blurRadius: 20,
            )
          ]),
      child: Column(
        children: [
          Icon(
            Icons.star,
            color: kIconColor,
            size: 15,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '$score',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
