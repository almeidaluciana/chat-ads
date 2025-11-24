import 'package:flutter/material.dart';
import 'views/login_page.dart';
import 'views/chat_page.dart';
import 'views/register_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/login': (context) => const LoginPage(),
    '/chat': (context) => const ChatPage(),
    '/register': (context) => const RegisterPage(),
  };
}
