import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Resources/colors.dart';

import 'kTextfield.dart';

class KSearchbar extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onClear;

  const KSearchbar({
    super.key,
    required this.controller,
    required this.hintText,
    this.onFieldSubmitted,
    this.onClear,
  });

  @override
  State<KSearchbar> createState() => _KSearchbarState();
}

class _KSearchbarState extends State<KSearchbar> {
  @override
  Widget build(BuildContext context) {
    return KTextfield(
      controller: widget.controller,
      fontSize: 15,
      fieldColor: KColor.scaffold,
      prefix: const Icon(
        Icons.search,
        size: 25,
      ),
      hintText: widget.hintText,
      suffix: widget.controller.text.isNotEmpty
          ? IconButton(
              onPressed: () {
                widget.controller.clear();
                widget.onClear?.call();
                setState(() {});
              },
              icon: const Icon(
                Icons.close,
                size: 22,
              ),
              visualDensity: VisualDensity.compact,
            )
          : SizedBox(),
      onChanged: (_) => setState(() {}),
      onFieldSubmitted: widget.onFieldSubmitted,
    ).regular;
  }
}
