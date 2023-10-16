import 'package:expense_tracker/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegistrarPage extends StatefulWidget {
  const RegistrarPage({Key? key}) : super(key: key);

  @override
  State<RegistrarPage> createState() => _RegistrarPageState();
}

void main() async {
  await Supabase.initialize(
    url: 'https://lmtfvyxrmihlsharofjd.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxtdGZ2eXhybWlobHNoYXJvZmpkIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTc0ODE3NDEsImV4cCI6MjAxMzA1Nzc0MX0.7jrHphYJAiAmVtSvwXt4w7JqNzOY4L5WgIUNbVhb2ME',
  );
  runApp(const MaterialApp(
    home: RegistrarPage(),
  ));
}

class _RegistrarPageState extends State<RegistrarPage> {
  final _key = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _key,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBemVindo(),
                  const SizedBox(height: 20),
                  _buildEmail(),
                  const SizedBox(height: 20),
                  _buildSenha(),
                  const SizedBox(height: 20),
                  _buildConfirmarSenha(),
                  const SizedBox(height: 10),
                  _buildButton(),
                  const SizedBox(height: 10),
                  _buildRegistrar(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Text _buildBemVindo() {
    return const Text(
      "Registrar-se",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 26,
      ),
    );
  }

  TextFormField _buildEmail() {
    return TextFormField(
      controller: emailController,
      validator: (String? email) {
        if (email == null || email.isEmpty) {
          return "Por favor, digite seu e-mail";
        } else if (!validarEmail(email)) {
          return "Por favor, digite um e-mail válido";
        }
        return null;
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Digite seu e-mail",
        prefixIcon: Icon(Icons.email_outlined),
      ),
    );
  }

  TextFormField _buildSenha() {
    return TextFormField(
      controller: senhaController,
      validator: (senha) {
        if (senha == null || senha.isEmpty) {
          return "Por favor, digite sua senha";
        } else if (senha.length < 6) {
          return "A senha deve ter pelo menos 6 caracteres";
        }
        return null;
      },
      obscureText: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Digite sua senha",
        prefixIcon: Icon(Icons.lock_outline_rounded),
        suffixIcon: Icon(Icons.visibility_outlined),
      ),
    );
  }

  TextFormField _buildConfirmarSenha() {
    return TextFormField(
      controller: confirmarSenhaController,
      validator: (senha) {
        if (senha == null || senha.isEmpty) {
          return "Por favor, digite sua senha";
        }
        if (senha != senhaController.text) {
          return "As senhas não coincidem";
        }
        return null;
      },
      obscureText: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Confirme sua senha",
        prefixIcon: Icon(Icons.lock_outline_rounded),
        suffixIcon: Icon(Icons.visibility_outlined),
      ),
    );
  }

  Widget _buildButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final email = emailController.text;
          final senha = senhaController.text;
          registrarNoSupabase(email, senha);
        },
        child: const Text('Registrar'),
      ),
    );
  }

  Widget _buildRegistrar() {
    return GestureDetector(
      onTap: () {
        // Adicione ações adicionais aqui, se necessário.
      },
      child: RichText(
        text: TextSpan(children: <InlineSpan>[
          TextSpan(
            text: "Já tem uma conta?",
            style: TextStyle(
                color: Colors.blueGrey.shade300,
                fontSize: 12,
                fontWeight: FontWeight.w400),
          ),
          TextSpan(
            text: ' ',
            style: TextStyle(
                color: Colors.indigo.shade300,
                fontSize: 12,
                fontWeight: FontWeight.w700),
          ),
          TextSpan(
            text: "Login",
            style: TextStyle(
                color: Colors.lightBlue.shade300,
                fontSize: 12,
                fontWeight: FontWeight.w700),
          )
        ]),
        textAlign: TextAlign.center,
      ),
    );
  }

  bool validarEmail(String email) {
    const pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zAZ0-9-.]+$)';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  Future<void> registrarNoSupabase(String email, String senha) async {
    try {
                print(email);
          print(senha);
      final response = await Supabase.instance.client
          .from('check')
          .insert([
            {
              'email': email,
              'senha': senha,
              
            },
          ])
          .execute();

      if (response.status != 201) {
        throw Exception(response.status);
      } else {
        // Registro bem-sucedido.
        print("Registrado com sucesso!");
        Navigator.pushReplacementNamed(context, "/login");
      }
    } catch (e) {
      print("Erro ao registrar: $e");
    }
  }
}
