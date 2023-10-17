import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ItemEdicaoPage extends StatefulWidget {
  final Map<String, dynamic> item;

  ItemEdicaoPage({required this.item});

  @override
  _ItemEdicaoPageState createState() => _ItemEdicaoPageState();
}

class _ItemEdicaoPageState extends State<ItemEdicaoPage> {
  late TextEditingController textoController;

  @override
  void initState() {
    super.initState();
    textoController = TextEditingController(text: widget.item['texto']);
  }

  Future<void> atualizarItemNoSupabase(Map<String, dynamic> updatedItem) async {
    final client = Supabase.instance.client;
    final response = await client
        .from('item')
        .update(updatedItem)
        .eq('id', updatedItem['id'])
        .execute();

    if (response.status == 204) {
      // Item atualizado com sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item atualizado com sucesso!')),
      );

      // Navegação para a página de login após o sucesso
      Navigator.pushReplacementNamed(context, "/listas");
    } else {
      // Erro ao atualizar o item
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar o item')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: textoController,
              decoration: const InputDecoration(
                labelText: 'Texto do Item',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final updatedItem = {
                  'id': widget.item['id'],
                  'texto': textoController.text,
                };

                // Chame a função para atualizar o item no Supabase
                atualizarItemNoSupabase(updatedItem);
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
