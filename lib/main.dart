import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/src/views.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    home: HomeView(
      preferences: await SharedPreferences.getInstance(),
    ),
    debugShowCheckedModeBanner: false,
  ));
}
