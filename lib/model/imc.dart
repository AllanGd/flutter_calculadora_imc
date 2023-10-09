// ignore_for_file: unnecessary_getters_setters

import 'package:flutter/material.dart';

class IMC {
  final String _id = UniqueKey().toString();
  double _peso;
  double _altura;

  IMC(this._altura, this._peso);

  String get id => _id;
  double get peso => _peso;
  double get altura => _altura;

  set peso(double peso) {
    _peso = peso;
  }

  set altura(double altura) {
    _altura = altura;
  }

  double valor() {
    return double.parse((_peso / (_altura * _altura)).toStringAsFixed(2));
  }

  String descricao() {
    String resposta = "";

    switch (valor()) {
      case < 16:
        resposta = "Magreza grave";
        break;
      case >= 16 && < 17:
        resposta = "Magreza moderada";
        break;
      case >= 17 && < 18.5:
        resposta = "Magreza leve";
        break;
      case >= 18.5 && < 25:
        resposta = "Saudável";
        break;
      case >= 25 && < 30:
        resposta = "Sobrepeso";
        break;
      case >= 30 && < 35:
        resposta = "Obesidade Grau I";
        break;
      case >= 35 && < 40:
        resposta = "Obesidade Grau II (severa)";
        break;
      default:
        resposta = "Obesidade Grau III (mórbida)";
    }

    return resposta;
  }
}
