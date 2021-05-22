import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'utilitarios.dart';
//import 'package:sqflite/sqflite.dart';

class TelaLogin extends StatefulWidget {
  @override
  _TelaLogin createState() => _TelaLogin();
}

class _TelaLogin extends State<TelaLogin> {
  @override
  Widget build(BuildContext context) {
    var form = GlobalKey<FormState>();

    var email = TextEditingController();
    var senha = TextEditingController();

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.orangeAccent[200]),
          actions: <Widget>[
            PopupMenuButton(itemBuilder: (BuildContext context){
              return[
                PopupMenuItem(child: Text('Flutter')),
                PopupMenuItem(child: Text('Android')),
              ];
            })
          ],
        ),
        body: new Stack(
            children: <Widget>[
              new Container(
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                          image: AssetImage('assets/images/background_inicial.png'),
                          fit: BoxFit.cover))
              ),
              new Center(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(64, 0, 64, 0),
                      child: Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Form(
                                  key: form,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height/3,
                                    child: Column(
                                      children: <Widget>[
                                        TextFormField(
                                          controller: email,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.email, color: Colors.orangeAccent[200], size: 22),
                                            hintText: 'Login',
                                            border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.orangeAccent[200]
                                                )
                                            ),
                                          ),
                                          validator: (value){
                                            if(value.isEmpty){
                                              return 'Campo de preenchimento obrigatório';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 10),
                                        TextFormField(
                                          controller: senha,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.lock, color: Colors.orangeAccent[200], size: 22),
                                            hintText: 'Senha',
                                            border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.orangeAccent[200]
                                                )
                                            ),
                                          ),
                                          obscureText: true,
                                          validator: (value){
                                            if(value.isEmpty){
                                              return 'Campo de preenchimento obrigatório';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: new RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(30.0),
                                        ),
                                        minimumSize: Size(150, 5),
                                        primary: Colors.orangeAccent[200],
                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black54
                                        )),
                                    child: Text('Entrar'),
                                    onPressed: () async{
                                      if(form.currentState.validate()) {
                                        try {
                                          UserCredential user = await FirebaseAuth
                                              .instance
                                              .signInWithEmailAndPassword(
                                              email: email.text,
                                              password: senha.text);
                                          print(user);
                                        }
                                        catch(e){
                                          print('Foi encontrado um erro: $e');
                                        }
                                      }
                                      Navigator.pushNamed(context, '/login');
                                    }
                                ),

                              ]
                          )
                      )
                  )
              )
            ]
        )
    );
  }
}