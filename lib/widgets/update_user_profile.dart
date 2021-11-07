import 'package:book_tracker/models/user.dart';
import 'package:book_tracker/widgets/input_decoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateUserProfile extends StatelessWidget {
  const UpdateUserProfile({
    Key? key,
    required TextEditingController displayNameController,
    required TextEditingController quoteController,
    required TextEditingController professionController,
    required TextEditingController avatarUrlController,
    required this.curUser,
  })  : _displayNameController = displayNameController,
        _quoteController = quoteController,
        _professionController = professionController,
        _avatarUrlController = avatarUrlController,
        super(key: key);
  final MUser curUser;
  final TextEditingController _displayNameController;
  final TextEditingController _quoteController;
  final TextEditingController _professionController;
  final TextEditingController _avatarUrlController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text('Edit ${curUser.displayName}'),
      ),
      content: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(curUser.avatarUrl != null
                      ? curUser.avatarUrl.toString()
                      : "https://th.bing.com/th/id/OIP.1Wn1tdSunnfamZC6T_HA6wAAAA?pid=ImgDet&rs=1"),
                  backgroundColor: Colors.transparent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _displayNameController,
                  decoration:
                      buildInputDecoration(label: "Your Name", hintText: ""),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _quoteController,
                  decoration:
                      buildInputDecoration(label: "Quotes", hintText: ""),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _professionController,
                  decoration:
                      buildInputDecoration(label: "Profession", hintText: ""),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _avatarUrlController,
                  decoration:
                      buildInputDecoration(label: "Avatar Url", hintText: ""),
                ),
              )
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(curUser.id)
                  .update(MUser(
                          uid: curUser.uid,
                          displayName: _displayNameController.text,
                          profession: _professionController.text,
                          avatarUrl: _avatarUrlController.text,
                          quotes: _quoteController.text)
                      .toMap());
              Navigator.of(context).pop();
            },
            child: Text('Update'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        )
      ],
    );
  }
}
