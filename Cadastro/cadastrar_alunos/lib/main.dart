import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cadastro de Aluno',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CadastroAlunoPage(),
    );
  }
}

// Classe Model com conversão para JSON (necessária para salvar no SharedPreferences)
class Aluno {
  final String nome;
  final int idade;
  final String curso;

  Aluno({required this.nome, required this.idade, required this.curso});

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'idade': idade,
        'curso': curso,
      };

  factory Aluno.fromJson(Map<String, dynamic> json) {
    return Aluno(
      nome: json['nome'],
      idade: json['idade'],
      curso: json['curso'],
    );
  }
}

class CadastroAlunoPage extends StatefulWidget {
  const CadastroAlunoPage({super.key});

  @override
  State<CadastroAlunoPage> createState() => _CadastroAlunoPageState();
}

class _CadastroAlunoPageState extends State<CadastroAlunoPage> {
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final _cursoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<Aluno> _listaAlunos = [];

  @override
  void initState() {
    super.initState();
    _carregarAlunos(); // Carrega os dados assim que o app abre
  }

  // Função para carregar a lista salva no armazenamento local
  Future<void> _carregarAlunos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? alunosJson = prefs.getString('lista_alunos');

    if (alunosJson != null) {
      final List<dynamic> jsonDecoded = jsonDecode(alunosJson);
      setState(() {
        _listaAlunos = jsonDecoded.map((item) => Aluno.fromJson(item)).toList();
      });
    }
  }

  // Função para salvar a lista no armazenamento local
  Future<void> _salvarAlunos() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(_listaAlunos.map((a) => a.toJson()).toList());
    await prefs.setString('lista_alunos', jsonString);
  }

  // Função para cadastrar
  void _cadastrarAluno() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _listaAlunos.add(
          Aluno(
            nome: _nomeController.text,
            idade: int.parse(_idadeController.text),
            curso: _cursoController.text,
          ),
        );
      });

      _salvarAlunos(); // Salva as alterações

      _nomeController.clear();
      _idadeController.clear();
      _cursoController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aluno cadastrado com sucesso!')),
      );
    }
  }

  // Função para deletar
  void _deletarAluno(int index) {
    setState(() {
      _listaAlunos.removeAt(index);
    });

    _salvarAlunos(); // Salva as alterações após a remoção

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Aluno removido com sucesso!')),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    _cursoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Alunos'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Formulário
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do Aluno',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor, informe o nome';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _idadeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Idade',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.cake),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, informe a idade';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Digite um número válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _cursoController,
                    decoration: const InputDecoration(
                      labelText: 'Curso',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.school),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor, informe o curso';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _cadastrarAluno,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Cadastrar',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'Alunos Cadastrados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Lista dinâmica com botão de deletar
            Expanded(
              child: _listaAlunos.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum aluno cadastrado ainda.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _listaAlunos.length,
                      itemBuilder: (context, index) {
                        final aluno = _listaAlunos[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                aluno.nome.isNotEmpty
                                    ? aluno.nome[0].toUpperCase()
                                    : '?',
                              ),
                            ),
                            title: Text(aluno.nome),
                            subtitle: Text('Curso: ${aluno.curso} - ${aluno.idade} anos'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deletarAluno(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}