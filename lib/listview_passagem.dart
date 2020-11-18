import 'package:flutter/material.dart';
import 'package:CRUDPassagaem/passagem.dart';
import 'package:CRUDPassagaem/database_helper.dart';
import 'package:CRUDPassagaem/passagem_screen.dart';

class ListViewPassagem extends StatefulWidget {
  @override
  _ListViewPassagemState createState() => new _ListViewPassagemState();
}

class _ListViewPassagemState extends State<ListViewPassagem> {
  List<Passagem> items = new List();
  //conexão com banco de dados
  DatabaseHelper db = new DatabaseHelper();
  @override
  void initState() {
    super.initState();
    db.getPassagens().then((passagem) {
      setState(() {
        passagem.forEach((passagem) {
          items.add(Passagem.fromMap(passagem));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Passagens Cadastradas',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Passagens'),
          centerTitle: true,
          backgroundColor: Colors.yellow,
        ),
        body: Center(
          child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (context, position) {
                return Column(
                  children: [
                     Container(
                        padding: EdgeInsets.all(15),
                        child: Image.network(
                            'https://f088b146830a59b5.cdn.gocache.net/uploads/noticias/2020/03/14/3uau0xpgtx4wk.jpg',
                            loadingBuilder: (context, child, progress) {
                          return progress == null
                              ? child
                              : LinearProgressIndicator();
                        })),
                    Divider(height: 5.0),
                    ListTile(
                      title: Text(
                        '${items[position].nome}',
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Row(children: [
                        Text('${items[position].partida}',
                            style: new TextStyle(
                              fontSize: 18.0,
                              fontStyle: FontStyle.italic,
                            )),
                        Text('${items[position].destino}',
                            style: new TextStyle(
                              fontSize: 18.0,
                              fontStyle: FontStyle.italic,
                            )),
                        Text('${items[position].classe}',
                            style: new TextStyle(
                              fontSize: 18.0,
                              fontStyle: FontStyle.italic,
                            )),
                        IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => _deletePassagem(
                                context, items[position], position)),
                      ]),
                      leading: CircleAvatar(
                        backgroundColor: Colors.yellowAccent,
                        radius: 15.0,
                        child: Text(
                          '${items[position].id}',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                      onTap: () =>
                          _navigateToPassagem(context, items[position]),
                    ),
                  ],
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _createNewPassagem(context),
        ),
      ),
    );
  }

  void _deletePassagem(BuildContext context, Passagem passagem, int position) async {
    db.deletePassagem(passagem.id).then((passagens) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _navigateToPassagem(BuildContext context, Passagem passagem) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PassagemScreen(passagem)),
    );
    if (result == 'update') {
      db.getPassagens().then((passagens) {
        setState(() {
          items.clear();
          passagens.forEach((passagem) {
            items.add(Passagem.fromMap(passagem));
          });
        });
      });
    }
  }

  void _createNewPassagem(BuildContext context) async {
    //aguarda o retorno da página de cadastro
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PassagemScreen(Passagem('', '', '', ''))),
    );
    //se o retorno for salvar, recarrega a lista
    if (result == 'save') {
      db.getPassagens().then((passagens) {
        setState(() {
          items.clear();
          passagens.forEach((passagem) {
            items.add(Passagem.fromMap(passagem));
          });
        });
      });
    }
  }
}
