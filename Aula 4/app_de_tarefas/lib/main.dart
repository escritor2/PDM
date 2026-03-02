import 'package:flutter/material.dart';

void main() {
  runApp(const AddeExcluir());
}

class AddeExcluir extends StatelessWidget {
  const AddeExcluir({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodoPage(),
    );
  }
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final List<String> tarefas = [];
  final TextEditingController controller = TextEditingController();

  void adicionarTarefa() {
    if (controller.text.trim().isNotEmpty) {
      setState(() {
        tarefas.add(controller.text);
      });
      controller.clear();
    }
  }

  void removerTarefa(int index) {
    setState(() {
      tarefas.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Tarefas"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 200.0),
            child: Text(
              "Total: ${tarefas.length}",
              style: const TextStyle(fontSize: 26, fontStyle: FontStyle.italic, color: Color.fromARGB(255, 0, 0, 255)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Digite uma tarefa...",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => adicionarTarefa(), // Desafio 3: Enter
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: adicionarTarefa,
                  child: const Text("Adicionar"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            
            Expanded(
              child: tarefas.isEmpty
                  ? const Center( 
                      child: Text(
                        "Nenhuma tarefa adicionada",
                        style: TextStyle(fontSize: 218, color: Color.fromARGB(255, 255, 0, 0)),
                      ),
                    )
                  : ListView.builder(
                      itemCount: tarefas.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(tarefas[index]),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Color.fromARGB(255, 0, 0, 0)),
                              onPressed: () => removerTarefa(index),
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
//fim
