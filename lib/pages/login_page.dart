import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/pages/overview_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  var _username = "";
  var _password = "";

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rebrickable Login'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SizedBox(
            width: 320,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    key: Key('username'),
                    decoration: InputDecoration(labelText: 'Username'),
                    onChanged: (value) => _username = value,
                    validator: (value) =>
                        value.isEmpty ? 'Username cannot be empty' : null,
                  ),
                  TextFormField(
                    key: Key('password'),
                    decoration: InputDecoration(labelText: 'Password'),
                    onChanged: (value) => _password = value,
                    validator: (value) =>
                        value.isEmpty ? 'Password cannot be empty' : null,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    key: Key('login'),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        final success = await context
                            .read<RebrickableModel>()
                            .login(_username, _password);
                        if (success) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OverviewPage()));
                        }
                      }
                    },
                    child: Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
