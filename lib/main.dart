import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realchat/routes/routes.dart';
import 'package:realchat/services/auth_service.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider (
          providers: [
              ChangeNotifierProvider(create: (_)=> AuthService()),
          ],
          child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}