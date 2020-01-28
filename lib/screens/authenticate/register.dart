import 'package:flutter/material.dart';
import 'package:meuapp/services/auth.dart';
import 'package:meuapp/shared/constants.dart';
import 'package:meuapp/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String name = '';
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.indigo[100],
            appBar: AppBar(
              backgroundColor: Colors.indigo[400],
              elevation: 0.0,
              title: Text('Meu App Registro'),
              actions: <Widget>[
                FlatButton.icon(
                  onPressed: () {
                    widget.toggleView();
                  },
                  icon: Icon(Icons.person),
                  label: Text('Entrar'),
                )
              ],
            ),
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 15.0),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Name'),
                              validator: (val) =>
                                  val.isEmpty ? 'Enter a name' : null,
                              onChanged: (val) {
                                setState(() => name = val);
                              },
                            ),
                            SizedBox(height: 15.0),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Email'),
                              validator: (val) =>
                                  val.isEmpty ? 'Enter an email' : null,
                              onChanged: (val) {
                                setState(() => email = val);
                              },
                            ),
                            SizedBox(height: 15.0),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Password'),
                              validator: (val) => val.length < 6
                                  ? 'Enter a password 6+ chars long'
                                  : null,
                              obscureText: true,
                              onChanged: (val) {
                                setState(() => password = val);
                              },
                            ),
                            SizedBox(height: 15.0),
                            RaisedButton(
                              color: Colors.pink[400],
                              child: Text(
                                'Registro',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                setState(() => loading = true);
                                if (_formKey.currentState.validate()) {
                                  dynamic result =
                                      await _auth.registerWithEmailAndPassword(
                                          email, password, name);

                                  if (result == null) {
                                    setState(() {
                                      error = 'please supply a valid email';
                                      loading = false;
                                    });
                                  }
                                }
                              },
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              error,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
