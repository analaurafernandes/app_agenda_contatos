import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'utilitarios.dart';
import 'package:firebase_core/firebase_core.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  @override
  Widget build(BuildContext context){
    var snapshots = FirebaseFirestore.instance.collection('contatos').where('status', isEqualTo: 'ativo').orderBy('nome').snapshots();

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
                var item = Map.of(snapshot.data.docs[i].data());

                print(item['nome']);
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.radio_button_unchecked_outlined),
                      onPressed: () => null,
                    ),
                    title: Text(item['nome']),
                    subtitle: Text(item['telefone'] + '\n' + item['email']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.red[300],
                      onPressed: () => null,
                    )
                  ),
                );
              }
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => modalCreate(context),
          tooltip: 'Adicionar novo',
          child: Icon(Icons.add),
        ),
    );
  }
}