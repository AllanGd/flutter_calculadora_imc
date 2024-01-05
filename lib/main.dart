import 'package:calculadora_imc/model/imc.dart';
import 'package:calculadora_imc/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(IMCAdapter());
  await Hive.openBox<IMC>('imcBox');
  runApp(MaterialApp(
    theme: ThemeData(primarySwatch: Colors.cyan),
    home: const HomePage(),
  ));
}
