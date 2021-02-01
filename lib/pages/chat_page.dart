import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realchat/models/mensajes_response.dart';
import 'package:realchat/services/auth_service.dart';
import 'package:realchat/services/chat_service.dart';
import 'package:realchat/services/socket_service.dart';
import 'package:realchat/widget/mensaje.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();

  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  List<Mensaje> _mensajes = []; 

  bool _escribiendo= false;

  @override
  void initState() { 
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);

    this.socketService.socket.on('mensajepersonal', _escucharMensaje);

    _cargarHistorial(this.chatService.usuarioPara.uid);
    
  }

  void _cargarHistorial ( String usuarioID)  async {
    List<MensajeDB> chat = await this.chatService.getChat(usuarioID);
    //print(chat);
    final history = chat.map((m) => new Mensaje(
      texto: m.mensaje, 
      uid: m.de, 
      animationController: new AnimationController( vsync: this, duration: Duration(milliseconds:0))..forward()
      ));
    setState(() {
      _mensajes.insertAll(0, history);
    });
  }

  void _escucharMensaje (dynamic payload){
    Mensaje mensaje = new Mensaje(
      texto: payload['mensaje'], 
      uid: payload['de'], 
      animationController: AnimationController( vsync: this, duration: Duration(milliseconds:300))
      );
    setState(() {
      _mensajes.insert(0, mensaje);
    });
    mensaje.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    
    final usuario = chatService.usuarioPara;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              maxRadius: 15,
              child: Text(usuario.nombre.substring(0,2) , style: TextStyle(fontSize: 14)),
              backgroundColor: Colors.blue[100],
            ),
            SizedBox(height: 3),
            Text(
              usuario.nombre,
              style: TextStyle(color: Colors.black87, fontSize: 14),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _mensajes.length,
                itemBuilder: (_, int i) => _mensajes[i],
                reverse: true,
                ),
                
              ),
            
            Divider(height: 1),
            Container(
              color: Colors.white,
              height: 100,
              child: _inputChat(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmit,
              onChanged: (String texto) {
                setState(() {
                  texto.trim().length > 0 ? _escribiendo = true : _escribiendo = false;
                }); 
              },
              decoration: InputDecoration.collapsed(hintText: 'Enviar mensaje'),
              focusNode: _focusNode,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: IconTheme(
              data: IconThemeData(color: Colors.blue[400]),
              child: IconButton(
                  icon: Icon(
                    Icons.send,
                  ),
                  onPressed: _escribiendo ? () =>_handleSubmit(_textController.text) : null,
              ),
            ),
          ),
        ],
      ),
    ));
  }

  _handleSubmit(String texto) {
    //print(texto);
    if (texto.length == 0) return;
    _textController.clear();
    _focusNode.requestFocus();

   final newMensaje = new Mensaje(
     uid:authService.usuario.uid, 
     texto:texto,
     animationController: AnimationController(vsync: this, duration: Duration(milliseconds:200)),
     );

   _mensajes.insert(0, newMensaje);
   newMensaje.animationController.forward();

    setState(() {
      _escribiendo = false;
    });

    this.socketService.socket.emit('mensajepersonal',{
      'de': this.authService.usuario.uid,
      'para': this.chatService.usuarioPara.uid,
      'mensaje': texto
    });
  }

  @override
  void dispose() {
    
    for (Mensaje mensaje in _mensajes){
      mensaje.animationController.dispose();
    }
    this.socketService.socket.off('mensajepersonal');
    super.dispose();
  }
}
