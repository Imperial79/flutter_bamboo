import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Resources/colors.dart';
import 'package:flutter_bamboo/Resources/commons.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Resources/constants.dart';

class KSearchbar extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onSpeechResult;
  final void Function()? onClear;
  final bool isSearching;

  const KSearchbar({
    super.key,
    required this.controller,
    required this.hintText,
    this.onFieldSubmitted,
    this.onClear,
    this.onSpeechResult,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.isSearching = false,
  });

  @override
  State<KSearchbar> createState() => _KSearchbarState();
}

class _KSearchbarState extends State<KSearchbar> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      cursorColor: LColor.primary,
      style: const TextStyle(),
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      decoration: InputDecoration(
        filled: true,
        fillColor: LColor.scaffold,
        focusedBorder: kBorder(),
        border: kBorder(),
        enabledBorder: kBorder(),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: !widget.isSearching
              ? SvgPicture.asset(
                  "$kIconPath/search.svg",
                  colorFilter: kSvgColor(LColor.border),
                  height: 20,
                )
              : SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: kColor(context).primaryContainer,
                  ),
                ),
        ),
        suffixIconConstraints: const BoxConstraints(minHeight: 0, minWidth: 0),
        contentPadding: const EdgeInsets.all(15),
        hintText: widget.hintText,
        hintStyle: TextStyle(
            color: LColor.border,
            fontWeight: FontWeight.w600,
            fontVariations: [FontVariation.weight(600)]),
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  kBorder() => OutlineInputBorder(
        borderRadius: kRadius(10),
        borderSide: BorderSide(
          width: 2,
          color: LColor.border,
        ),
      );
}
