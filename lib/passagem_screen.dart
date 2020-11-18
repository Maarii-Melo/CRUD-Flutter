import 'package:flutter/material.dart';
import 'package:CRUDPassagaem/passagem.dart';
import 'package:CRUDPassagaem/database_helper.dart';

class PassagemScreen extends StatefulWidget {
  final Passagem passagem;
  PassagemScreen(this.passagem);
  @override
  State<StatefulWidget> createState() => new _PassagemScreenState();
}

class _PassagemScreenState extends State<PassagemScreen> {
  DatabaseHelper db = new DatabaseHelper();
  TextEditingController _nomeController;
  TextEditingController _partidaController;
  TextEditingController _destinoController;
  TextEditingController _classeController;
  @override
  void initState() {
    super.initState();
    _nomeController = new TextEditingController(text: widget.passagem.nome);
    _partidaController =
        new TextEditingController(text: widget.passagem.partida);
    _destinoController =
        new TextEditingController(text: widget.passagem.destino);
    _classeController = new TextEditingController(text: widget.passagem.classe);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Passagens'),
        backgroundColor: Colors.yellow,
      ),
      body: Container(
        margin: EdgeInsets.all(15.0),
        alignment: Alignment.center,
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            TextField(
              controller: _partidaController,
              decoration: InputDecoration(labelText: 'Partida'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            TextField(
              controller: _destinoController,
              decoration: InputDecoration(labelText: 'Destino'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            TextField(
              controller: _classeController,
              decoration: InputDecoration(labelText: 'Classe'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            RaisedButton(
              child: (widget.passagem.id != null)
                  ? Text('Alterar')
                  : Text('Inserir'),
              onPressed: () {
                if (widget.passagem.id != null) {
                  db
                      .updatePassagem(Passagem.fromMap({
                    'id': widget.passagem.id,
                    'nome': _nomeController.text,
                    'partida': _partidaController.text,
                    'destino': _destinoController.text,
                    'classe': _classeController.text,
                  }))
                      .then((_) {
                    Navigator.pop(context, 'update');
                  });
                } else {
                  db
                      .inserirPassagem(Passagem(
                          _nomeController.text,
                          _partidaController.text,
                          _destinoController.text,
                          _classeController.text))
                      .then((_) {
                    Navigator.pop(context, 'save');
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
