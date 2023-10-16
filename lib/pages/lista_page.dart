import 'package:flutter/material.dart';
import 'package:expense_tracker/models/lista.dart';
import 'package:expense_tracker/models/item.dart';


import 'package:expense_tracker/components/conta_item.dart';
import 'package:expense_tracker/models/conta.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repository/contas_repository.dart';
class ListaPage extends StatefulWidget {
  final Lista lista;

  ListaPage({required this.lista});

  @override
  _ListaPageState createState() => _ListaPageState();
}

class _ListaPageState extends State<ListaPage> {
  TextEditingController itemTextController = TextEditingController();
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    items = widget.lista.item;
  }

  void addItem() {
    final newItem = Item(
      id: items.length + 1, // Você pode ajustar a lógica para gerar um ID único.
      lista: widget.lista.id,
      texto: itemTextController.text,
    );

    setState(() {
      items.add(newItem);
      itemTextController.clear();
    });
  }

  void deleteItem(Item item) {
    setState(() {
      items.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lista.titulo),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.texto),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteItem(item);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: itemTextController,
                    decoration: InputDecoration(labelText: 'Novo Item'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: addItem,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
