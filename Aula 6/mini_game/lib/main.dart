import 'package:flutter/material.dart';
import 'dart:math'; // Import no topo

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: JogoApp(),
  ));
}

class JogoApp extends StatefulWidget {
  const JogoApp({super.key});

  @override
  State<JogoApp> createState() => -();
}

class _JogoAppState extends State<JogoApp> {
  IconData iconeComputador = Icons.help_outline;
  String resultado = "Escolha uma opção";
  int pontosJogador = 0;
  int pontosComputador = 0;
  List<String> opcoes = ["pedra", "papel", "tesoura"];

  void jogar(String escolhaUsuario) {
    var numero = Random().nextInt(3);
    var escolhaComputador = opcoes[numero];

    setState(() {
      // Lógica de ícones
      if (escolhaComputador == "pedra") iconeComputador = Icons.landscape;
      if (escolhaComputador == "papel") iconeComputador = Icons.pan_tool;
      if (escolhaComputador == "tesoura") iconeComputador = Icons.content_cut;

      // Lógica de vitória/derrota
      if (escolhaUsuario == escolhaComputador) {
        resultado = "Empate";
      } else if ((escolhaUsuario == "pedra" && escolhaComputador == "tesoura") ||
          (escolhaUsuario == "papel" && escolhaComputador == "pedra") ||
          (escolhaUsuario == "tesoura" && escolhaComputador == "papel")) {
        pontosJogador++;
        resultado = "Você venceu!";
      } else {
        pontosComputador++;
        resultado = "Computador venceu!";
      }

      if (pontosJogador == 5) {
        resultado = "Você ganhou o campeonato!";
        pontosJogador = 0;
        pontosComputador = 0;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jokenpô"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconeComputador,
              size: 100,
            ),
            const SizedBox(height: 20),
            Text(
              resultado,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              "Jogador: $pontosJogador - Computador: $pontosComputador",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => jogar("pedra"),
                  child: const Text("Pedra"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => jogar("papel"),
                  child: const Text("Papel"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => jogar("tesoura"),
                  child: const Text("Tesoura"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}