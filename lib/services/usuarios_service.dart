import 'package:http/http.dart' as http;

import 'package:realchat/models/usuario.dart';

import 'package:realchat/global/enviroment.dart';
import 'package:realchat/models/usuarios_response.dart';
import 'package:realchat/services/auth_service.dart';

class UsuariosService {

  Future<List<Usuario>> getUsuarios() async {

    try {
      final resp = await http.get(
      '${Enviroment.apiUrl}/usuarios',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-token': await AuthService.getToken()
      });
      final usuariosResponse = usuariosResponseFromJson(resp.body);
      return usuariosResponse.usuarios;
      
    } catch (e) {
      return [];
    }
  }
}