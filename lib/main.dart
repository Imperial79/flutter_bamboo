import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Resources/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Helper/router_config.dart';
import 'Resources/commons.dart';
import 'Resources/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await FirebaseMessaging.instance.setAutoInitEnabled(true);
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
