import 'package:flutter/material.dart';

import 'Label.dart';

Widget KHeading({required String title, required String subtitle}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 70),
    child: Center(
      child: Column(
        children: [
          Label(title, fontSize: 25, fontWeight: 800).title,
          Label(subtitle,
                  fontSize: 20, fontWeight: 200, textAlign: TextAlign.center)
              .title,
        ],
      ),
    ),
  );
}
