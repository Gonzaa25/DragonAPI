import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    pass=tokenAPI;
  }
  
}