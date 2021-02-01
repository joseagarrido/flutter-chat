import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:realchat/models/usuario.dart';
import 'package:realchat/services/auth_service.dart';
import 'package:realchat/services/chat_service.dart';
import 'package:realchat/services/socket_service.dart';
import 'package:realchat/services/usuarios_service.dart';

class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
final usuariosService = new UsuariosService();



RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<Usuario> usuarios = [];

  @override
  void initState() { 
    this._cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          authService.usuario.nombre,
          style: TextStyle(color: Colors.black87),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.black87),
          onPressed: () {
            socketService.disconnect();
            AuthService.deleteToken();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            //child: Icon(Icons.check_circle, color:Colors.blue[400]),
            child: (socketService.serverStatus== ServerStatus.Offline) 
              ? Icon(Icons.offline_bolt, color: Colors.red)
              :Icon(Icons.check_circle, color:Colors.blue[400]),
          ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        child: _listViewUsuarios(),
        onRefresh: _cargarUsuarios,
        enablePullDown: true,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue[400],
        ),


      )
    );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: usuarios.length,
      separatorBuilder: (_, int i) => Divider(),
      itemBuilder: (_, int i) =>  _usuarioListTile(usuarios[i]),
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
          title: Text(usuario.nombre),
          subtitle: Text(usuario.email),
          leading: CircleAvatar(
            child: Text(usuario.nombre.substring(0,2)) ,
            backgroundColor: Colors.blue[100],
          ),
        trailing: Container(
          width: 10,
          height:10,
          decoration: BoxDecoration(
            color: usuario.onLine ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)

          ),
        ),
        onTap: () {
          final chatService  = Provider.of<ChatService>(context, listen: false);
          chatService.usuarioPara = usuario;
          Navigator.pushNamed(context, 'chat');
        },
        );
  }


  _cargarUsuarios () async{
    // monitor network fetch
    
    this.usuarios  =await usuariosService.getUsuarios();
    setState(() { });
    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
