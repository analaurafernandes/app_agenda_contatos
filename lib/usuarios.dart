import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'utilitarios.dart';
import 'login.dart';
import 'cadastro.dart';
import 'home_page.dart';

class Users extends StatefulWidget {
  @override
  _Users createState() => _Users();
}

class _Users extends State<Users> {
  var busca = '';
  var campo = '';
  var conteudo = null;
  @override
  Widget build(BuildContext context){
    GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    var buscado = TextEditingController();

    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: TextField(
          controller: buscado,
          decoration: InputDecoration(
            prefixIcon: IconButton(
              icon: Icon(Icons.remove_circle_outline, color: Colors.orangeAccent[200], size: 18),
              onPressed: () {
                setState((){
                  conteudo = null;
                  busca = '';
                  campo = '';
                  print(busca + ' ' + campo);
                });
              },
            ),
            hintText: "Busque pelo nome de login...",
            hintStyle: TextStyle(color: Colors.orangeAccent[200])
          ),
          onChanged: (text){
                busca = text;
                if(busca.length == 20)
                  campo = 'uid';
                else
                  campo = 'login';
          }
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.orangeAccent[200]),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState((){
                conteudo = _fireSearch(busca, campo);
                print(busca + ' ' + campo);
              });
            },
          ),
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
      body: conteudo == null ? _fireSearch('', '') : conteudo,
    );
  }

  Widget _fireSearch(String queryText, String campo) {
    if(queryText == ''){
      queryText = 'ativo';
      campo = 'status';
    }
    return new StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('usuarios')
          .where(campo, isEqualTo: queryText)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) =>
            _buildListItem(Map.of(snapshot.data.docs[index].data()), snapshot.data.docs[index])

        );
      },
    );
  }

  Widget _buildListItem(Map document, var doc) {
    print(document);
    print(doc);
    return ListTile(
          leading: IconButton(
            icon: Icon(Icons.edit_outlined),
            onPressed: () => createUser(context, 'edit', doc),
          ),
          title: Text(document['login']),
          subtitle: Text(document['email']),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            color: Colors.red[300],
            onPressed: (){
              doc.reference.update({'status': 'excluido'});
              Navigator.of(context).pop();
            },
          ),
        );
  }
}








    /*StreamBuilder(
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
                child: Text('Ainda não existem usuários cadastrados no aplicativo.')
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
                      leading: IconButton(
                        icon: Icon(Icons.edit_outlined),
                        onPressed: () => createUser(context, 'edit', doc),
                      ),
                      title: Text(item['login']),
                      subtitle: Text(item['email']),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.red[300],
                        onPressed: () => doc.reference.update({'status': 'excluido'}),
                      )
                  ),
                );
              }
          );
        },
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () => modalCreate(context, 'add', null),
        tooltip: 'Adicionar novo',
        child: Icon(Icons.add),
      ),*/
    );*/
