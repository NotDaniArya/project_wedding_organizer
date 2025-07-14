import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHelperFunction {
  // notifikasi toast
  static void toastNotification(
    String message,
    bool isSucces,
    BuildContext context,
  ) {
    toastification.show(
      context: context,
      title: Text(message, textAlign: TextAlign.center),
      autoCloseDuration: const Duration(seconds: 5),
      icon: isSucces
          ? const Icon(Icons.check_circle_outline_rounded)
          : const Icon(Icons.error_outline_rounded),
      closeButton: const ToastCloseButton(showType: CloseButtonShowType.none),
      type: isSucces ? ToastificationType.success : ToastificationType.error,
      style: ToastificationStyle.flatColored,
      alignment: Alignment.bottomCenter,
    );
  }

  // membuka URL (WhatsApp, Email, dll)
  static Future<void> launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }
}
