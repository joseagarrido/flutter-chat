import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:realchat/global/enviroment.dart';

import 'package:realchat/models/usuario.dart';
import 'package:realchat/models/mensajes_response.dart';
import 'package:realchat/services/auth_service.dart';


class ChatService with ChangeNotifier {

  Usuario usuarioPara;

 Future<List<MensajeDB>> getChat(String usuarioID) async {

    try {
      final resp = await http.get(
      '${Enviroment.apiUrl}/mensajes/$usuarioID',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-token': await AuthService.getToken()
      });
      final mensajesResponse = mensajesResponseFromJson(resp.body);
      return mensajesResponse.mensajes;
      
    } catch (e) {
      return [];
    }
  }

}

