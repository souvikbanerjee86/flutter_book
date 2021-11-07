import 'package:book_tracker/constants/constants.dart';
import 'package:book_tracker/models/book.dart';
import 'package:book_tracker/screens/main_screen_page.dart';
import 'package:book_tracker/util/util.dart';
import 'package:book_tracker/widgets/input_decoration.dart';
import 'package:book_tracker/widgets/two_sided_round_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BookDetailDialog extends StatefulWidget {
  final Book book;

  const BookDetailDialog({Key? key, required this.book}) : super(key: key);

  @override
  _BookDetailDialogState createState() => _BookDetailDialogState();
}

class _BookDetailDialogState extends State<BookDetailDialog> {
  late TextEditingController _thoughtController;
  bool _startReading = false;
  bool _fineshReadingClicked = false;
  var _rating;

  @override
  void initState() {
    _thoughtController = TextEditingController(text: widget.book.notes);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _titleController = TextEditingController(text: widget.book.title);
    var _authorController = TextEditingController(text: widget.book.author);
    var _coverController = TextEditingController(text: widget.book.photoUrl);

    return AlertDialog(
      title: Column(
        children: [
          Row(
            children: [
              Spacer(),
              Spacer(),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(
                  widget.book.photoUrl.toString(),
                ),
              ),
              Spacer(),
              Container(
                margin: const EdgeInsets.only(bottom: 100),
                child: TextButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close),
                  label: Text(''),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(widget.book.author)
        ],
      ),
      content: SingleChildScrollView(
        child: Container(
          child: Form(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _titleController,
                    decoration: buildInputDecoration(
                      hintText: 'Flutter Development',
                      label: 'Book Title',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _authorController,
                    decoration: buildInputDecoration(
                      hintText: 'Oscar',
                      label: 'Author',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _coverController,
                    decoration: buildInputDecoration(
                      hintText: 'Book Cover',
                      label: 'Book Cover',
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextButton.icon(
                  onPressed: widget.book.startedReading == null
                      ? () {
                          setState(() {
                            if (_startReading == false) {
                              _startReading = true;
                            } else {
                              _startReading = false;
                            }
                          });
                        }
                      : null,
                  icon: Icon(Icons.book_sharp),
                  label: widget.book.startedReading == null
                      ? !_startReading
                          ? Text('Start Reading')
                          : Text(
                              'Started reading....',
                              style: TextStyle(color: Colors.blueGrey.shade300),
                            )
                      : Text(
                          'Started on ${formatDate(widget.book.startedReading)}'),
                ),
                TextButton.icon(
                  onPressed: widget.book.finishReading == null
                      ? () {
                          setState(() {
                            if (_fineshReadingClicked == false) {
                              _fineshReadingClicked = true;
                            } else {
                              _fineshReadingClicked = false;
                            }
                          });
                        }
                      : null,
                  icon: Icon(Icons.done),
                  label: widget.book.finishReading == null
                      ? !_fineshReadingClicked
                          ? Text('Mark as Read')
                          : Text(
                              'Finished Reading!',
                              style: TextStyle(color: Colors.grey),
                            )
                      : Text(
                          'Finished on ${formatDate(widget.book.finishReading)}'),
                ),
                RatingBar.builder(
                  allowHalfRating: true,
                  initialRating:
                      widget.book.rating == null ? 0 : widget.book.rating,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return Icon(
                          Icons.sentiment_very_dissatisfied,
                          color: Colors.red,
                        );
                      case 1:
                        return Icon(
                          Icons.sentiment_dissatisfied,
                          color: Colors.redAccent,
                        );
                      case 2:
                        return Icon(
                          Icons.sentiment_neutral,
                          color: Colors.amber,
                        );
                      case 3:
                        return Icon(
                          Icons.sentiment_satisfied,
                          color: Colors.lightGreen,
                        );
                      case 4:
                        return Icon(
                          Icons.sentiment_very_satisfied,
                          color: Colors.green,
                        );
                      default:
                        return Container();
                    }
                  },
                  onRatingUpdate: (rating) {
                    print(rating);
                    setState(() {
                      _rating = rating;
                    });
                  },
                  updateOnDrag: true,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _thoughtController,
                    decoration: buildInputDecoration(
                      hintText: '',
                      label: 'Your Thought',
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TwoSidedRoundedButton(
                      text: 'Update',
                      press: () {
                        print(_rating);
                        FirebaseFirestore.instance
                            .collection("books")
                            .doc(widget.book.id)
                            .update(Book(
                              userId: FirebaseAuth.instance.currentUser?.uid,
                              title: _titleController.text,
                              author: _authorController.text,
                              description: widget.book.description,
                              categories: widget.book.categories,
                              publishedDate: widget.book.publishedDate,
                              pageCount: widget.book.pageCount,
                              photoUrl: _coverController.text,
                              startedReading: _startReading
                                  ? Timestamp.now()
                                  : widget.book.startedReading,
                              finishReading: _fineshReadingClicked
                                  ? Timestamp.now()
                                  : widget.book.finishReading,
                              notes: _thoughtController.text,
                              rating: _rating == null
                                  ? widget.book.rating
                                  : _rating,
                            ).toMap());

                        Navigator.of(context).pop();
                      },
                      color: kIconColor,
                    ),
                    TwoSidedRoundedButton(
                      text: 'Delete',
                      press: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Delete Book'),
                              content: Text(
                                  'Are you sure you want to delete book ?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection("books")
                                          .doc(widget.book.id)
                                          .delete();
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MainScreenPage()));
                                    },
                                    child: Text('Yes')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('No'))
                              ],
                            );
                          },
                        );
                      },
                      color: Colors.redAccent,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
