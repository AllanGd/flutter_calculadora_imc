import 'package:calculadora_imc/pages/imc_list_page.dart';
import 'package:calculadora_imc/repository/imc_repository.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _imcRepository = IMCRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _imcRepository.listar(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return IMCListPage();
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
