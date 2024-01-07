import 'package:calculadora_imc/model/imc.dart';
import 'package:hive/hive.dart';

class IMCRepository {
  final String _boxName = "imcBox";

  Future<Box<IMC>> get _box async => await Hive.openBox<IMC>(_boxName);

  Future<void> adicionar(IMC imc) async {
    var box = await _box;
    box.add(imc);
  }

  Future<void> remover(int index) async {
    var box = await _box;
    await box.deleteAt(index);
  }

  Future<List<IMC>> listar() async {
    var box = await _box;
    return box.values.toList();
  }

  Future<int> quantidadeIMCs() async {
    var box = await _box;
    return box.values.length;
  }
}
