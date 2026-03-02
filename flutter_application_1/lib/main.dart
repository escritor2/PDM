import "package:flutter/material.dart";

void main() {
  runApp(const FlutterApplication1());
}

class FlutterApplication1 extends StatelessWidget {
  const FlutterApplication1({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter APLICATION 1",
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter APLICATION 1')),
        body: Center(child: Text("Hello World")),
      ),
    );
  }
}


