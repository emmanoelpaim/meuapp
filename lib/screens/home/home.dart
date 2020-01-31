import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meuapp/models/user.dart';
import 'package:meuapp/models/buy.dart';
import 'package:meuapp/services/auth.dart';
import 'package:path_provider/path_provider.dart';
import '../shopping/shopping.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  final _toDoController = TextEditingController();

  List _toDoList = [];

  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

  @override
  void initState() {
    super.initState();

    _readData().then((data) {
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  void _addToDo(context) {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _toDoController.text;
      _toDoController.text = "";
      _toDoList.add(newToDo);

      _saveData();
      Navigator.of(context).pop(Home());
    });
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _toDoList.sort((a, b) {
        if (a["title"] && !b["title"])
          return 1;
        else if (!a["title"] && b["title"])
          return -1;
        else
          return 0;
      });

      _saveData();
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
              context: context,
              builder: (ctxt) => new AlertDialog(
                    title: Text("Cirar Compra"),
                    content: Container(
                      padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: TextField(
                                controller: _toDoController,
                                decoration: InputDecoration(
                                    labelText: "Nova Compra",
                                    labelStyle:
                                        TextStyle(color: Colors.blueAccent)),
                              )),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: RaisedButton(
                                  color: Colors.blueAccent,
                                  child: Text("Salvar"),
                                  textColor: Colors.white,
                                  onPressed: () {
                                    _addToDo(context);
                                  },
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ));
        },
        label: Text('Add'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
      appBar: AppBar(
        title: Text('Lista de Compras'),
        backgroundColor: Colors.indigo[400],
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.close),
            label: Text(''),
            onPressed: () async {
              await _auth.signOut();
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 10.0),
                  itemCount: _toDoList.length,
                  itemBuilder: buildItem),
            ),
          )
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, int index) {
    Buy buy = Buy();

    _auth.inputData().then((value) {
      buy.uid = value;
    });

    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: Card(
        child: ListTile(
          title: Text(_toDoList[index]["title"]),
          trailing: Icon(Icons.more_vert),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Shopping(),settings: RouteSettings(
                arguments: buy.toString(),
              ), ),
            );
          },
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = Map.from(_toDoList[index]);
          _lastRemovedPos = index;
          _toDoList.removeAt(index);

          _saveData();

          final snack = SnackBar(
            content: Text("Tarefa \"${_lastRemoved["title"]}\" removida!"),
            action: SnackBarAction(
                label: "Desfazer",
                onPressed: () {
                  setState(() {
                    _toDoList.insert(_lastRemovedPos, _lastRemoved);
                    _saveData();
                  });
                }),
            duration: Duration(seconds: 2),
          );

          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snack);
        });
      },
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);

    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();

      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
