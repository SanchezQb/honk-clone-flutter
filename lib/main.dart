import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:honk_clone/routes.dart';
import 'package:honk_clone/theme/app_theme.dart';
import 'package:honk_clone/ui/auth/models/user_model.dart';
import 'package:honk_clone/ui/auth/pages/startup_page.dart';
import 'package:honk_clone/ui/chat/pages/conversations_page.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<User>(UserAdapter());
  await Hive.openBox('userData');
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? user = Hive.box("userData").get("user");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Onk Demo',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: user == null ? StartupPage() : ConversationsPage(),
      onGenerateRoute: Routes.generateRoutes,
    );
  }
}
