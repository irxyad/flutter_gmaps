import 'package:flutter/material.dart';

bool showLoading(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    showDialog(
      context: context,
      builder: (context) => Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text(
                  'Sedang memproses...',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  });
  return true;
}
