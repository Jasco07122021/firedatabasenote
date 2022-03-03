import 'package:flutter/material.dart';

class LoadingWidgets {
  static Widget loadLinear({load}) {
    return load
        ? const Align(
            alignment: Alignment.bottomCenter,
            child: LinearProgressIndicator(
              backgroundColor: Colors.blue,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.greenAccent,
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
