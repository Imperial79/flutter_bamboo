import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Components/Label.dart';
import 'package:flutter_bamboo/Components/kButton.dart';
import 'package:flutter_bamboo/Resources/colors.dart';
import 'package:flutter_bamboo/Resources/constants.dart';
import 'package:go_router/go_router.dart';

class Error_UI extends StatelessWidget {
  const Error_UI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.link_off,
                size: 100,
                color: StatusText.danger,
              ),
              Label(
                "404 Not Found",
                fontSize: 40,
                fontWeight: FontWeight.w800,
              ).title,
              Label(
                "Sorry we cannot find the requested page!",
                fontSize: 22,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
              ).title,
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kPadding),
          child: KButton(
            onPressed: () => context.go("/"),
            label: "Go Home",
          ),
        ),
      ),
    );
  }
}
