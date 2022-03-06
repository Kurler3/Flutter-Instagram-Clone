import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Function()? onPressFunction;
  final Color backgroundColor;
  final Color borderColor;
  final String buttonText;
  final Color textColor;
  final double buttonWidth;
  final double buttonHeight;

  const CommonButton({
    Key? key,
    required this.padding,
    required this.onPressFunction,
    required this.backgroundColor,
    required this.borderColor,
    required this.buttonText,
    required this.textColor,
    required this.buttonWidth,
    required this.buttonHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: TextButton(
        onPressed: onPressFunction,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: borderColor,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(
            buttonText,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          width: buttonWidth,
          height: buttonHeight,
        ),
      ),
    );
  }
}
