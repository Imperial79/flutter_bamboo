import 'package:flutter/material.dart';
import 'package:ngf_organic/Components/Label.dart';
import 'package:ngf_organic/Components/kWidgets.dart';
import 'package:ngf_organic/Repository/auth_repo.dart';
import 'package:ngf_organic/Resources/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Server_Error_UI extends ConsumerStatefulWidget {
  const Server_Error_UI({super.key});

  @override
  ConsumerState<Server_Error_UI> createState() => _Error_UIState();
}

class _Error_UIState extends ConsumerState<Server_Error_UI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: SafeArea(
          child: Center(
            child: kNoData(
              context,
              imagePath: "$kIconPath/signal.svg",
              title: "Oops! Server Busy",
              subtitle: "Please retry or try again after sometime.",
              action: TextButton(
                onPressed: () => ref.refresh(authFuture.future),
                child: Label("Retry").regular,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
