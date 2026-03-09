import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: InterruptorApp(),
  ));
}

class InterruptorApp extends StatefulWidget {
  @override
  _InterruptorAppState createState() => _InterruptorAppState();
}

class _InterruptorAppState extends State<InterruptorApp> {
  bool acesoEsta = false;

  void luzAlternativa() {
    setState(() {
      acesoEsta = !acesoEsta;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: acesoEsta ? Colors.yellow[100] : Colors.grey[900],
      appBar: AppBar(
        title: Text(
          'Interruptor',
          style: TextStyle(color: acesoEsta ? Colors.black : Colors.white),
        ),
        backgroundColor: acesoEsta ? Colors.yellow : Colors.grey[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              acesoEsta ? Icons.lightbulb : Icons.lightbulb_outline,
              size: 100,
              color: acesoEsta ? Colors.red : Colors.white,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: luzAlternativa,
              child: Text(acesoEsta ? 'APAGAR' : 'ACENDER'),
              style: ElevatedButton.styleFrom(
                backgroundColor: acesoEsta ? Colors.black : const Color.fromARGB(255, 255, 255, 255),
                foregroundColor: acesoEsta ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
