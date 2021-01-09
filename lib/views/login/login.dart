import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup_namer/view_model/user_view_model.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            Expanded(
                child: TextFormField(
              style: TextStyle(color: Colors.blueGrey),
              controller: _controller,
            )),
            IconButton(
                icon: Icon(Icons.backup),
                onPressed: () {
                  Provider.of<UserViewModel>(context, listen: false)
                      .login(_controller.value.text)
                      .then((value) {
                    if (value) {
                      Navigator.of(context).pop(true);
                    }
                  });
                })
          ],
        ),
      ),
    );
  }
}
