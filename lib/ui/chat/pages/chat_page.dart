import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:honk_clone/constants/constants.dart';
import 'package:honk_clone/ui/auth/models/user_model.dart';
import 'package:honk_clone/ui/chat/models/chat_model.dart';
import 'package:honk_clone/ui/chat/models/conversation_model.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatPage extends StatefulWidget {
  final Participant? participant;
  ChatPage(this.participant);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  TextEditingController _messageController = TextEditingController();
  Timer? typeTimer;

  static Box userData = Hive.box("userData");
  final User? user = userData.get("user");

  late Socket socket;
  Chat chatMessage = Chat(text: "");

  late Animation<int> topFlexAnimation;
  late Animation<int> bottomFlexAnimation;

  late AnimationController topFlexController;
  late AnimationController bottomFlexController;

  @override
  void initState() {
    super.initState();
    socket = io(kBaseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {'user': user!.id}
    });
    socket.connect();
    setupAnimations();
  }

  void setupAnimations() {
    topFlexController = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    topFlexAnimation = IntTween(begin: 50, end: 150).animate(
      CurvedAnimation(
        parent: topFlexController,
        curve: Curves.easeIn,
      ),
    );

    bottomFlexController = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    bottomFlexAnimation = IntTween(begin: 50, end: 150).animate(
      CurvedAnimation(
        parent: bottomFlexController,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    socket.disconnect();
    topFlexController.dispose();
    bottomFlexController.dispose();
    typeTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    socket.on(
      'msgToClient',
      (data) {
        final message = Chat.fromJson(data);
        if (message.text != "" && _messageController.text == "") {
          topFlexController.forward();
        }
        if (message.text != "" && _messageController.text != "") {
          topFlexController.reverse();
          bottomFlexController.reverse();
        }

        if (message.text == "") {
          topFlexController.reverse();
          bottomFlexController.reverse();
        }
        setState(() {
          chatMessage = message;
        });
      },
    );
  }

  _sendMessage(value) {
    if (value != "" && chatMessage.text == "") {
      bottomFlexController.forward();
    }

    if (value != "" && chatMessage.text != "") {
      topFlexController.reverse();
      bottomFlexController.reverse();
    }

    if (value == "") {
      const duration = Duration(seconds: 2);
      if (typeTimer != null) {
        setState(() => typeTimer!.cancel());
      }
      setState(
        () => typeTimer = new Timer(
          duration,
          () {
            topFlexController.reverse();
            bottomFlexController.reverse();
          },
        ),
      );
    }

    final receiver = widget.participant!.id;

    final data = Chat(
      receiver: receiver,
      text: value,
      sender: user!.id,
    );

    final messageToServer = data.toJson();
    socket.emit("msgToServer", messageToServer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Column(
          children: [
            Text(
              widget.participant!.name!,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 5),
            Text(
              "@${widget.participant!.username}",
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: CircleAvatar(
              child: Text(widget.participant!.name![0],
                  style: Theme.of(context).textTheme.caption),
              backgroundColor: Theme.of(context).cardColor,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            children: <Widget>[
              AnimatedBuilder(
                animation: topFlexAnimation,
                builder: (context, child) {
                  return Expanded(
                    flex: topFlexAnimation.value,
                    child: child!,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: Text(chatMessage.text!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline5),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              AnimatedBuilder(
                animation: bottomFlexAnimation,
                builder: (context, child) {
                  return Expanded(
                    flex: bottomFlexAnimation.value,
                    child: child!,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Center(
                          child: TextField(
                            textInputAction: TextInputAction.next,
                            controller: _messageController,
                            onChanged: (value) {
                              _sendMessage(value);
                            },
                            autofocus: true,
                            maxLines: null,
                            cursorColor: Colors.white,
                            style: TextStyle(
                              fontSize: 24,
                            ),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: "Type something",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -2,
                        right: -2,
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -12,
                        right: -12,
                        child: Container(
                          height: 7,
                          width: 7,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  height: 40,
                  color: Colors.grey[900],
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.grey[500],
                        ),
                        onPressed: () {
                          _messageController.text = "";
                          _sendMessage("");
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
