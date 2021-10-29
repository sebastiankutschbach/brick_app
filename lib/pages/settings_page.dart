import 'package:brick_app/service/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  late PreferencesService _preferencesService;

  @override
  void initState() {
    super.initState();
    _preferencesService = context.read<PreferencesService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('settingsPage'),
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: TextFormField(
                initialValue: _preferencesService.apiKey,
                key: const Key('apiKey'),
                decoration: const InputDecoration(
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
