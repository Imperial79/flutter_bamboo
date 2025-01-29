import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/kButton.dart';
import 'package:flutter_bamboo/Components/kWidgets.dart';
import 'package:flutter_bamboo/Repository/auth_repo.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Error_UI extends ConsumerStatefulWidget {
  const Error_UI({super.key});

  @override
  ConsumerState<Error_UI> createState() => _Error_UIState();
}

class _Error_UIState extends ConsumerState<Error_UI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: SafeArea(
          child: Center(
            child: kNoData(
              context,
              title: "Oops!",
              subtitle: "Something Went Wrong.",
              action: KButton(
                onPressed: () => ref.refresh(authFuture.future),
                label: "Retry",
                radius: 5,
                style: KButtonStyle.expanded,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
