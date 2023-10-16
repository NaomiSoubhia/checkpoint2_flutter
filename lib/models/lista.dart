import 'package:expense_tracker/models/item.dart';

class Lista {
  final int id;
  final String titulo;
  final String descricao;
 final List<Item> item;

  Lista(
      {required this.id,
      required this.titulo,
      required this.descricao,
      required this.item});

  factory Lista.fromMap(Map<String, dynamic> map) {
    return Lista(
      id: map['id'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      item: (map['item'] as List<dynamic>)
          .map((itemMap) => Item.fromMap(itemMap))
          .toList(),
    );
  }
}
