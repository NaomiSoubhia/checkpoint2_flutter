import 'package:expense_tracker/components/conta_item.dart';
import 'package:expense_tracker/models/conta.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repository/contas_repository.dart';

class ListasPage extends StatefulWidget {
  const ListasPage({Key? key}) : super(key: key);

  @override
  State<ListasPage> createState() => _ListasPageState();
}

class _ListasPageState extends State<ListasPage> {
  final contasFuture = ContasRepository().listarContas();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contas'),
      ),
      body: FutureBuilder<List<Conta>>(
        future: contasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Erro ao carregar contas"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Nenhuma conta encontrada"),
            );
          } else {
            final contas = snapshot.data!;
            return ListView.separated(
              itemCount: contas.length,
              itemBuilder: (context, index) {
                final conta = contas[index];
                return ContaItem(conta: conta);
              },
              separatorBuilder: (context, index) => const Divider(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "conta-cadastro",
        onPressed: () {
          Navigator.pushNamed(context, '/conta-cadastro');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
