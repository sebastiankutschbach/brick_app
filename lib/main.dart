import 'package:brick_app/infrastructure/service/rebrickable_service.dart';
import 'package:brick_app/model/rebrickable_model.dart';
import 'package:brick_app/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'infrastructure/service/preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferencesService = PreferencesService();
  await preferencesService.initPreferences();
  final rebrickableModel =
      RebrickableModel(rebrickableService: RebrickableService());
  runApp(MyApp(
      preferencesService: preferencesService,
      rebrickableModel: rebrickableModel));
}

class MyApp extends StatelessWidget {
  final PreferencesService preferencesService;
  final RebrickableModel rebrickableModel;

  const MyApp(
      {required this.preferencesService,
      required this.rebrickableModel,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RebrickableModel>(
          create: (_) => rebrickableModel,
        ),
        ChangeNotifierProvider<PreferencesService>(
          create: (_) => preferencesService,
          lazy: false,
        )
      ],
      child: MaterialApp(
        title: 'Brick App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
