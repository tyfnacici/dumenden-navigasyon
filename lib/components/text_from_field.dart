import 'package:flutter/material.dart';

Widget textFromField({
  String? hintText,
  TextEditingController? controller,
  Function(String)? onChanged,
  validator,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.text,
    validator: validator,
    onChanged: onChanged,
    decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        errorStyle: TextStyle(fontSize: 12, color: Colors.red)),
  );
}
