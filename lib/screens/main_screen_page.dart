import 'dart:convert';
import 'package:book_tracker/constants/constants.dart';
import 'package:book_tracker/models/book.dart';
import 'package:book_tracker/models/user.dart';
import 'package:book_tracker/screens/login_page.dart';
import 'package:book_tracker/widgets/book_detail_dialog.dart';
import 'package:book_tracker/widgets/book_search_page.dart';
import 'package:book_tracker/widgets/create_profile_dialog.dart';
import 'package:book_tracker/widgets/input_decoration.dart';
import 'package:book_tracker/widgets/reading_list_card.dart';
import 'package:book_tracker/widgets/two_sided_round_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class MainScreenPage extends StatefulWidget {
  const MainScreenPage({Key? key}) : super(key: key);

  @override
  _MainScreenPageState createState() => _MainScreenPageState();
}

class _MainScreenPageState extends State<MainScreenPage> {
  @override
  Widget build(BuildContext context) {
    final _titleController = TextEditingController();
    final _authorController = TextEditingController();
    final _coverController = TextEditingController();
    final _thoughtController = TextEditingController();

    var authUser = Provider.of<User?>(context);

    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    CollectionReference booksReference =
        FirebaseFirestore.instance.collection("books");
    List<Book> userBook = [];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 77,
        backgroundColor: Colors.white24,
        centerTitle: false,
        elevation: 0.0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/Icon-76.png',
              scale: 2,
            ),
            Text(
              "A.Reader",
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream: userCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final userListStream = snapshot.data!.docs.map((user) {
                return MUser.fromDocument(user);
              }).where((user) {
                return (user.uid == authUser?.uid);
              }).toList();

              final curUser = userListStream[0];

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: InkWell(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: curUser.avatarUrl!.isEmpty
                            ? Container()
                            : CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    NetworkImage(curUser.avatarUrl.toString()),
                                backgroundColor: Colors.white,
                                child: Text(''),
                              ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return createProfileDialog(
                                context, curUser, userBook);
                          },
                        );
                      },
                    ),
                  ),
                  Text(
                    "${curUser.displayName.toUpperCase()}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              );
            },
          ),
          TextButton.icon(
              onPressed: () {
                FirebaseAuth.instance
                    .signOut()
                    .then((value) => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        )));
              },
              icon: Icon(Icons.logout),
              label: Text(''))
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12.0, left: 12.0),
            width: double.infinity,
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.headline5,
                children: [
                  TextSpan(text: 'Your reading\n activity '),
                  TextSpan(
                    text: 'right now...',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: booksReference.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              var userBookReadListStream = snapshot.data!.docs.map((book) {
                return Book.fromDocument(book);
              }).where((element) {
                return (element.userId == authUser?.uid &&
                    element.finishReading == null &&
                    element.startedReading != null);
              }).toList();

              userBook = snapshot.data!.docs.map((book) {
                return Book.fromDocument(book);
              }).where((element) {
                return (element.userId == authUser?.uid &&
                    element.finishReading != null &&
                    element.startedReading != null);
              }).toList();

              return Expanded(
                flex: 2,
                child: (userBookReadListStream.length > 0)
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: userBookReadListStream.length,
                        itemBuilder: (context, index) {
                          Book book = userBookReadListStream[index];
                          return InkWell(
                            child: ReadingLIstCard(
                              rating: book.rating != null ? book.rating : 4,
                              title: book.title.toString(),
                              author: book.author,
                              pressRead: () {},
                              buttonText: "Reading",
                              image: book.photoUrl.toString(),
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return BookDetailDialog(
                                      book: book,
                                    );
                                  });
                            },
                          );
                        },
                      )
                    : Center(
                        child: Text('No Book Found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
              );
            },
          ),
          SizedBox(height: 25),
          Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.headline5,
                      children: [
                        TextSpan(
                          text: 'Your reading List ',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: booksReference.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              var userBookReadListStream = snapshot.data!.docs.map((book) {
                return Book.fromDocument(book);
              }).where((element) {
                return (element.userId == authUser?.uid &&
                    element.finishReading == null &&
                    element.startedReading == null);
              }).toList();
              return Expanded(
                flex: 2,
                child: (userBookReadListStream.length > 0)
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: userBookReadListStream.length,
                        itemBuilder: (context, index) {
                          Book book = userBookReadListStream[index];
                          return InkWell(
                            child: ReadingLIstCard(
                              rating: book.rating != null ? book.rating : 4,
                              title: book.title.toString(),
                              author: book.author,
                              pressRead: () {},
                              image: book.photoUrl.toString(),
                              buttonText: "Reading",
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return BookDetailDialog(
                                      book: book,
                                    );
                                  });
                            },
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'You haven\'t started reading Yet ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return BookSearchPage();
            },
          ));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
