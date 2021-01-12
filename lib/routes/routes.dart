

import 'package:flutter/material.dart';
import 'package:realchat/pages/chat_page.dart';
import 'package:realchat/pages/loading_page.dart';
import 'package:realchat/pages/login_page.dart';
import 'package:realchat/pages/register_page.dart';
import 'package:realchat/pages/usuarios_page.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'usuarios': ( _ ) => UsuariosPage(),
  'chat':     ( _ ) => ChatPage(),
  'loading':  ( _ ) => LoadingPage(),
  'register': ( _ ) => RegisterPage(),
  'login':    ( _ ) => LoginPage()
};
