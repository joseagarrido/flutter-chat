import 'package:flutter/material.dart';
import 'package:realchat/widget/btn_azul.dart';
import 'package:realchat/widget/custom_input.dart';
import 'package:realchat/widget/label.dart';
import 'package:realchat/widget/logo.dart';

class RegisterPage extends StatelessWidget {
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
                Logo(
                  titulo: 'Register',
                ),
                _Form(),
                Labels(
                  label1: '¿Ya tienes cuenta?',
                  label2: 'Inicia sesión!',
                  ruta:'login'
                ),
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
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomImput(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            //keyboardType: TextInputType.emailAddress,
            textController: this.nameCtrl,
          ),
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
              text: 'Registrar',
              onPressed: () {
                print(this.emailCtrl.text);
                print(this.passCtrl.text);
              })
        ],
      ),
    );
  }
}