
import 'package:flutter/material.dart';
import '../services/local_service.dart';

class ResultadosScreen extends StatelessWidget {
  final String cidade;
  final String pesquisa;

  const ResultadosScreen({
    super.key,
    required this.cidade,
    required this.pesquisa
  });

  @override
  Widget build(BuildContext context){
    final service=LocalService();

    return Scaffold(
      appBar:AppBar(title:const Text('Resultados')),
      body:StreamBuilder(
        stream:service.listar(),
        builder:(context,snapshot){
          if(!snapshot.hasData){
            return const Center(child:CircularProgressIndicator());
          }

          final locais=snapshot.data!;

          return ListView.builder(
            itemCount:locais.length,
            itemBuilder:(context,index){
              final local=locais[index];
              return Card(
                child:ListTile(
                  title:Text(local.nome),
                  subtitle:Text(local.categoria),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
