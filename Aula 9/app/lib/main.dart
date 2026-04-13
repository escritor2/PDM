import 'dart:io'; // Import necessário
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Novo import
import 'package:path/path.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AppBanco(), 
  ));
}

class AppBanco extends StatefulWidget {
  const AppBanco({super.key});

  @override 
  _AppBancoState createState() => _AppBancoState();
}

class _AppBancoState extends State<AppBanco> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _tarefas = [];

  Future<Database> criarBanco() async {
    final caminho = await getDatabasesPath();
    final path = join(caminho, 'banco.db');

    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tarefas(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT)',
        );
      },
      version: 2024,
    );
  }

  Future<void> inserirTarefa(String nome) async {
    if (nome.isEmpty) return; // Evita inserir vazio
    final Database db = await criarBanco();
    await db.insert(
      'tarefas',
      {'nome': nome},
    );
    carregarTarefas(); // Movido para fora do insert
  }

  Future<void> carregarTarefas() async {
    final Database db = await criarBanco();
    final List<Map<String, dynamic>> lista = await db.query('tarefas');
    setState(() {
      _tarefas = lista;
    });
  }

  Future<void> deletarTarefa(int id) async {
    final Database db = await criarBanco();
    await db.delete(
      'tarefas',
      where: 'id = ?',
      whereArgs: [id],
    );
    carregarTarefas();
  }

  @override
  void initState() {
    super.initState();
    carregarTarefas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Banco de Dados')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Digite uma tarefa'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              inserirTarefa(_controller.text);
              _controller.clear();
            },
            child: const Text('Adicionar Tarefa'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = _tarefas[index];
                return ListTile(
                  title: Text(tarefa['nome'] ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deletarTarefa(tarefa['id']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
