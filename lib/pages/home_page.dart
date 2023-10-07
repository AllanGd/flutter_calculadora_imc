import 'package:calculadora_imc/model/imc.dart';
import 'package:calculadora_imc/repository/imc_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController pesoController = TextEditingController();

  TextEditingController alturaController = TextEditingController();
  var imcRepository = IMCRepository();
  var _imcs = <IMC>[];

  @override
  void initState() {
    super.initState();
    obterIMCs();
  }

  void obterIMCs() {
    _imcs = imcRepository.listar();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calculadora de IMC")),
      body: Container(
          child: ListView.builder(
        itemCount: _imcs.length,
        itemBuilder: (context, index) {
          var imc = _imcs[index];
          return Dismissible(
              key: Key(imc.id),
              child: Card(
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Row(
                      children: [
                        const Text("Altura: "),
                        Text(imc.altura.toString())
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Peso: "),
                        Text(imc.peso.toString())
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const Text("Valor do IMC: "),
                        Text(imc.valor().toString())
                      ],
                    )
                  ],
                )),
              ));
        },
      )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            context: context,
            builder: (context) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      15, 30, 15, MediaQuery.of(context).viewInsets.bottom),
                  child: Column(children: [
                    const Text(
                      "Calcular IMC",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    TextField(
                      controller: alturaController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                      ],
                      decoration: const InputDecoration(labelText: "Altura"),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: pesoController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                      ],
                      decoration: const InputDecoration(labelText: "Peso"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FilledButton(
                        onPressed: () {
                          var imc = IMC(double.parse(alturaController.text),
                              double.parse(pesoController.text));
                          setState(() {
                            imcRepository.adicionar(imc);
                          });
                          Navigator.pop(context);
                          alturaController.clear();
                          pesoController.clear();
                        },
                        child: const Text("Calcular")),
                    const SizedBox(
                      height: 20,
                    )
                  ]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
