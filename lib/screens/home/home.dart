import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  final _toBuyNameController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  List _toBuyList = [];

  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

  @override
  void initState() {
    super.initState();

    _readData().then((data) {
      setState(() {
        _toBuyList = json.decode(data);
      });
    });
  }

  void _addToBuy(context) {
    setState(() {
      Map<String, dynamic> newToBuy = Map();
      newToBuy["id"] = DateTime.now().millisecondsSinceEpoch.toString();
      _auth.inputData().then((value) => newToBuy["uid"] = value);
      newToBuy["name"] = _toBuyNameController.text;
      newToBuy["date"] = selectedDate.millisecondsSinceEpoch.toString();
      _toBuyNameController.text = "";
      selectedDate = DateTime.now();
      _toBuyList.add(newToBuy);

      _saveData();
      Navigator.of(context).pop(Home());
    });
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _toBuyList.sort((a, b) {
        if (double.parse(a["date"].millisecondsSinceEpoch.toString()) >
            double.parse(b["date"].millisecondsSinceEpoch.toString()))
          return 1;
        else
          return -1;
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
                                controller: _toBuyNameController,
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
                                  onPressed: () => _selectDate(context),
                                  child: Icon(Icons.calendar_today),
                                ),
                              ),
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
                                    _addToBuy(context);
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
                  itemCount: _toBuyList.length,
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
          leading: Icon(Icons.shopping_cart),
          subtitle: Text(_toBuyList[index]["date"] != null
              ? DateFormat('dd/MM/yyyy')
                  .format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(_toBuyList[index]["date"])))
                  .toString()
              : ''),
          title: Text(_toBuyList[index]["name"] != null
              ? _toBuyList[index]["name"]
              : ''),
          trailing: Icon(Icons.more_vert),
          isThreeLine: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Shopping(),
                settings: RouteSettings(
                  arguments: buy.id,
                ),
              ),
            );
          },
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = Map.from(_toBuyList[index]);
          _lastRemovedPos = index;
          _toBuyList.removeAt(index);

          _saveData();

          final snack = SnackBar(
            content: Text("Compra \"${_lastRemoved["name"]}\" removida!"),
            action: SnackBarAction(
                label: "Desfazer",
                onPressed: () {
                  setState(() {
                    _toBuyList.insert(_lastRemovedPos, _lastRemoved);
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
    String data = json.encode(_toBuyList);

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
