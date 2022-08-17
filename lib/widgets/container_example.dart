import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ContainerExample extends StatelessWidget {
  const ContainerExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 200,
          width: 200,
          decoration: const BoxDecoration(
            color: Colors.red,
            boxShadow: [
              BoxShadow(
                offset: Offset(30, 30),
                blurRadius: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
