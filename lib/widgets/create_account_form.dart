import 'package:book_tracker/screens/main_screen_page.dart';
import 'package:book_tracker/services/create_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'input_decoration.dart';

class CreateAccountForm extends StatelessWidget {
  const CreateAccountForm({
    Key? key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  })  : _formKey = formKey,
        _emailController = emailController,
        _passwordController = passwordController,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
                'Please enter email and password that is at least 6 character.'),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: _emailController,
              validator: (value) {
                return value!.isEmpty ? 'Please enter email' : null;
              },
              decoration: buildInputDecoration(
                  label: "Enter Email", hintText: "john@email.com"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              validator: (value) {
                return value!.isEmpty ? 'Please enter password' : null;
              },
              controller: _passwordController,
              obscureText: true,
              decoration:
                  buildInputDecoration(label: "Enter Password", hintText: ""),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.amber,
              padding: EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 10,
              ),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                String email = _emailController.text;
                FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                  email: email,
                  password: _passwordController.text,
                )
                    .then((value) {
                  if (value.user != null) {
                    String displayName = email.toString().split("@")[0];
                    createUser(displayName, context).then((value) {
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      )
                          .then((value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainScreenPage(),
                          ),
                        ).catchError((onError) {
                          return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Oops!'),
                                content: Text('${onError.message}'),
                              );
                            },
                          );
                        });
                      });
                    });
                  }
                });
              }
            },
            child: Text('Create Account'),
          )
        ],
      ),
    );
  }
}
