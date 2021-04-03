import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/pages/login_page.dart';
import 'package:brick_app/service/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferencesService = PreferencesService();
  await preferencesService.initPreferences();
  final rebrickableModel = RebrickableModel();
  runApp(MyApp(
      preferencesService: preferencesService,
      rebrickableModel: rebrickableModel));
}

class MyApp extends StatelessWidget {
  final PreferencesService preferencesService;
  final RebrickableModel rebrickableModel;

  MyApp({this.preferencesService, this.rebrickableModel});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RebrickableModel>(
          create: (_) => rebrickableModel,
        ),
        Provider<PreferencesService>(
          create: (_) => preferencesService,
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
