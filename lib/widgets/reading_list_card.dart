import 'package:book_tracker/constants/constants.dart';
import 'package:book_tracker/widgets/book_rating.dart';
import 'package:book_tracker/widgets/two_sided_round_button.dart';
import 'package:flutter/material.dart';

import 'package:book_tracker/models/book.dart';

class ReadingLIstCard extends StatelessWidget {
  final String image;
  final String title;
  final String author;
  final double? rating;
  final String? buttonText;
  final Book? book;
  final bool? isBookRead;
  final Function? pressDetails;
  final VoidCallback pressRead;
  const ReadingLIstCard({
    Key? key,
    required this.image,
    required this.title,
    required this.author,
    this.rating = 0,
    this.buttonText,
    this.book,
    this.isBookRead,
    this.pressDetails,
    required this.pressRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 24, bottom: 0),
      width: 204,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              height: 244,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(29),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 33,
                      color: kShadowColor,
                    ),
                  ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              image,
              height: 150,
            ),
          ),
          Positioned(
              top: 34,
              right: 10,
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.favorite_border),
                  ),
                  BookRating(score: (rating))
                ],
              )),
          Positioned(
              top: 160,
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: RichText(
                        maxLines: 2,
                        text: TextSpan(
                            style: TextStyle(color: kBlackColor),
                            children: [
                              TextSpan(
                                text: '${title}\n',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: author,
                                style: TextStyle(
                                  color: kLightBlackColor,
                                ),
                              ),
                            ]),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 100,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text('Details'),
                        ),
                        Container(
                          width: 105,
                          child: TwoSidedRoundedButton(
                            text: buttonText,
                            press: pressRead,
                            color: kLightPurple,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
