import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:honk_clone/ui/auth/models/user_model.dart';
import 'package:honk_clone/ui/auth/providers/auth_state.dart';
import 'package:honk_clone/ui/auth/providers/auth_state_notifier.dart';
import 'package:honk_clone/ui/chat/models/conversation_model.dart';
import 'package:honk_clone/ui/chat/providers/chat_state.dart';
import 'package:honk_clone/ui/chat/providers/conversations_state_notifier.dart';

class ConversationsPage extends StatefulWidget {
  @override
  _ConversationsPageState createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  static final Box userData = Hive.box('userData');
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then((_) =>
        context.read(conversationsStateNotifier.notifier).getConversations());
  }

  @override
  Widget build(BuildContext context) {
    final User user = userData.get("user");
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: CircleAvatar(
            child:
                Text(user.name![0], style: Theme.of(context).textTheme.caption),
            backgroundColor: Theme.of(context).cardColor,
          ),
        ),
        elevation: 0,
        title: Text(
          "Friends",
          style: Theme.of(context).textTheme.headline5!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).pushNamed("/search_page");
            },
          ),
          ProviderListener(
            provider: authNotifierProvider,
            onChange: (context, dynamic state) {
              if (state is AuthInitialState) {
                Navigator.of(context).pushReplacementNamed("/sign_in_page");
              }
            },
            child: IconButton(
              icon: Icon(Icons.logout, color: Colors.red),
              onPressed: () {
                context.read(authNotifierProvider.notifier).logOut();
              },
            ),
          ),
        ],
      ),
      body: ProviderListener(
        provider: conversationsStateNotifier,
        onChange: (context, dynamic state) {
          if (state is ConversationsErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  state.message!,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            );
          }
        },
        child: Consumer(builder: (context, watch, child) {
          final state = watch(conversationsStateNotifier);
          if (state is ConversationsLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ConversationsErrorState) {
            return Center(
              child: Text(state.message!),
            );
          }
          if (state is ConversationsLoadedState) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: state.conversations.length,
                itemBuilder: (BuildContext context, int index) {
                  final Conversation conversation = state.conversations[index];
                  final Participant participant = conversation.participants!
                      .firstWhere((data) => data.username != user.username);
                  return ListTile(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed("/chat_page", arguments: participant);
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      child: Text(participant.name![0]),
                      backgroundColor: Theme.of(context).cardColor,
                      radius: 30,
                    ),
                    title: Text(
                      participant.name!,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  );
                },
              ),
            );
          }
          return Container();
        }),
      ),
    );
  }
}
