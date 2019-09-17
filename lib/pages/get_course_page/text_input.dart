import 'package:flutter/material.dart';
/*
  文本输入框，暂时这样写，
  TODO：改成圆角灰色的样式
  written by liuwenkiii on 2019/09/17
 */
// ignore: must_be_immutable
class TextInput extends StatelessWidget {

  final String label;
  final String hint;
  final Icon icon;
  final TextEditingController controller;
  final TextInputType type;
  final TextInputAction action;
  final onSubmitted;
  final onTap;
  final bool obscure;
  FocusNode focusNode = FocusNode();

  TextInput({
    this.label = "label",
    this.hint = "hint",
    this.icon = const Icon(Icons.info),
    this.onSubmitted,
    this.onTap,
    this.obscure = false,
    this.controller,
    this.type = TextInputType.text,
    this.action = TextInputAction.done,
    this.focusNode
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .copyWith(splashColor: Colors.transparent),
      child: TextField(
        focusNode: focusNode,
        maxLines: 1,
        keyboardType: type,
        textInputAction: action,
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            prefixIcon: icon
        ),
        onSubmitted: (_) => onSubmitted(),
        onTap: () => onTap()
      ),
    );
  }

}