import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compra Inteligente',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CompraInteligente(),
    );
  }
}

class CompraInteligente extends StatefulWidget {
  const CompraInteligente({Key? key}) : super(key: key);

  @override
  State<CompraInteligente> createState() => _CompraInteligenteState();
}

class _CompraInteligenteState extends State<CompraInteligente> {
  List<String> itens = [];
  List<bool> comprado = [];
  final controller = TextEditingController();
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  void adicionarItem() {
    if (controller.text.isNotEmpty) {
      setState(() {
        itens.add(controller.text);
        comprado.add(false);
      });
      controller.clear();
      salvarDados();
    }
  }

  void alternarComprado(int index) {
    setState(() {
      comprado[index] = !comprado[index];
    });
    salvarDados();
  }

  void salvarDados() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setStringList("itens", itens);
    prefs.setStringList(
      "comprado",
      comprado.map((e) => e.toString()).toList(),
    );
  }

  void carregarDados() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      itens = prefs.getStringList("itens") ?? [];
      List<String> listaBool = prefs.getStringList("comprado") ?? [];
      comprado = listaBool.map((e) => e == "true").toList();
    });
  }

  void limparLista() {
    setState(() {
      itens.clear();
      comprado.clear();
    });
    salvarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compra Inteligente'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Adicionar item',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: adicionarItem,
                  child: const Text('Adicionar'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: ${itens.length}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: limparLista,
                  style: ElevatedButton.styleFrom(backgroundColor:      const Color.fromARGB(255, 255, 17, 0)),
                  child: const Text('Limpar Lista'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: itens.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Checkbox(
                    value: comprado[index],
                    onChanged: (_) => alternarComprado(index),
                  ),
                  title: Text(
                    itens[index],
                    style: TextStyle(
                      decoration: comprado[index]
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: comprado[index] ? Colors.grey : Colors.black,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        itens.removeAt(index);
                        comprado.removeAt(index);
                      });
                      salvarDados();
                    },
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
