import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import 'package:book_tracker/models/book.dart';
import 'package:book_tracker/widgets/input_decoration.dart';

class BookSearchPage extends StatefulWidget {
  @override
  _BookSearchPageState createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  List<Book> listOfBooks = [];

  late TextEditingController _searchTextController;

  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final _bookCollection = FirebaseFirestore.instance.collection("books");
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Search'),
        elevation: 0.0,
        backgroundColor: Colors.redAccent,
      ),
      body: Material(
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: [
                Form(
                  child: TextFormField(
                    onFieldSubmitted: (value) {
                      _search(value);
                    },
                    controller: _searchTextController,
                    decoration: buildInputDecoration(
                        label: "Search", hintText: "Flutter Development..."),
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                (listOfBooks != null && listOfBooks.isNotEmpty)
                    ? Container(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: listOfBooks.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              width: 190,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Card(
                                elevation: 5,
                                color: HexColor("#f6f4ff"),
                                child: Wrap(
                                  children: [
                                    Image.network(
                                      (listOfBooks[index].photoUrl == null ||
                                              listOfBooks[index]
                                                  .photoUrl
                                                  .toString()
                                                  .isEmpty)
                                          ? "https://images.unsplash.com/photo-1497633762265-9d179a990aa6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2073&q=80"
                                          : listOfBooks[index]
                                              .photoUrl
                                              .toString(),
                                      height: 160,
                                      width: 160,
                                    ),
                                    ListTile(
                                      title: Text(
                                        '${listOfBooks[index].title}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: HexColor('#5d48b6'),
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${listOfBooks[index].author}',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              child: SearchBookDetailDialog(
                                                  context,
                                                  index,
                                                  _bookCollection),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ))
                    : Center(
                        child: Text('No Books found!'),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  AlertDialog SearchBookDetailDialog(BuildContext context, int index,
      CollectionReference<Map<String, dynamic>> _bookCollection) {
    return AlertDialog(
      content: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Column(
          children: [
            Container(
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(
                  listOfBooks[index].photoUrl.toString(),
                ),
                radius: 50,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${listOfBooks[index].title}',
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(
                8.0,
              ),
              child: Text(
                'Category: ${listOfBooks[index].categories}',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(
                4.0,
              ),
              child: Text(
                'Author: ${listOfBooks[index].author}',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(
                2.0,
              ),
              child: Text(
                'Page count: ${listOfBooks[index].pageCount}',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(
                2.0,
              ),
              child: Text(
                'Published: ${listOfBooks[index].publishedDate}',
              ),
            ),
            Expanded(
                child: Container(
              margin: const EdgeInsets.all(18.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blueGrey.shade100,
                  width: 1,
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    listOfBooks[index].description,
                    style: TextStyle(letterSpacing: 1.3, wordSpacing: 0.9),
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              var book = listOfBooks[index];
              _bookCollection.add(Book(
                      userId: FirebaseAuth.instance.currentUser?.uid,
                      title: book.title,
                      author: book.author,
                      description: book.description,
                      categories: book.categories,
                      publishedDate: book.publishedDate,
                      pageCount: book.pageCount,
                      photoUrl: book.photoUrl)
                  .toMap());
              Navigator.of(context).pop();
            },
            child: Text('Save')),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel')),
      ],
    );
  }

  void _search(String text) async {
    await fetchBooks(text).then((value) {
      setState(() {
        listOfBooks = value;
      });
    }, onError: (val) {
      throw Exception('Some error occured ${val.toString()}');
    });
  }

  Future<List<Book>> fetchBooks(String text) async {
    List<Book> books = [];
    http.Response response = await http
        .get(Uri.parse("https://www.googleapis.com/books/v1/volumes?q=$text"));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      final Iterable items = body['items'];

      for (var item in items) {
        String title = item['volumeInfo']['title'] == null
            ? 'N/A'
            : item['volumeInfo']['title'];
        String author = item['volumeInfo']['authors'] == null
            ? 'N/A'
            : item['volumeInfo']['authors'][0];
        String description = item['volumeInfo']['description'] == null
            ? 'N/A'
            : item['volumeInfo']['description'];
        String photoUrl = item['volumeInfo']['imageLinks'] == null
            ? 'N/A'
            : item['volumeInfo']['imageLinks']['thumbnail'];
        String categories = item['volumeInfo']['categories'] == null
            ? 'N/A'
            : item['volumeInfo']['categories'][0];
        int pageCount = item['volumeInfo']['pageCount'] == null
            ? 0
            : item['volumeInfo']['pageCount'];
        String publishedDate = item['volumeInfo']['publishedDate'] == null
            ? 'N/A'
            : item['volumeInfo']['publishedDate'];

        Book searchedBook = Book(
          author: author,
          description: description,
          title: title,
          photoUrl: photoUrl,
          categories: categories,
          pageCount: pageCount,
          publishedDate: publishedDate,
        );

        books.add(searchedBook);
      }
    } else {
      throw ('error ${response.reasonPhrase}');
    }

    return books;
  }
}
