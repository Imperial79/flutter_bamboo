import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Helper/router_config.dart';
import 'Resources/commons.dart';
import 'Resources/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    systemColors();

    final routerConfig = ref.watch(goRouterProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Postr',
      theme: kTheme(context),
      themeMode: ThemeMode.dark,
      routerConfig: routerConfig,
    );
  }
}
