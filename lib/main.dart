import 'package:flutter/material.dart';

import 'feature/json_place_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: JsonPlaceView(),
    );
  }
}
