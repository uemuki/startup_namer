import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';

class SocketService {
  IO.Socket socket;
  final String socketUrl = 'https://sugar.youkeda.com/browser';
  // final String socketUrl = 'https://sugar.youkeda.com/browser';

  // Future<bool>
  createSocketConnection() {
    // Completer complete = new Completer();
    socket = IO.io(socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': {'Access-Control-Allow-Origin': '*'}
    });

    this.socket.on("connect", (_) {
      print('Connected');
      this.socket.emit(
          "IM/USEID",
          // userId
          "5dc5658eafee274fd9590505");
      this.socket.on("IM/MSG/SEND/RECEIVE", (dynamic message) {
        print('[message] $message');
        receive(message);
      });
      // print('[connect] finish');
    });
    this.socket.on("disconnect", (_) => print('Disconnected'));
    this.socket.on("connect_timeout", (_) => print('ConnectTimeout 连接超时'));
  }

  close() {
    this.socket.close();
  }

  Future<dynamic> getChat(String aimUserId) {
    Completer complete = new Completer();
    print("[in getChat]");
    this.socket.emitWithAck("IM/CHAT/GET", [aimUserId],
        ack: (dynamic chatMember) {
      print("[in getChat] emitWithAck");
      Map chat = {
        ...chatMember.chat,
        "id": chatMember.chatId,
        "chatMembers": chatMember.chatMembers
      };
      complete.complete(chat);
    });
    return complete.future;
  }

  Future<dynamic> send(dynamic message) {
    Completer complete = new Completer();
    print("[in send]");
    this.socket.emitWithAck("IM/MSG/SEND", message, ack: (dynamic messsage) {
      print("[in send] emitWithAck");
      complete.complete(messsage);
    });
    return complete.future;
  }

  Future<dynamic> query(dynamic param) {
    Completer complete = new Completer();
    print("[in send]");
    this.socket.emitWithAck("IM/MSG/DELTA", param,
        ack: (List<dynamic> messages) {
      messages.sort((a, b) => a.seq - b.seq);
      complete.complete(messages);
    });
    return complete.future;
  }

  Future<dynamic> read(dynamic message) {
    Completer complete = new Completer();
    print("[in send]");
    // this.socket.emit("IM/MSG/READ", messageIds, chatId);
    return complete.future;
  }
}

/// 接受到message后
receive(dynamic message) {
  print(message.toString());
}
