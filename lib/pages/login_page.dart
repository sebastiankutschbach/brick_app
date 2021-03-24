import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/pages/overview_page.dart';
import 'package:brick_app/pages/settings_page.dart';
import 'package:brick_app/service/preferences_service.dart';
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
    final apiKey = context.watch<PreferencesService>().apiKey;
    return Scaffold(
      appBar: AppBar(
        title: Text('Rebrickable Login'),
        actions: [
          _createSettingsButton(),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
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
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    key: Key('login'),
                    onPressed: () async {
                      if (apiKey.isEmpty || apiKey == null) {
                        _showDialog('Please set your api key under settings');
                      }
                      if (_formKey.currentState.validate()) {
                        final success = await context
                            .read<RebrickableModel>()
                            .login(_username, _password, apiKey);
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

  IconButton _createSettingsButton() {
    return IconButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SettingsPage()));
        },
        icon: Icon(Icons.settings));
  }

  Future<void> _showDialog(message) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('API Key not set'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
        );
      },
    );
  }
}
