import 'package:flutter/material.dart';
import 'package:zoologic_df/proyects/home.dart';
import 'package:zoologic_df/proyects/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
var connect;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var port= prefs.getString('port')??null;
  var ip= prefs.getString('ip')??null;
  var idCliente= prefs.getString('idCliente')??null;
  var token= prefs.getString('token')??null;
  var cprivada=prefs.getString('cPrivada')??null;
  var user=prefs.getString('user')??null;
  var clave=prefs.getString('pass')??null;
  if (port!=null) {
    DF.port=port;
    DF.idCliente=idCliente;
    DF.ip=ip;
    DF.cPrivada=cprivada;
    DF.user=user;
    DF.pass=clave;
    connect= await DF().initApi('http://$ip:$port/api.Dragonfish/Autenticar',idCliente,token);
  } else {
    DF.connectStatus=false;
    connect=false;
  }
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
           title: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
           subhead: TextStyle(),
           subtitle: TextStyle(),
        ),
      ),
      home: ApiHomePage(apiconnection: connect),
      debugShowCheckedModeBanner: false,
    );
  }
}
