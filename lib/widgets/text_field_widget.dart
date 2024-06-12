import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';

Widget textField(
    TextEditingController controller,
    FocusNode focusNode,
    String typeName,
    IconData iconss,
    bool isPasswordVisible,
    VoidCallback? togglePasswordVisibility) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        autocorrect: false,
        focusNode: focusNode,
        obscureText: typeName.contains('Password') ? !isPasswordVisible : false,
        style: TextStyle(fontSize: 18, color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: Icon(
            iconss,
            color: focusNode.hasFocus ? custom_green : Color(0xffc5c5c5),
          ),
          suffixIcon: typeName.contains('Password')
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color:
                        focusNode.hasFocus ? custom_green : Color(0xffc5c5c5),
                  ),
                  onPressed: togglePasswordVisibility,
                )
              : null,
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          hintText: typeName,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xffc5c5c5), width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: custom_green, width: 2.0),
          ),
        ),
      ),
    ),
  );
}
