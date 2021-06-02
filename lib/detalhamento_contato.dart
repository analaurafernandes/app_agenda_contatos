import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'utilitarios.dart';
import 'usuarios.dart';
import 'login.dart';
import 'cadastro.dart';
import 'package:http/http.dart' as http;

class Detalhamento extends StatefulWidget {
  final String id;
  Detalhamento({Key key, @required this.id}) : super(key: key);
  @override
  _Detalhamento createState() => _Detalhamento(id: id);
}

class _Detalhamento extends State<Detalhamento> {
  final String id;
  _Detalhamento({Key key, @required this.id});

  _recuperaCep(String CEP) async{
    String cep = CEP;
    String url = "https://viacep.com.br/ws/${cep}/json/";
    http.Response response;
    response = await http.get(Uri.parse(url));
    print("Resposta: " + response.body);
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
                    child: Text('Usuários'),
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
                child: Text('A agenda não possui contatos ainda.')
            );
          }
          return ListView.builder(
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
                  child: ListTile(
                      /*leading: IconButton(
                        icon: Icon(Icons.edit_outlined),
                        onPressed: () => modalCreate(context, 'edit', doc),
                      ),*/
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => modalCreateCalendar(context, 'add', null),
        tooltip: 'Adicionar novo',
        child: Icon(Icons.event_available),
      ),
    );
  }
}