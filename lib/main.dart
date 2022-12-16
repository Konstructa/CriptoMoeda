import 'package:flutter/material.dart';
import 'package:hello_world/configs/app_settings.dart';
import 'package:hello_world/repositories/favoritas_repository.dart';
import 'package:provider/provider.dart';
import 'meu_aplicativo.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FavoritasRepository(),
        ),
        ChangeNotifierProvider(
          create: (context) => AppSettings(),
        ),
      ],
      child: const MeuAplicativo(),
    )
    
  );
}

