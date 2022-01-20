import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:que_panacea/services/auth.dart';
import 'package:que_panacea/ui/screens/authentication_screen.dart';
import './ui/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Que Panacea',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.pink,
        ),
        home: AuthenticationScreen(),
      ),
    );
  }
}



