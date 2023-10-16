class Item {
  final int id;
  final int lista;
  final String texto;


  Item(
      {required this.id,
      required this.lista,
      required this.texto});

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      lista: map['lista'],
      texto: map['texto'],
    );
  }
}

