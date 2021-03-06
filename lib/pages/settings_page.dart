import 'package:brick_app/service/preferences_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  late PreferencesService _preferencesService;

  void initState() {
    super.initState();
    _preferencesService = context.read<PreferencesService>();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: ObjectKey('settingsPage'),
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: TextFormField(
                initialValue: _preferencesService.apiKey,
                key: Key('apiKey'),
                decoration: InputDecoration(
                  labelText: 'API Key',
                ),
                onSaved: (value) => _preferencesService.apiKey = value!,
                onChanged: (value) => _preferencesService.apiKey = value,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
