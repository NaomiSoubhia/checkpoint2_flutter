import 'package:expense_tracker/pages/item_cadastro_page.dart';
import 'package:expense_tracker/pages/lista_cadastro_page.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/lista.dart';
import 'package:expense_tracker/models/item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListaPage extends StatefulWidget {
  final  numLista;
  

  ListaPage({required this.numLista});

  @override
  _ListaPageState createState() => _ListaPageState();
}

class _ListaPageState extends State<ListaPage> {
  
  TextEditingController itemTextController = TextEditingController();
  final listaNameController = TextEditingController();
  
  final client = SupabaseClient(
    'https://lmtfvyxrmihlsharofjd.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxtdGZ2eXhybWlobHNoYXJvZmpkIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTc0ODE3NDEsImV4cCI6MjAxMzA1Nzc0MX0.7jrHphYJAiAmVtSvwXt4w7JqNzOY4L5WgIUNbVhb2ME',
  );

  final _subscription =
      Supabase.instance.client.from('item').stream(primaryKey: ['id']);




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Itens'),
      ),
   body: StreamBuilder<List<Map<String, dynamic>>>(
  stream: _subscription,
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    final notes = snapshot.data!;
  
    final filteredItems = notes.where((item) => int.parse(item['lista']) == widget.numLista).toList();

    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(filteredItems[index]['texto']),
        );
      },
    );
  },
),


      floatingActionButton: FloatingActionButton(
  heroTag: "lista-cadastro",
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemCadastroPage(Nmlista: widget.numLista),
      ),
    );
  },
        child: const Icon(Icons.add),
      ),
    );
  }
}
