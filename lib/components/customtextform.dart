import 'package:flutter/material.dart';

class CustomTextFormSign extends StatelessWidget {
  final String hint;
  final TextEditingController mycontroller;
  final String? Function(String?) valid;
  TextInputAction? action;
  CustomTextFormSign(
      {super.key,
      required this.hint,
      required this.mycontroller,
      required this.valid,
      this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        maxLines: 5,
        minLines: 1,
        textInputAction: action,
        validator: valid,
        controller: mycontroller,
        decoration: InputDecoration(
            hintText: hint,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(10)))),
      ),
    );
  }
}
