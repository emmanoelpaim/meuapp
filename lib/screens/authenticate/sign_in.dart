import 'package:flutter/material.dart';
import 'package:meuapp/services/auth.dart';
import 'package:meuapp/shared/constants.dart';
import 'package:meuapp/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
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
              title: Text('Meu App Login'),
              actions: <Widget>[
                FlatButton.icon(
                  onPressed: () {
                    widget.toggleView();
                  },
                  icon: Icon(Icons.person_add),
                  label: Text('Registro'),
                )
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 0.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration:
                                textInputDecoration.copyWith(hintText: 'Email'),
                            validator: (val) =>
                                val.isEmpty ? 'Digite um e-mail' : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                          ),
                          Divider(),
                          TextFormField(
                            decoration:
                                textInputDecoration.copyWith(hintText: 'Senha'),
                            validator: (val) => val.length < 6
                                ? 'Entre com uma senha com mais de 6 caractéres'
                                : null,
                            obscureText: true,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                          ),
                          Divider(),
                          RaisedButton(
                            color: Colors.pink[400],
                            child: Text(
                              'Entrar',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() => loading = true);
                                dynamic result =
                                    await _auth.signInWithEmailAndPassword(
                                        email, password);
                                if (result == null) {
                                  setState(() {
                                    error = 'Usuário ou senha inválidos';
                                    loading = false;
                                  });
                                }
                              }
                            },
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
                  ]),
            ),
          );
  }
}
