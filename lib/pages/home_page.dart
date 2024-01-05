import 'package:calculadora_imc/model/imc.dart';
import 'package:calculadora_imc/pages/empyt_page.dart';
import 'package:calculadora_imc/repository/imc_repository.dart';
import 'package:calculadora_imc/shared/widgets/imc_icon_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

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
  final _formKey = GlobalKey<FormState>();
  var box = Hive.box<IMC>('imcBox');

  @override
  void initState() {
    super.initState();
    obterIMCs();
  }

  void obterIMCs() {
    _imcs = box.values.toList();
    // _imcs = imcRepository.listar();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calculadora de IMC")),
      body: _imcs.isEmpty
          ? const EmpytPage()
          : ListView.builder(
              itemCount: _imcs.length,
              itemBuilder: (context, index) {
                var imc = _imcs[index];
                return Dismissible(
                    key: Key(imc.id),
                    background: Container(color: Colors.red),
                    onDismissed: (direction) {
                      setState(() {
                        imcRepository.remover(imc.id);
                      });
                    },
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Detalhes"),
                                content: SingleChildScrollView(
                                  child: Column(children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Altura: "),
                                        Text(
                                          "${imc.altura} m",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Peso: "),
                                        Text("${imc.peso.toString()} kg",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600))
                                      ],
                                    ),
                                    const Divider(),
                                    Center(
                                      child: Column(
                                        children: [
                                          Text(imc.valor().toString()),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(imc.descricao()),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    FilledButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Fechar"))
                                  ]),
                                ),
                              );
                            },
                          );
                        },
                        leading: IMCIconStatus(imcValor: imc.valor()),
                        title: Row(children: [
                          const Text("IMC: "),
                          Text(
                            imc.valor().toString(),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          )
                        ]),
                        subtitle: Text(imc.descricao()),
                      ),
                    ));
              },
            ),
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
                  child: Form(
                    key: _formKey,
                    child: Column(children: [
                      const Text(
                        "Calcular IMC",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Por favor insira a sua altura";
                          }
                          return null;
                        },
                        controller: alturaController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                        ],
                        decoration: const InputDecoration(labelText: "Altura"),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Por favor insira o seu peso";
                          }
                          return null;
                        },
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
                            if (_formKey.currentState!.validate()) {
                              var imc = IMC(double.parse(alturaController.text),
                                  double.parse(pesoController.text));
                              setState(() {
                                box.add(imc);
                                // imcRepository.adicionar(imc);
                              });
                              Navigator.pop(context);
                              alturaController.clear();
                              pesoController.clear();
                            }
                          },
                          child: const Text("Calcular")),
                      const SizedBox(
                        height: 20,
                      )
                    ]),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
