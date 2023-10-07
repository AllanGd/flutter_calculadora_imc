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
}
