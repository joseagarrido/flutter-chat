import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realchat/helpers/mostrar_alerta.dart';
import 'package:realchat/services/auth_service.dart';
import 'package:realchat/services/socket_service.dart';
import 'package:realchat/widget/btn_azul.dart';
import 'package:realchat/widget/custom_input.dart';
import 'package:realchat/widget/label.dart';
import 'package:realchat/widget/logo.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Logo(titulo: 'Messenger'),
                _Form(),
                Labels(
                    label1: '¿No tienes cuenta?',
                    label2: 'Crea una ahora!',
                    ruta: 'register'),
                Text(
                  'Terminos y condiciones de uso',
                  style: TextStyle(fontWeight: FontWeight.w200),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomImput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: this.emailCtrl,
          ),
          CustomImput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            //keyboardType: TextInputType.emailAddress,
            isPassword: true,
            textController: this.passCtrl,
          ),

          //Todo: poner boton
          BtnAzul(
              text: 'Acceder',
              onPressed: authService.autenticando
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus(); //Oculta teclado
                      final loginOK = await authService.login(this.emailCtrl.text.trim(),
                          this.passCtrl.text.trim());
                      if (loginOK) {
                        socketService.connect();
                        Navigator.pushReplacementNamed(context, 'usuarios');
                      } else {
                        mostrarAlerta(context, 'Login incorrecto', 'Incorrecto');
                      }
                    })
        ],
      ),
    );
  }
}
