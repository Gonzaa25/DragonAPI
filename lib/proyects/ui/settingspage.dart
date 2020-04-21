import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:zoologic_df/proyects/api.dart';
import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  TextEditingController ip = TextEditingController(text: DF.ip);
  TextEditingController port = TextEditingController(text: DF.port);
  TextEditingController idCliente = TextEditingController(text: DF.idCliente);
  TextEditingController cPrivada = TextEditingController(text: DF.cPrivada);
  TextEditingController user = TextEditingController(text: DF.user);
  TextEditingController pass = TextEditingController(text: DF.pass);
  GlobalKey<ScaffoldState> scaffolkey=GlobalKey();
  var connect;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffolkey,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Ajustes"),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: ip,
              decoration: InputDecoration(
                labelText: "IP",
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: port,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "PUERTO",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: idCliente,
              decoration: InputDecoration(
                labelText: "IDCLIENTE",
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: cPrivada,
              decoration: InputDecoration(
                labelText: "CLAVE PRIVADA",
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: user,
              decoration: InputDecoration(
                labelText: "USUARIO",
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: pass,
              decoration: InputDecoration(
                labelText: "CONTRASEÑA",
                border: OutlineInputBorder()
              ),
            ),
          ],
        ),
      ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async{
            var portv= port.value.text;
            var ipv = ip.value.text;
            //password 
            var key = utf8.encode(cPrivada.value.text);
            var bytes = utf8.encode(pass.value.text);
            var hmacSha256 = new Hmac(sha256,key); // HMAC-SHA256
            var digest = hmacSha256.convert(bytes);
            //password 
            var builder = new JWTBuilder();
            var password=digest.toString();
            var token = builder
              ..expiresAt=DateTime.now().add(Duration(hours: 8760))
              ..setClaim('usuario',user.value.text)
              ..setClaim("password", password)
              ..getToken(); // returns token without signature
            var signer = new JWTHmacSha256Signer(cPrivada.value.text);
            var signedToken = builder.getSignedToken(signer);
            
            try{
               connect= await DF().initApi('http://$ipv:$portv/api.Dragonfish/Autenticar',idCliente.value.text,signedToken.toString());
            }catch(e){
              connect=false;
            }
            print("conexion status: "+connect.toString());
            if (connect) {
              await DF().saveApiSettings(ip.value.text,port.value.text,idCliente.value.text,cPrivada.value.text,user.value.text,pass.value.text,signedToken.toString());
              DF.connectStatus=true;
              scaffolkey.currentState.showSnackBar(SnackBar(content: Text('Conexión establecida con éxito'),backgroundColor: Colors.green));
            } else {
              DF.connectStatus=false;
              scaffolkey.currentState.showSnackBar(SnackBar(content: Text('Error de conexión'),backgroundColor: Colors.red));
            }
          }, child: Icon(Icons.save, color: Colors.white)),
    );
  }
}