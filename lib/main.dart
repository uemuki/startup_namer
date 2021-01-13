import 'package:flutter/material.dart';

// Avoid errors caused by flutter upgrade.
import 'package:flutter/widgets.dart';
import './db/demo.dart';

// for socket
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:startup_namer/model/app_initializer.dart';
import 'package:startup_namer/model/dependency_injection.dart';
import 'package:startup_namer/model/socket_service.dart';

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

const String _name = "邈邈";

Injector injector;

void main() async {
  // dbDemo();

  DependencyInjection().initialise(Injector());
  injector = Injector();
  await AppInitializer().initialise(injector);

  final SocketService socketService = injector.get<SocketService>();
  print('before connection');
  socketService.createSocketConnection();
  print('getchat res1');
  Future.delayed(Duration(seconds: 5), () async {
    final res = await socketService.getChat('5f168e02305e6603e2bc125a');
    print('getchat res2: $res');
  });
  Future.delayed(Duration(seconds: 10), () => socketService.close());
  // final socketConnectRes = await socketService.createSocketConnection();
  // print('socketConnectRes: $socketConnectRes');
  // if (socketConnectRes) {
  //   socketService.getChat('5f168e02305e6603e2bc125a');
  // }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  ThemeData defaultTargetPlatform;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Friendlychat",
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  ChatScreenState createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 700),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  Widget _buildTextComposer(BuildContext context) {
    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new TextField(
            controller: _textController,
            onChanged: (String text) {
              setState(() {
                _isComposing = text.length > 0;
              });
            },
            onSubmitted: _handleSubmitted,
            decoration:
                new InputDecoration.collapsed(hintText: "Send a message"),
          ),
        ));
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Friendlychat"),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: Column(
        children: [
          new Flexible(
              child: new ListView.builder(
            padding: new EdgeInsets.all(8.0),
            reverse: true,
            itemBuilder: (_, int index) => _messages[index],
            itemCount: _messages.length,
          )),
          new Divider(height: 1.0),
          new Container(
              decoration: new BoxDecoration(color: Theme.of(context).cardColor),
              child: Row(
                children: [
                  Expanded(child: _buildTextComposer(context)),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onPressed: _isComposing
                              ? () => _handleSubmitted(_textController.text)
                              : null))
                ],
              ) //modified
              ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text = '', @required this.animationController});
  final String text;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    // if (animationController == null) {
    //   return Container(
    //     child: Text('data'),
    //   );
    // }
    return SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animationController, curve: Curves.easeOut),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: CircleAvatar(child: Text(_name[0]))),
              Flexible(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_name, style: Theme.of(context).textTheme.subhead),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  )
                ],
              ))
            ],
          )),
    );
  }
}
