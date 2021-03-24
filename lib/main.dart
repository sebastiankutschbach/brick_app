import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/pages/login_page.dart';
import 'package:brick_app/service/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RebrickableModel>(
          create: (_) => RebrickableModel(),
        ),
        Provider<PreferencesService>(
          create: (_) {
            final service = PreferencesService();
            service.initPreferences();
            return service;
          },
          lazy: false,
        )
      ],
      child: MaterialApp(
        title: 'Brick App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage(),
      ),
    );
  }
}
