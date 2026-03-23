import 'package:flutter/material.dart';

void main () {
  runApp(MaterialApp(debugShowCheckedModeBanner: false,
  home: TelaInicial(),
  ));
}

class TelaInicial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela Inicial"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("Ir para a segunda tela"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SegundaTela()),
            );
          },
        ),
      ),
    );
  }
}

class SegundaTela extends StatelessWidget {

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Segunda tela"),
      backgroundColor: Colors.green,
    ),
    textfield(
      decoration:InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'bem vindo a segunda tela' ,
        hintText: 'caro usuario',
      ),
    ));
    body: Center(
      child: ElevatedButton(
        child: Text("Voltar"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
  );
}
}