import 'package:flutter/material.dart';

class Contato {
  final String nome;
  final String telefone;

  Contato({required this.nome, required this.telefone});
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Contatos',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ListaContatos(),
    );
  }
}

// --- TELA 1: Lista de Contatos ---
class ListaContatos extends StatelessWidget {
  const ListaContatos({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Contato> contatos = [
      Contato(nome: 'João Silva', telefone: '(11) 98765-4321'),
      Contato(nome: 'Maria Souza', telefone: '(21) 99999-8888'),
      Contato(nome: 'Carlos Oliveira', telefone: '(31) 91234-5678'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Contatos 📋'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: contatos.length,
        itemBuilder: (context, index) {
          final contato = contatos[index];

          return ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(contato.nome),
            subtitle: const Text('Clique para ver detalhes'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // --- PASSO 3: Navegação entre telas (Navigator.push) ---
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalheContato(contato: contato),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// --- TELA 2: Detalhes do Contato ---
class DetalheContato extends StatelessWidget {
  final Contato contato;

  const DetalheContato({super.key, required this.contato});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes 👤'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informações do Contato:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Nome: ${contato.nome}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            // ... dentro da Column de DetalheContato
const SizedBox(height: 40),
SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LigandoContato(contato: contato),
        ),
      );
    },
    icon: const Icon(Icons.phone),
    label: const Text('Ligar para Contato'),
    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
  ),
),
const SizedBox(height: 10),

SizedBox(
  width: double.infinity,
  child: OutlinedButton.icon(
    onPressed: () => Navigator.pop(context),
    icon: const Icon(Icons.arrow_back),
    label: const Text('Voltar para a Lista'),
  ),
),

class LigandoContato extends StatelessWidget {
  final Contato contato;

  const LigandoContato({super.key, required this.contato});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Removido o const daqui para aceitar as variações de cores [900] e [100]
      backgroundColor: Colors.blueGrey[900], 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:, fontSize: 18),
            ),
            Text(
              contato.nome,
              style: const TextStyle(
                color: Colors.white, 
                fontSize: 28, 
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              contato.telefone,
              style: const TextStyle(color: Colors.white70, fontSize: 20),
            ),
            const SizedBox(height: 60),
            FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () => Navigator.pop(context),
              child: const Icon(Icons.call_end, size: 30, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text('Encerrar', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
} // Aquele "]" que estava aqui foi removido
