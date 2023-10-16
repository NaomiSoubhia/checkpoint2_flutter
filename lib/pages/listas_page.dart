import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListasPage extends StatefulWidget {
  const ListasPage({Key? key}) : super(key: key);

  @override
  State<ListasPage> createState() => _ListasPageState();
}

class _ListasPageState extends State<ListasPage> {
  final client = SupabaseClient(
     'https://lmtfvyxrmihlsharofjd.supabase.co',
   'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxtdGZ2eXhybWlobHNoYXJvZmpkIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTc0ODE3NDEsImV4cCI6MjAxMzA1Nzc0MX0.7jrHphYJAiAmVtSvwXt4w7JqNzOY4L5WgIUNbVhb2ME',
  
  );

    final _subscription = Supabase.instance.client.from('lista').stream(primaryKey: ['id']);




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listas'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _subscription,
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return const Center(child: CircularProgressIndicator(),);
          }
          final notes = snapshot.data!;

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(notes[index]['titulo']),
                subtitle: Text(notes[index]['descricao']),
              );
            },
            );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "lista-cadastro",
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/lista-cadastro');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
