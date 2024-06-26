import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'src/page/app/my_app.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}