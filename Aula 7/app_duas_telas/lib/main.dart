import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DuasTelas(),
  ));
}

class DuasTelas extends StatelessWidget {
  const DuasTelas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minha Primeira Tela"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white, 
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("Ir para próxima página"),
          onPressed: () {
            String meuNome = "Gabriel";
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProximaPagina(nome: meuNome),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProximaPagina extends StatelessWidget {
  final String nome;


  const ProximaPagina({super.key, required this.nome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Página 2"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text(
          "Bem-vindo à segunda tela, $nome!!",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
