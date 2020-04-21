import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zoologic_df/proyects/api.dart';
import 'struct/struct.dart';
import 'package:zoologic_df/proyects/ui/settingspage.dart';

class ApiHomePage extends StatefulWidget {
  final bool apiconnection;
  ApiHomePage({this.apiconnection});
  @override
  State<StatefulWidget> createState() => ApiHomePageState();
}

class ApiHomePageState extends State<ApiHomePage> {
  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

  final white = SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.dark);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: white,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue,
          elevation: 0,
          title: Text("API",style: Theme.of(context).textTheme.title),
        ),
        drawer: Drawer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 80,
                color: Colors.blue,
              ),
              ListTile(
                title: Text("Ajustes"),
                leading: Icon(Icons.settings),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsPage()));
                },
              )
            ],
          ),
        ),
        body: Container(
          child: Center(
            child: Text('connected to api: '+DF.connectStatus.toString()),
          ),
        ),
      ),
    );
  }
}


