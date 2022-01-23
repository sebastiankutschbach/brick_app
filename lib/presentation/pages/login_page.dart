import 'package:brick_app/infrastructure/service/preferences_service.dart';
import 'package:brick_app/infrastructure/service/rebrickable_api_exception.dart';
import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/presentation/pages/overview_page.dart';
import 'package:brick_app/presentation/widgets/brick_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  var _username = "";
  var _password = "";

  @override
  Widget build(BuildContext context) {
    final model = context.read<RebrickableModel>();
    final route = MaterialPageRoute(builder: (context) => const OverviewPage());
    final apiKey = context.watch<PreferencesService>().apiKey;
    final userToken = context.watch<PreferencesService>().userToken;
    if (userToken.isNotEmpty && apiKey.isNotEmpty) {
      model.loginWithToken(userToken, apiKey);
      Future.delayed(Duration.zero, () => Navigator.of(context).push(route));
    }
    return Scaffold(
      appBar: BrickAppBar(
        const Text('Rebrickable Login'),
        showLogoutButton: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    key: const Key('username'),
                    decoration: const InputDecoration(labelText: 'Username'),
                    onChanged: (value) => _username = value,
                    validator: (value) =>
                        value!.isEmpty ? 'Username cannot be empty' : null,
                  ),
                  TextFormField(
                    key: const Key('password'),
                    decoration: const InputDecoration(labelText: 'Password'),
                    onChanged: (value) => _password = value,
                    validator: (value) =>
                        value!.isEmpty ? 'Password cannot be empty' : null,
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    key: const Key('login'),
                    onPressed: () async {
                      if (apiKey.isEmpty) {
                        _showDialog('API Key not set',
                            'Please set your api key under settings');
                        return;
                      }
                      if (_formKey.currentState!.validate()) {
                        try {
                          final userToken =
                              await model.login(_username, _password, apiKey);
                          if (userToken.isNotEmpty) {
                            context.read<PreferencesService>().userToken =
                                userToken;
                            Navigator.push(context, route);
                          }
                        } on RebrickableApiException catch (e) {
                          _showDialog(
                              'Login failed', 'Error code: ${e.message}');
                        }
                      }
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDialog(String title, String message) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
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
