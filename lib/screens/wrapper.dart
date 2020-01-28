import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meuapp/models/user.dart';
import 'package:meuapp/screens/authenticate/authenticate.dart';

import 'home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // return either Home or Authenticate widget
    if (user == null) {
      return Home();
    } else {
      return Home();
    }
  }
}
