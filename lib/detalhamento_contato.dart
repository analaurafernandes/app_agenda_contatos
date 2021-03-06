import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'utilitarios.dart';
import 'usuarios.dart';
import 'login.dart';
import 'cadastro.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Detalhamento extends StatefulWidget {
  final String id;
  Detalhamento({Key key, @required this.id}) : super(key: key);
  @override
  _Detalhamento createState() => _Detalhamento(id: id);
}

class _Detalhamento extends State<Detalhamento> {
  final String id;
  _Detalhamento({Key key, @required this.id});

  File _image;
  _recuperaCep(String CEP) async{
    String cep = CEP;
    String url = "https://viacep.com.br/ws/${cep}/json/";
    http.Response response;
    response = await http.get(Uri.parse(url));
    print("Resposta: " + response.body);
  }

  Future _getImage() async{
    print("ENTREI");
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('_image: $_image');
    });
  }

  @override
  Widget build(BuildContext context){
    var snapshots = FirebaseFirestore.instance.collection('contatos').where('nome', isEqualTo: id).snapshots();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.red[800]),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (result){
                if (result == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Users()),
                  );
                }
                else if(result == 1){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TelaCadastro()),
                  );
                }
                else if(result == 2){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TelaLogin()),
                  );
                }
              },
              itemBuilder: (BuildContext context){
                return [
                  PopupMenuItem(
                    child: Text('Usu??rios'),
                    value: 0,
                  ),
                  PopupMenuItem(
                    child: Text('Cadastro'),
                    value: 1,
                  ),
                  PopupMenuItem(
                    child: Text('Login'),
                    value: 2,
                  ),
                  //PopupMenuItem(child: Text('Android')),
                ];
              }
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: StreamBuilder(
        stream: snapshots,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if (snapshot.hasError){
            return Center(
                child: Text('Error: ${snapshot.error}')
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(
                child: CircularProgressIndicator()
            );
          }
          if (snapshot.data.docs.length == 0){
            return Center(
                child: Text('A agenda n??o possui contatos ainda.')
            );
          }
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5)
            ),
            margin: const EdgeInsets.fromLTRB(20, 80, 20, 100),
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: _getImage,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(50)
                          ),
                          height: MediaQuery.of(context).copyWith().size.height / 8,
                          width: MediaQuery.of(context).copyWith().size.height / 8,
                          //color: Colors.black12,
                          child: _image == null ? Icon(Icons.add) : Image.file(_image)
                      ),
                      ),
                      Expanded(
                        child: SizedBox(
                        height: 260.0,
                        child:ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder:(BuildContext context, int i){
                          var doc = snapshot.data.docs[i];
                          var item = Map.of(doc.data());
                          print(item['nome']);
                          return ListTile(
                              title: Text(item['nome']),
                              subtitle: Text("Telefone: ${item['telefone']}\n E-mail: ${item['email']} \n ${item['endereco']} \n CEP: ${item['cep']}"),
                            );
                          }
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );




          /*ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder:(BuildContext context, int i){
                var doc = snapshot.data.docs[i];
                var item = Map.of(doc.data());
                print(item['nome']);
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child:
                      ListTile(
                        leading: CircleAvatar(

                        ),
                        title: Text(item['nome']),
                          subtitle: Text("Telefone: ${item['telefone']}\n E-mail: ${item['email']} \n ${item['endereco']} \n CEP: ${item['cep']}"),
                          /*trailing: IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red[300],
                          onPressed: () => doc.reference.update({'status': 'excluido'}),
                        )*/
                      ),
                );
              }
          );*/
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => modalCreateCalendar(context, 'add', null),
        tooltip: 'Adicionar novo',
        child: Icon(Icons.event_available),
        backgroundColor: Colors.red[800],
      ),
    );
  }
}