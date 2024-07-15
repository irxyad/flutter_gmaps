import 'package:flutter/material.dart';
import 'package:maps_markers/core/const.dart';
import 'package:maps_markers/main.dart';

class ButtonIcon extends StatelessWidget {
  const ButtonIcon({
    Key? key,
    required this.label,
    required this.icon,
    this.onPressed,
    required this.elevation,
  }) : super(key: key);

  final String label;
  final double elevation;
  final Widget icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: ButtonStyle(
            alignment: Alignment.center,
            elevation: WidgetStateProperty.all(elevation),
            padding: WidgetStateProperty.all(
              const EdgeInsets.all(8),
            ),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)))),
        onPressed: onPressed,
        icon: icon,
        label: Text(
          label,
        ));
  }
}

class JustText extends StatelessWidget {
  const JustText(
      {super.key,
      required this.label,
      required this.icon,
      required this.bgColor});

  final Color bgColor;
  final String label;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(9),
      child: Row(
        children: [
          Icon(
            icon,
            color: MyApp.themeNotifier.value == ThemeMode.light ? black : white,
          ),
          const SizedBox(
            width: 6,
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
