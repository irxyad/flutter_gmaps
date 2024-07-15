part of '../home.dart';

// FAB to remove marker
Padding _clearMarker(BuildContext context,
    {required void Function() onPressed}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 58.0),
    child: SizedBox(
      height: 50,
      width: 50,
      child: FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: Colors.red,
          elevation: 0,
          disabledElevation: 0,
          shape: CircleBorder(
              side:
                  BorderSide(color: Theme.of(context).primaryColor, width: 5)),
          child: const Icon(
            Icons.clear,
            color: white,
            size: 18,
          )),
    ),
  );
}
