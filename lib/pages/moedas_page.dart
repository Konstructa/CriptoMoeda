import 'package:flutter/material.dart';
import 'package:hello_world/models/moeda.dart';
import 'package:hello_world/repositories/moeda_repository.dart';
import 'package:intl/intl.dart';

class MoedasPage extends StatefulWidget {

  MoedasPage({super.key});

  @override
  State<MoedasPage> createState() => _MoedasPageState();
}

class _MoedasPageState extends State<MoedasPage> {
  final tabela = MoedaRepository.tabela;

  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');

  List<Moeda> selecionadas = [];

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cripto', textAlign: TextAlign.center),
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int moeda) {
          return ListTile(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))
            ),
            leading: selecionadas.contains(tabela[moeda]) 
            ? const CircleAvatar(
              child: Icon(Icons.check),
            ) 
            : SizedBox(
              width: 40,
              child: Image.asset(tabela[moeda].icone),
            ),
            title: Text(tabela[moeda].nome, style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),),
            trailing: Text(real.format(tabela[moeda].preco)),
            selected: selecionadas.contains(tabela[moeda]),
            selectedTileColor: Colors.purple[50] ,
            onLongPress: () {
              setState(() {
                (selecionadas.contains(tabela[moeda])) 
              ? selecionadas.remove(tabela[moeda]) 
              : selecionadas.add(tabela[moeda]);
              });

              print(tabela[moeda].nome);
            },
          );
        }, 
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => const Divider(), 
        itemCount: tabela.length,
        )
    );
  }
}