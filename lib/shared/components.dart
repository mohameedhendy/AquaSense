import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required String text,
  IconData? prefix,
  IconButton? suffix, // Change the type to IconButton
  required String? Function(String?)? validate,
  required TextInputType type,
  void Function(String)? onChanged,
  void Function(String)? onSubmit,
  bool obsecure = false,
  bool enable = true,
  void Function()? suffixPressed, // Change the type to a function without arguments
}) {
  return TextFormField(
    controller: controller,
    obscureText: obsecure,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      enabled: enable,
      labelText: text,
      prefixIcon: Icon(prefix),
      suffix: suffix != null ? InkWell(
        onTap: suffixPressed,
        child: suffix,
      ) : null,
    ),
    validator: validate,
    keyboardType: type,
    onChanged: onChanged,
    onFieldSubmitted: onSubmit,
  );
}

Widget defaultFormFieldLogin({
  required TextEditingController controller,
  required String text,
  IconData? prefix,
  Color prefixColor = Colors.white,
  IconButton? suffix,
  required String? Function(String?)? validate,
  required TextInputType type,
  void Function(String)? onChanged,
  void Function(String)? onSubmit,
  bool obsecure = false,
  bool enabled = true,
  void Function()? suffixPressed,
  Color focusedBorderColor = Colors.white,
  Color hintTextColor = Colors.white,
  Color cursorColor = Colors.white,
}) {
  return TextFormField(
      controller: controller,
      obscureText: obsecure,
      cursorColor: cursorColor, // Set cursor color
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: focusedBorderColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        enabled: enabled,
        hintText: text,
        hintStyle: TextStyle(color: hintTextColor),
        prefixIcon: Icon(prefix, color: prefixColor),
        suffix: suffix != null
            ? InkWell(
          onTap: suffixPressed,
          child: suffix,
        )
            : null,
      ),
      validator: validate,
      keyboardType: type,
      onChanged: onChanged,
      onFieldSubmitted: onSubmit,
      );
}

Widget defaultTextButton({
  required String text,
  required VoidCallback onPressed,
  bool isLoading = false,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      color: Colors.blue,
    ),
    width: double.infinity,
    height: 45,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    child: TextButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 3,
        ),
      )
          : Text(
        text,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  );
}

void navigaiteTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinish(context , widget) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget,),
        (route) => false
);

Widget buildDivider() => Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 10.0,
  ),
  child: Container(
    height: 0.0,
    color: Colors.grey[300],
  ),
);