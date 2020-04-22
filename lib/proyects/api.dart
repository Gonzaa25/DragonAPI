import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DF{
  String apiurl;
  static bool connectStatus;
  static String ip='';
  static String port='';
  static String idCliente='';
  static String cPrivada='';
  static String user='';
  static String pass='';
  static String token='';

  Future<bool> initApi(String url,String idCliente,String token)async{
    
    Map<String, String> map = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };
     var jsoninfo ={
      "IdCliente": idCliente,
      "JWToken": token
    };
    try{
      var response = await http.post(
        url,headers: map,
        body: json.encode(jsoninfo)).timeout(Duration(seconds: 2)).catchError((e){
          print("error");
        });
      print(response.statusCode);
      if (response.statusCode==200) {
        print('connected to api');
        connectStatus=true;      
        return true;
      } else {
        print('error conecting to api');
        connectStatus=false;
        return false;
      }
    
    }on SocketException{
      print("error");
      return false;
    }
    
  }

  Future<void> saveApiSettings(String ipAPI,String portAPI,String idClienteAPI,String cPrivadaAPI,String userAPI,String passAPI,String tokenAPI)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('ip', ipAPI);
    prefs.setString('port', portAPI);
    prefs.setString('idCliente', idClienteAPI);
    prefs.setString('cPrivada', cPrivadaAPI);
    prefs.setString('user', userAPI);
    prefs.setString('pass', passAPI);
    prefs.setString('token', tokenAPI);
    ip=ipAPI;
    port=portAPI;
    idCliente=idClienteAPI;
    cPrivada=cPrivadaAPI;
    user=userAPI;
    pass=passAPI;
    token=tokenAPI;
  }
  
  String generateToken(String idClienteAPI,String cPrivadaApi,String userAPI,String passAPI){
      //password 
      var key = utf8.encode(cPrivadaApi);
      var bytes = utf8.encode(passAPI);
      var hmacSha256 = new Hmac(sha256,key); // HMAC-SHA256
      var digest = hmacSha256.convert(bytes);
      //password 
      var builder = new JWTBuilder();
      var password=digest.toString();
      var token = builder
        ..expiresAt=DateTime.now().add(Duration(hours: 8760))
        ..setClaim('usuario',userAPI)
        ..setClaim("password", password)
        ..getToken(); // returns token without signature
      var signer = new JWTHmacSha256Signer(cPrivadaApi);
      var signedToken = builder.getSignedToken(signer);
    return signedToken.toString();
  }

}