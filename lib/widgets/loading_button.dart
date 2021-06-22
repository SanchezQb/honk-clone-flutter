import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  final String text;
  final bool loading;
  final VoidCallback onPressed;

  const LoadingButton({
    Key? key,
    required this.text,
    required this.loading,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: 250,
      height: 45,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        onPressed: onPressed,
        child: loading
            ? const SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: textTheme.headline6!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
