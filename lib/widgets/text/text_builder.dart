import 'package:super_store_e_commerce_flutter/imports.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextBuilder extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final FontStyle? fontStyle;
  final TextDecoration? decoration;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TextBuilder({
    Key? key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.fontStyle,
    this.decoration,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        decoration: decoration,
      ),
    );
  }
}
