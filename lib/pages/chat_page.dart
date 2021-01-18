import 'package:flutter/material.dart';
import 'package:realchat/widget/mensaje.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();

  List<Mensaje> _mensajes = [
    
  ]; 

  bool _escribiendo= false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              maxRadius: 15,
              child: Text('La', style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blueAccent,
            ),
            SizedBox(height: 3),
            Text(
              'Laura Nevado',
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
     uid:'123', 
     texto:texto,
     animationController: AnimationController(vsync: this, duration: Duration(milliseconds:200)),
     );

   _mensajes.insert(0, newMensaje);
   newMensaje.animationController.forward();

    setState(() {
      _escribiendo = false;
    });
  }

  @override
  void dispose() {
    // TODO: off socket
    for (Mensaje mensaje in _mensajes){
      mensaje.animationController.dispose();
    }
    super.dispose();
  }
}
