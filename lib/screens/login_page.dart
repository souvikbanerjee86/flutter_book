import 'package:book_tracker/widgets/create_account_form.dart';
import 'package:book_tracker/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isCreatedAccountClicked = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController =
      TextEditingController(text: "souvik@gmail.com");
  final TextEditingController _passwordController =
      TextEditingController(text: "123456");
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: HexColor('#b9c2d1'),
              ),
            ),
            Text(
              !isCreatedAccountClicked ? 'Sign In' : 'Sign Up',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                SizedBox(
                  width: 300,
                  height: 300,
                  child: !isCreatedAccountClicked
                      ? LoginForm(
                          formKey: _formKey,
                          emailController: _emailController,
                          passwordController: _passwordController,
                        )
                      : CreateAccountForm(
                          formKey: _formKey,
                          emailController: _emailController,
                          passwordController: _passwordController,
                        ),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                      primary: HexColor('#fd5b28'),
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      )),
                  onPressed: () {
                    setState(() {
                      if (!isCreatedAccountClicked) {
                        isCreatedAccountClicked = true;
                      } else {
                        isCreatedAccountClicked = false;
                      }
                    });
                  },
                  icon: Icon(Icons.portrait_outlined),
                  label: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      isCreatedAccountClicked
                          ? 'Already have an account ?'
                          : 'Create Account',
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                )
              ],
            ),
            Expanded(
              flex: 2,
              child: Container(
                color: HexColor('#b9c2d1'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
