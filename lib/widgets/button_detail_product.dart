import 'package:flutter/material.dart';

class ButtonDetailProduct extends StatefulWidget {
  int? qty;
  ButtonDetailProduct({Key? key, this.qty = 1}) : super(key: key);

  @override
  State<ButtonDetailProduct> createState() => _ButtonDetailProductState();
}

class _ButtonDetailProductState extends State<ButtonDetailProduct> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(Icons.remove))
        ],
      ),
    );
  }
}
