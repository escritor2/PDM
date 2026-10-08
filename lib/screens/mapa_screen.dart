
import 'package:flutter/material.dart';
import 'resultados_screen.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState()=>_MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen>{
  String cidade='Campinas';
  final pesquisa=TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa de Locais')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children:[
            DropdownButtonFormField(
              value:cidade,
              items:['Campinas','São Paulo','Jundiaí']
                .map((e)=>DropdownMenuItem(
                  value:e,
                  child:Text(e)))
                .toList(),
              onChanged:(v)=>setState(()=>cidade=v!),
            ),
            const SizedBox(height:20),
            TextField(
              controller:pesquisa,
              decoration:const InputDecoration(
                labelText:'Pesquisar',
                border:OutlineInputBorder()
              ),
            ),
            const SizedBox(height:20),
            Expanded(
              child:Container(
                decoration:BoxDecoration(
                  color:Colors.blue.shade100,
                  borderRadius:BorderRadius.circular(20)
                ),
                child:const Center(
                  child:Icon(Icons.map,size:120),
                ),
              ),
            ),
            ElevatedButton(
              onPressed:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:(_)=>ResultadosScreen(
                      cidade:cidade,
                      pesquisa:pesquisa.text
                    )
                  )
                );
              },
              child:const Text('Resultados')
            )
          ],
        ),
      ),
    );
  }
}
