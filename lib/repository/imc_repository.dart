import 'package:calculadora_imc/model/imc.dart';

class IMCRepository {
  final List<IMC> _imcs = [];

  void adicionar(IMC imc) {
    _imcs.add(imc);
  }

  void remover(String id) {
    _imcs.remove(_imcs.where((element) => element.id == id).first);
  }
}
