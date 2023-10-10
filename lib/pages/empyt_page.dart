import 'package:flutter/material.dart';

class EmpytPage extends StatelessWidget {
  const EmpytPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: SingleChildScrollView(
      child: Column(
        children: [
          Text(
            "Aqui está tão vazio",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 13,
          ),
          Text(
            'Clique no botão "+".',
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    ));
  }
}
