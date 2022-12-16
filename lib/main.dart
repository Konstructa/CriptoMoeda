import 'package:flutter/material.dart';
import 'package:hello_world/configs/app_settings.dart';
import 'package:hello_world/repositories/conta_repository.dart';
import 'package:hello_world/repositories/favoritas_repository.dart';
import 'package:provider/provider.dart';
import 'configs/hive_config.dart';
import 'meu_aplicativo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.start();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ContaRepository(),
      ),
      ChangeNotifierProvider(
        create: (context) => FavoritasRepository(),
      ),
      ChangeNotifierProvider(
        create: (context) => AppSettings(),
      ),
    ],
    child: const MeuAplicativo(),
  ));
}
