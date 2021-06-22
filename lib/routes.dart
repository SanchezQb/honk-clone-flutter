import 'package:flutter/material.dart';
import 'package:honk_clone/ui/auth/pages/sign_in_page.dart';
import 'package:honk_clone/ui/auth/pages/sign_up_page.dart';
import 'package:honk_clone/ui/chat/models/conversation_model.dart';
import 'package:honk_clone/ui/chat/pages/chat_page.dart';
import 'package:honk_clone/ui/chat/pages/conversations_page.dart';
import 'package:honk_clone/ui/search/pages/search_page.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/sign_in_page':
        return MaterialPageRoute<bool>(
          builder: (BuildContext context) => SignInPage(),
        );
      case '/sign_up_page':
        return MaterialPageRoute<bool>(
          builder: (BuildContext context) => SignUpPage(),
        );
      case '/conversations_page':
        return MaterialPageRoute<bool>(
          builder: (BuildContext context) => ConversationsPage(),
        );
      case '/chat_page':
        final Participant? participant = settings.arguments as Participant?;
        return MaterialPageRoute<bool>(
          builder: (BuildContext context) => ChatPage(participant),
        );
      case '/search_page':
        return MaterialPageRoute<bool>(
          builder: (BuildContext context) => SearchPage(),
        );
      default:
        return MaterialPageRoute<bool>(
          builder: (BuildContext context) => Scaffold(
            body: Center(child: Text("Can't find this page")),
          ),
        );
    }
  }
}
