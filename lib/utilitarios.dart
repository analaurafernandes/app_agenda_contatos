import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

botaoGenerico(texto, BuildContext context, rota){
  return ElevatedButton(
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
      child: Text(texto),
      onPressed: (){
        Navigator.pushNamed(context, rota);
      }
  );
}

modalCreate(BuildContext context){
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
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: nome,
                  decoration: InputDecoration(
                    hintText: 'Nome',
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
                  controller: telefone,
                  decoration: InputDecoration(
                    hintText: 'Telefone',
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
                  controller: email,
                  decoration: InputDecoration(
                    hintText: 'E-mail',
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
                  controller: endereco,
                  decoration: InputDecoration(
                    hintText: 'Endereço',
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
                  controller: cep,
                  decoration: InputDecoration(
                    hintText: 'CEP',
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
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  primary: Colors.orangeAccent[200],
                ),
                child: Text('Cancelar')
            ),
            TextButton(
                onPressed: (){
                  if(form.currentState.validate()){
                    FirebaseFirestore.instance.collection('contatos').add({
                      'cep':      cep.text,
                      'nome':     nome.text,
                      'email':    email.text,
                      'endereco': endereco.text,
                      'telefone': telefone.text,
                      'status':   'ativo'
                    });
                  }
                },
                style: TextButton.styleFrom(
                  primary: Colors.orangeAccent[200],
                ),
                child: Text('Salvar')
            )
          ],
        );
      }
  );
}