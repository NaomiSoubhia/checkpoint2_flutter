import 'package:expense_tracker/pages/item_cadastro_page.dart';
import 'package:expense_tracker/pages/lista_cadastro_page.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/lista.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListaPage extends StatefulWidget {
  final int numLista;

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
  List<Map<String, dynamic>> filteredItems = [];

  // Função para excluir um item
  void deleteItem(int itemId) async {
    try {
      final response = await client
          .from('item')
          .delete()
          .eq('id', itemId)
          .execute();
      if (response.status == 200) {
        // Item excluído com sucesso
        setState(() {
          filteredItems.removeWhere((item) => item['id'] == itemId);
        });
      } else {
        
        print('Excluido com sucesso!');
        Navigator.pushReplacementNamed(context, '/listas');
      }
    } catch (e) {
      print('Erro ao excluir o item: $e');
    }
  }

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

          filteredItems = notes
              .where((item) => item['lista'].toString() == widget.numLista.toString())
              .toList();

          return ListView.builder(
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(filteredItems[index]['texto']),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Chame a função para excluir o item
                    deleteItem(filteredItems[index]['id']);
                  },
                ),
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
