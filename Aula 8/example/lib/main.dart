import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SalvarTextoApp(),
  ));
}

class SalvarTextoApp extends StatefulWidget {
  const SalvarTextoApp({super.key});

  @override
  SalvarTextoAppState createState() => SalvarTextoAppState();
}

class SalvarTextoAppState extends State<SalvarTextoApp> {
  TextEditingController controller = TextEditingController();
  String textoSalvo = '';

  @override
  void initState() {
    super.initState();
    carregarTexto();
  }

  void salvarTexto() async {
    final prefs = await SharedPreferences.getInstance();
    // Salva como String
    await prefs.setString('texto', controller.text);

    setState(() {
      textoSalvo = controller.text;
    });
  }

  void carregarTexto() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      textoSalvo = prefs.getString('texto') ?? '';
      controller.text = textoSalvo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Salvar dados"),
      ),
      // 3. Body fora do AppBar
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Digite algo para salvar",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: salvarTexto,
              child: const Text("Salvar"),
            ),
            const SizedBox(height: 20),
            Text(
              "Texto salvo: $textoSalvo",
              style: const TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}
