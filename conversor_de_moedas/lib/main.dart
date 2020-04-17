import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart'
as http;


const request = "https://api.hgbrasil.com/finance?format=json-cors&key=08ba6a76";

void main() async {

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.white,
      primaryColor: Colors.amber,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        hintStyle: TextStyle(color: Colors.amber)
      )
    ),
  ));
}

Future < Map > getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);

}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State < Home > {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

void _clearAll(){
  realController.text="";
  dolarController.text="";
  euroController.text="";
}
void _realChanged(String text){
  if(text.isEmpty){
    _clearAll();
    return;
  }
  double real = double.parse(text);
  dolarController.text = (real/dolar).toStringAsFixed(3);
  euroController.text = (real/euro).toStringAsFixed(3);
}

void _dolarChanged(String text){
  if(text.isEmpty){
    _clearAll();
    return;
  }
  double dolar = double.parse(text);
  realController.text = (dolar *this.dolar).toStringAsFixed(3);
  euroController.text = (dolar *this.dolar/euro).toStringAsFixed(3);
}

void _euroChanged(String text){
  if(text.isEmpty){
    _clearAll();
    return;
  }
  double euro = double.parse(text);
  realController.text = (euro *this.euro).toStringAsFixed(3);
  dolarController.text = (euro *this.euro/dolar).toStringAsFixed(3);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversor de Moedas"),
        centerTitle: true,
        backgroundColor: Colors.amber,
        actions: < Widget > [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _clearAll();
            }
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder < Map > (
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando Dados...",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25.0
                  ),
                  textAlign: TextAlign.center,
                )
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text("Erro ao carregar Dados :(",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25.0
                    ),
                    textAlign: TextAlign.center,
                  )
                );
              } else {
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: < Widget > [
                      Icon(Icons.monetization_on,
                        size: 150.0,
                        color: Colors.amber),
                      buildTextFormField("Real", "R\$",realController, _realChanged),
                      Divider(),
                      buildTextFormField("Dólar", "US\$",dolarController, _dolarChanged),
                      Divider(),
                      buildTextFormField("Euro", "€",euroController, _euroChanged)
                      
                    ],
                  ),
                );
              }
          }
        }
      )
    );
  }
}


Widget buildTextFormField(String label, String prefix, TextEditingController c, Function f) {
  return TextFormField(keyboardType: TextInputType.numberWithOptions(decimal:true),
    controller: c,

    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
      labelStyle: TextStyle(color: Colors.amber),
      prefixText: prefix,
    ),
    style: TextStyle(
      color: Colors.amber,
      fontSize: 25.0
    ),
    onChanged: f,
  );
}