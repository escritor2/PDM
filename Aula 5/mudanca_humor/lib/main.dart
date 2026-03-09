import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HumorState(),
  ));
}

class HumorState extends StatefulWidget {
  const  HumorState({ super.key});
  @override
  _HumorStateState createState() => _HumorStateState();
}

class _HumorStateState extends State<HumorState> {
  String _humor = 'Neutro';

  void _alterarHumor() {
    setState(() {
      if (_humor == 'Neutro') {
        _humor = 'Feliz 😊';
      } else if (_humor == 'Feliz 😊') {
        _humor = 'Bravo 😠';
      } else {
        _humor = 'Neutro 😐';
        
      }
    });
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(
        title: Text('Seletor de Humor'),
        centerTitle: true,
      ),
      body: Center( 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Humor Atual:',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              _humor,
              style: TextStyle(
                fontSize: 40, 
                fontWeight: FontWeight.bold,
                color: _humor == 'Bravo' ? Colors.red : Colors.blue,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _alterarHumor, 
              style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
              child: Text('PRÓXIMO HUMOR'),
            ),
          ],
        ),
      ),
    );
  }
}
