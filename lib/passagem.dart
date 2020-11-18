class Passagem {
  int _id;
  String _nome;
  String _partida;
  String _destino;
  String _classe;
  
  //construtor da classe
  Passagem(this._nome, this._partida, this._destino, this._classe);

  //converte dados de vetor para objeto
  Passagem.map(dynamic obj) {
    this._id = obj['id'];
    this._nome = obj['nome'];
    this._partida = obj['partida'];
    this._destino = obj['destino'];
    this._classe = obj['classe'];
  }

  // encapsulamento
  int get id => _id;
  String get nome => _nome;
  String get partida => _partida;
  String get destino => _destino;
  String get classe => _classe;

//converte o objeto em um map
 Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
       map['id'] = _id;
    }
    map['nome'] = _nome;
    map['partida'] = _partida;
    map['destino'] = _destino;
    map['classe'] = _classe;
    return map;
  }

  //converte map em um objeto
  Passagem.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._nome = map['nome'];
    this._partida = map['partida'];
    this._destino = map['destino'];
    this._classe = map['classe'];
  }
}
