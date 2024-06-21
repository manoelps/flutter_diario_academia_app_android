import 'package:flutter/material.dart';

mostrarSnackBar(
    {required BuildContext context,
    required String texto,
    bool isError = true}) {
  SnackBar snackBar = SnackBar(
    content: Text(
      texto,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: (isError) ? Colors.red : Colors.green,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    duration: const Duration(seconds: 4),
    action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context)
              .hideCurrentSnackBar(); //!fecha o snackbar
        }),
  );

  //mostrar snackbar na tela

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
