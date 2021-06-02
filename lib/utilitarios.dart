import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;



botaoGenerico(texto, BuildContext context, rota){
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
          minimumSize: Size(150, 5),
          primary: Colors.red[800],
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          textStyle: TextStyle(
              fontSize: 18,
              color: Colors.black54
          )),
      child: Text(texto),
      onPressed: (){
        Navigator.pushNamed(context, rota);
      }
  );
}

modalCreate(BuildContext context, String op, QueryDocumentSnapshot<Object> doc){
  var form = GlobalKey<FormState>();

  var nome = TextEditingController();
  var email = TextEditingController();
  var telefone = TextEditingController();
  var endereco = TextEditingController();
  var cep = TextEditingController();

  return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Novo Contato'),
          content: Form(
            key: form,
            child: Container(
              height: MediaQuery.of(context).size.height/2,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: nome,
                    decoration: InputDecoration(
                      hintText: 'Nome',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red[800]
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
                    controller: telefone,
                    decoration: InputDecoration(
                      hintText: 'Telefone',
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red[800]
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
                    controller: email,
                    decoration: InputDecoration(
                      hintText: 'E-mail',
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red[800]
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
                    controller: endereco,
                    decoration: InputDecoration(
                      hintText: 'Endereço',
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red[800]
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
                    controller: cep,
                    decoration: InputDecoration(
                      hintText: 'CEP',
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red[800]
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
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  primary: Colors.red[800],
                ),
                child: Text('Cancelar')
            ),
            TextButton(
                onPressed: () async{
                  if(op == 'edit'){
                    if(form.currentState.validate())
                      doc.reference.update({
                        'cep': cep.text,
                        'nome': nome.text,
                        'email': email.text,
                        'endereco': endereco.text,
                        'telefone': telefone.text,
                        'status': 'ativo'
                      });
                  }
                  else{
                    if(form.currentState.validate()) {
                      await FirebaseFirestore.instance.collection('contatos')
                          .add({
                        'cep': cep.text,
                        'nome': nome.text,
                        'email': email.text,
                        'endereco': endereco.text,
                        'telefone': telefone.text,
                        'status': 'ativo'
                      });
                    }
                  }
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  primary: Colors.red[800],
                ),
                child: Text('Salvar')
            )
          ],
        );
      }
  );
}

createUser(BuildContext context, String op, QueryDocumentSnapshot<Object> doc){
  var form = GlobalKey<FormState>();

  var email = TextEditingController();
  var login = TextEditingController();
  var senha = TextEditingController();

  return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Novo Usuário'),
          content: Form(
            key: form,
            child: Container(
              height: MediaQuery.of(context).size.height/3,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email, color: Colors.red[800], size: 22),
                      hintText: 'E-mail',
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red[800]
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
                  TextFormField(
                    controller: login,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person, color: Colors.red[800], size: 22),
                      hintText: 'Login',
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red[800]
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
                      prefixIcon: Icon(Icons.lock, color: Colors.red[800], size: 22),
                      hintText: 'Senha',
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red[800]
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

                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  primary: Colors.red[800],
                ),
                child: Text('Cancelar')
            ),
            TextButton(
                onPressed: () async{
                  if(op == 'edit'){
                    if(form.currentState.validate())
                      doc.reference.update({
                        'email': email.text,
                        'login': login.text,
                        'senha': senha.text,
                        'status': 'ativo'
                      });
                  }
                  else {
                    if (form.currentState.validate()) {
                      await FirebaseFirestore.instance.collection('usuarios')
                          .add({
                        'email': email.text,
                        'login': login.text,
                        'senha': senha.text,
                        'status': 'ativo'
                      });
                    }
                  }
                  UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: senha.text);
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  primary: Colors.red[800],
                ),
                child: Text('Criar')
            )
          ],
        );
      }
  );
}
