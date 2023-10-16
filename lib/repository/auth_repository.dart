import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
Future<bool> login(String email, String senha) async {
  final response = await Supabase.instance.client
      .from('check')
      .select()
      .eq('email', email)
      .eq('senha', senha)
      .execute();

  if (response.status != 200) {
    // Ocorreu um erro na consulta
    throw AuthException('Erro na consulta: ${response.status}');
  }

  // Verifica se a consulta retornou algum resultado
  if (response.data != null && response.data is List && response.data.isNotEmpty) {
    // Encontrou um registro com as credenciais fornecidas
    return true;
  } else {
    // Nenhum registro encontrado com as credenciais fornecidas
    return false;
  }
}



  Future registrar(String email, String senha) async {
    final supabase = Supabase.instance.client;
    await supabase.auth.signUp(password: senha, email: email);
  }
}
