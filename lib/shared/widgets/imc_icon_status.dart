import 'package:flutter/material.dart';

class IMCIconStatus extends StatelessWidget {
  final double imcValor;

  const IMCIconStatus({super.key, required this.imcValor});

  @override
  Widget build(BuildContext context) {
    switch (imcValor) {
      case (< 16) || (>= 35):
        return const Icon(
          Icons.mood_bad,
          color: Colors.red,
        );
      case (>= 16 && < 17) || (>= 30 && < 35):
        return const Icon(
          Icons.sentiment_dissatisfied,
          color: Colors.amber,
        );

      case (>= 17 && < 18.5) || (>= 25 && < 30):
        return Icon(
          Icons.sentiment_neutral,
          color: Colors.yellow[600],
        );

      case >= 18.5 && < 25:
        return const Icon(
          Icons.sentiment_satisfied_alt,
          color: Colors.green,
        );

      default:
        return const Icon(Icons.mood_bad);
    }
  }
}
