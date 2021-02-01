
import 'package:flutter/material.dart';
import 'package:realchat/global/enviroment.dart';
import 'package:realchat/services/auth_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier {

IO.Socket _socket;

ServerStatus _serverStatus = ServerStatus.Connecting;

ServerStatus get serverStatus => this._serverStatus;

IO.Socket get socket => _socket; 
Function get emit => this._socket.emit;


void connect() async {
  final token = await AuthService.getToken();
// Dart client
    _socket = IO.io(Enviroment.socketUrl ,{
    'transports': ['websocket'],
    'autoConnect': true,
    'forceNew': true,
    'extraHeaders': {
      'x-token':token
    }
    });
    _socket.onConnect((_) {
     this._serverStatus = ServerStatus.Online;
     notifyListeners();
    });
    
    _socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
}

void disconnect(){

  this._socket.disconnect();

}


}
