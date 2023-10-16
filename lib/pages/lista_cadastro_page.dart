import 'package:expense_tracker/pages/bancos_select_page.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../components/banco_select.dart';
import '../models/banco.dart';
import '../models/lista.dart';

class ListaCadastroPage extends StatefulWidget {
  const ListaCadastroPage({super.key});

  @override
  State<ListaCadastroPage> createState() => _ListaCadastroPageState();
}

class _ListaCadastroPageState extends State<ListaCadastroPage> {
  final descricaoController = TextEditingController();
  final tituloController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Lista'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitulo(),
                const SizedBox(height: 30),
                _buildDescricao(),
                const SizedBox(height: 30),
                
                _buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField  _buildTitulo() {
     return TextFormField(
      controller: tituloController,
      decoration: const InputDecoration(
        hintText: 'Informe o Titulo',
        labelText: 'Titulo',
        prefixIcon: Icon(Ionicons.text_outline),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe um Titulo';
        }
        if (value.length < 5 || value.length > 15) {
          return 'O titulo deve ter entre 5 e 15 caracteres';
        }
        return null;
      },
    );
  }

  TextFormField _buildDescricao() {
    return TextFormField(
      controller: descricaoController,
      decoration: const InputDecoration(
        hintText: 'Informe a descrição',
        labelText: 'Descrição',
        prefixIcon: Icon(Ionicons.text_outline),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe uma Descrição';
        }
        if (value.length < 5 || value.length > 30) {
          return 'A Descrição deve entre 5 e 30 caracteres';
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
          final descricao = descricaoController.text;
          registrarNoSupabase(titulo, descricao);
          }
        },
        child: const Text('Cadastrar'),
      ),
    );
  }

    Future<void> registrarNoSupabase(String titulo, String descricao) async {
    try {
               
      final response = await Supabase.instance.client
          .from('lista')
          .insert([
            {
              'titulo': titulo,
              'descricao': descricao,
              
            },
          ])
          .execute();

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




