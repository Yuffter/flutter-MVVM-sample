import 'package:flutter/material.dart';

class BananaCounter extends StatelessWidget {
  final int number;
  const BananaCounter({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    final banana = Image.asset('images/test.png');

    final text = Text('$number');

    final row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [banana, text],
    );

    final con = Container(
      color: Colors.cyan,
      width: 200,
      height: 100,
      alignment: Alignment.center,
      child: row,
    );

    return con;
  }
}
