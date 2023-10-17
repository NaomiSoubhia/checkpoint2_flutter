import 'package:expense_tracker/pages/bancos_select_page.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../components/banco_select.dart';
import '../models/banco.dart';
import '../models/item.dart';

class ItemCadastroPage extends StatefulWidget {
  final Nmlista;

  ItemCadastroPage({required this.Nmlista});
  @override
  State<ItemCadastroPage> createState() => _ItemCadastroPageState();
}

class _ItemCadastroPageState extends State<ItemCadastroPage> {
  final textoController = TextEditingController();
  final tituloController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Item'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTexto(),
                const SizedBox(height: 30),
                _buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildTexto() {
    return TextFormField(
      controller: textoController,
      decoration: const InputDecoration(
        hintText: 'Informe o item',
        labelText: 'Item',
        prefixIcon: Icon(Ionicons.text_outline),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe um Item';
        }
        if (value.length < 5 || value.length > 15) {
          return 'O item deve conter entre 5 e 15 caracteres';
        }
        return null;
      },
    );
  }

  SizedBox _buildButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final isValid = _formKey.currentState!.validate();
          if (isValid) {
            final titulo = tituloController.text;
            final texto = textoController.text;
            registrarNoSupabase(titulo, texto);
          }
        },
        child: const Text('Cadastrar'),
      ),
    );
  }

  Future<void> registrarNoSupabase(String lista, String texto) async {
    try {
      final response = await Supabase.instance.client.from('item').insert([
        {
          'lista': widget.Nmlista,
          'texto': texto,
        },
      ]).execute();

      if (response.status != 201) {
        throw Exception(response.status);
      } else {
        print("Cadastrado com sucesso!");
        Navigator.pushReplacementNamed(context, "/");
      }
    } catch (e) {
      print("Erro ao cadastrar: $e");
    }
  }
}
