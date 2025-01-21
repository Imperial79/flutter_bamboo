import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Resources/colors.dart';
import 'package:flutter_bamboo/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Helper/router_config.dart';
import 'Resources/commons.dart';
import 'Resources/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  await Hive.openBox('hiveBox');
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
      title: 'Bamboo Inc.',
      color: LColor.scaffold,
      theme: kTheme(context),
      themeMode: ThemeMode.light,
      routerConfig: routerConfig,
    );
  }
}
