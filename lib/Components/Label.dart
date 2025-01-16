import 'package:flutter/material.dart';

import '../Resources/colors.dart';
import '../Resources/commons.dart';

class Label {
  final String text;
  final Color? color;
  final double? fontSize;
  final double? weight;
  final FontWeight? fontWeight;
  final int? maxLines;
  final FontStyle? fontStyle;
  final double? height;
  final TextAlign? textAlign;

  Label(
    this.text, {
    this.fontWeight,
    this.color,
    this.fontSize,
    this.weight,
    this.maxLines,
    this.fontStyle,
    this.height,
    this.textAlign,
  });

  Widget get title => Text(
        text,
        style: TextStyle(
          fontSize: fontSize ?? 20,
          color: color,
          fontVariations: [FontVariation.weight(weight ?? 500)],
          fontWeight: fontWeight ?? FontWeight.w500,
          fontStyle: fontStyle,
          height: height,
        ),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: maxLines != null ? TextOverflow.ellipsis : null,
      );
  Widget get subtitle => Text(
        text,
        style: TextStyle(
          fontSize: fontSize ?? 14,
          color: color ?? LColor.fadeText,
          fontVariations: [FontVariation.weight(weight ?? 400)],
          fontWeight: fontWeight ?? FontWeight.w400,
          fontStyle: fontStyle,
          height: height,
        ),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: maxLines != null ? TextOverflow.ellipsis : null,
      );

  Widget get spread => Center(
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            letterSpacing: 3,
            wordSpacing: 5,
            fontVariations: [FontVariation.weight(weight ?? 600)],
            fontWeight: fontWeight ?? FontWeight.w600,
            fontSize: 14,
            fontStyle: fontStyle,
            height: height,
            color: color ?? LColor.fadeText,
          ),
          textAlign: textAlign,
        ),
      );

  Widget get regular => Text(
        text,
        style: TextStyle(
          fontVariations: [FontVariation.weight(weight ?? 600)],
          fontWeight: fontWeight ?? FontWeight.w600,
          color: color,
          fontSize: fontSize,
          fontStyle: fontStyle,
          height: height,
        ),
        maxLines: maxLines,
        overflow:
            maxLines != null && maxLines! > 1 ? TextOverflow.ellipsis : null,
        textAlign: textAlign,
      );
  Widget get withDivider => Row(
        children: [
          Text(
            text.toUpperCase(),
            style: TextStyle(
              letterSpacing: .7,
              fontSize: fontSize,
              color: color,
              fontStyle: fontStyle,
              height: height,
              fontWeight: fontWeight ?? FontWeight.w500,
              fontVariations: [FontVariation.weight(weight ?? 500)],
            ),
            textAlign: textAlign,
          ),
          width5,
          const Expanded(child: Divider())
        ],
      );
}
