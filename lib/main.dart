import 'package:cwhp_flutter/provider/auth_provider.dart';
import 'package:cwhp_flutter/provider/food_provider.dart';
import 'package:cwhp_flutter/screen/auth_screen.dart';
import 'package:cwhp_flutter/screen/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider()
        ),
        ChangeNotifierProvider(
          create: (ctx) => FoodProvider()
        )
      ],
      child: MaterialApp(
        title: 'Firestore DEMO',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        
        home: Consumer<AuthProvider>(
          builder: (ctx, auth, _) {
            return auth.user != null ? HomeScreen() : AuthScreen();
          },
        ),      
      )
    );
  }
}

