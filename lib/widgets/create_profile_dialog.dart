import 'package:book_tracker/models/book.dart';
import 'package:book_tracker/models/user.dart';
import 'package:book_tracker/util/util.dart';
import 'package:book_tracker/widgets/input_decoration.dart';
import 'package:book_tracker/widgets/update_user_profile.dart';
import 'package:flutter/material.dart';

AlertDialog createProfileDialog(
    BuildContext context, MUser curUser, List<Book> bookList) {
  final TextEditingController _displayNameController =
      TextEditingController(text: curUser.displayName);
  final TextEditingController _professionController =
      TextEditingController(text: curUser.profession);
  final TextEditingController _quoteController =
      TextEditingController(text: curUser.quotes);
  final TextEditingController _avatarUrlController =
      TextEditingController(text: curUser.avatarUrl);
  return AlertDialog(
    content: Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(curUser.avatarUrl != null
                    ? curUser.avatarUrl.toString()
                    : "https://th.bing.com/th/id/OIP.1Wn1tdSunnfamZC6T_HA6wAAAA?pid=ImgDet&rs=1"),
                backgroundColor: Colors.transparent,
              )
            ],
          ),
          Text(
            'Books Read (${bookList.length})',
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.redAccent),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                curUser.displayName.toUpperCase(),
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Colors.black,
                    ),
              ),
              TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return UpdateUserProfile(
                            curUser: curUser,
                            displayNameController: _displayNameController,
                            quoteController: _quoteController,
                            professionController: _professionController,
                            avatarUrlController: _avatarUrlController);
                      },
                    );
                  },
                  icon: Icon(
                    Icons.mode_edit,
                    color: Colors.black12,
                  ),
                  label: Text(''))
            ],
          ),
          Text(
            '${curUser.profession}',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            width: 100,
            height: 2,
            child: Container(
              color: Colors.red,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.blueGrey,
              ),
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(5),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Center(
                      child: Text(
                        'Favourite Quote:',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  SizedBox(
                    width: 100,
                    height: 2,
                    child: Container(
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: Text(
                      " \" ${curUser.quotes} \" ",
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: bookList.length,
                  itemBuilder: (context, index) {
                    Book book = bookList[index];
                    return Card(
                      elevation: 2.0,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text('${book.title}'),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  NetworkImage(book.photoUrl.toString()),
                            ),
                            subtitle: Text('${book.author}'),
                          ),
                          Text('${formatDate(book.finishReading)}')
                        ],
                      ),
                    );
                  }))
        ],
      ),
    ),
  );
}
