import 'package:calculadora_imc/model/imc.dart';
import 'package:calculadora_imc/repository/imc_repository.dart';
import 'package:calculadora_imc/shared/widgets/imc_icon_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';

class IMCListPage extends StatelessWidget {
  IMCListPage({super.key});

  final _imcRepository = IMCRepository();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calculadora de IMC")),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<IMC>('imcBox').listenable(),
        builder: (context, box, _) {
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              var imc = box.getAt(index)!;
              return Dismissible(
                  key: Key(imc.id),
                  background: Container(
                    color: Colors.red,
                    child: const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.delete)),
                  ),
                  onDismissed: (direction) {
                    box.deleteAt(index);
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
          );
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
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              var imc = IMC(double.parse(alturaController.text),
                                  double.parse(pesoController.text));

                              await _imcRepository.adicionar(imc);
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
