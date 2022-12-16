import 'package:flutter/material.dart';
import 'package:hello_world/configs/app_settings.dart';
import 'package:hello_world/models/moeda.dart';
import 'package:hello_world/pages/moedas_detalhes_page.dart';
import 'package:hello_world/repositories/favoritas_repository.dart';
import 'package:hello_world/repositories/moeda_repository.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MoedasPage extends StatefulWidget {
  const MoedasPage({super.key});

  @override
  State<MoedasPage> createState() => _MoedasPageState();
}

class _MoedasPageState extends State<MoedasPage> {
  final tabela = MoedaRepository.tabela;

  late NumberFormat real;

  late Map<String, String> loc;

  List<Moeda> selecionadas = [];

  late FavoritasRepository favoritas;

  readNumberFormat() {
    loc = context.watch<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
  }

  changeLanguageButton() {
    final locale = loc['locale'] == 'pt_BR' ? 'en_US' : 'pt_BR';
    final name = loc['locale'] == 'pt_BR' ? '\$' : 'R\$';

    return PopupMenuButton(
      icon: const Icon(Icons.language),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.swap_vert),
            title: Text('Usar $locale'),
            onTap: (() {
              context.read<AppSettings>().setLocale(locale, name);
              Navigator.pop(context);
            }),
          ),
        ),
      ],
    );
  }

  appBarDinamica() {
    if (selecionadas.isEmpty) {
      return AppBar(
        title: const Text('Cripto'),
        actions: [
          changeLanguageButton(),
        ],
      );
    } else {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (() {
            setState(() {
              selecionadas = [];
            });
          }),
        ),
        title: Text('${selecionadas.length} selecionadas'),
      );
    }
  }

  mostrarDetalhes(Moeda moeda) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => MoedaDetalhesPage(moeda: moeda)));
  }

  limparSelecionadas() {
    setState(() {
      selecionadas = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    // favoritas = Provider.of<FavoritasRepository>(context);
    favoritas = context.watch<FavoritasRepository>();
    readNumberFormat();

    return Scaffold(
        appBar: appBarDinamica(),
        body: ListView.separated(
          itemBuilder: (BuildContext context, int moeda) {
            return ListTile(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              leading: selecionadas.contains(tabela[moeda])
                  ? const CircleAvatar(
                      child: Icon(Icons.check),
                    )
                  : SizedBox(
                      width: 40,
                      child: Image.asset(tabela[moeda].icone),
                    ),
              title: Row(
                children: [
                  Text(
                    tabela[moeda].nome,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (favoritas.lista.contains(tabela[moeda]))
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.star_border_purple500,
                          color: Colors.blueAccent, size: 10),
                    ),
                ],
              ),
              trailing: Text(real.format(tabela[moeda].preco)),
              selected: selecionadas.contains(tabela[moeda]),
              selectedTileColor: Colors.purple[50],
              onLongPress: () {
                setState(() {
                  (selecionadas.contains(tabela[moeda]))
                      ? selecionadas.remove(tabela[moeda])
                      : selecionadas.add(tabela[moeda]);
                });
              },
              onTap: (() => mostrarDetalhes(tabela[moeda])),
            );
          },
          padding: const EdgeInsets.all(16),
          separatorBuilder: (_, __) => const Divider(),
          itemCount: tabela.length,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: selecionadas.isNotEmpty
            ? FloatingActionButton.extended(
                onPressed: () {
                  favoritas.saveAll(selecionadas);
                  limparSelecionadas();
                },
                icon: const Icon(Icons.star),
                label: const Text(
                  'FAVORITAR',
                  style:
                      TextStyle(letterSpacing: 0, fontWeight: FontWeight.bold),
                ),
              )
            : null);
  }
}
