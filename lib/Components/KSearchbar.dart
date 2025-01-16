import 'package:flutter/material.dart';
import 'package:flutter_bamboo/Resources/colors.dart';
import 'package:flutter_bamboo/Resources/commons.dart';

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
      cursorColor: DColor.primary,
      style: const TextStyle(),
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      decoration: InputDecoration(
          filled: true,
          fillColor: DColor.card,
          border: OutlineInputBorder(
            borderRadius: kRadius(10),
            borderSide: BorderSide.none,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: !widget.isSearching
                ? const Icon(
                    Icons.search,
                    color: Colors.white,
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
          suffixIconConstraints:
              const BoxConstraints(minHeight: 0, minWidth: 0),
          contentPadding: const EdgeInsets.all(20),
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: DColor.fadeText)),
      onChanged: (_) => setState(() {}),
    );
  }
}
